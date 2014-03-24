#!/usr/bin/python

from __future__ import print_function

import threading
import time
import mysql.connector
import string
import random

from random import randint
from mysql.connector import errorcode


DB_HOST = 'localhost'
DB_SOCKET = '/mim/instance/7/mysql.sock'
DB_NAME = 'test'
DB_USER = 'will'
DB_PASS = 'will'

cnx = mysql.connector.connect( host=DB_HOST, unix_socket=DB_SOCKET, user=DB_USER, password=DB_PASS )

cursor = cnx.cursor()



TABLES = {}
TABLES['table1'] = ('''
CREATE TABLE `fcc_cards` (
`cardid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
`carddbid` int(10) unsigned NOT NULL DEFAULT '0',
`type` tinyint(3) unsigned NOT NULL DEFAULT '0',
`usecount` int(10) unsigned NOT NULL DEFAULT '0',
`userid` bigint(20) unsigned NOT NULL,
`decktype` tinyint(3) unsigned NOT NULL,
`timestamp` int(11) NOT NULL,
`state` tinyint(3) unsigned NOT NULL DEFAULT '0',
`owners` int(10) unsigned NOT NULL,
`attribute7` tinyint(3) unsigned NOT NULL DEFAULT '80',
`attribute8` tinyint(3) unsigned NOT NULL DEFAULT '99',
`stat1` int(10) unsigned NOT NULL DEFAULT '0',
`stat2` int(10) unsigned NOT NULL DEFAULT '0',
`stat3` int(10) unsigned NOT NULL DEFAULT '0',
`stat4` int(10) unsigned NOT NULL DEFAULT '0',
`stat5` int(10) unsigned NOT NULL DEFAULT '0',
`lifestat1` int(10) unsigned NOT NULL DEFAULT '0',
`lifestat2` int(10) unsigned NOT NULL DEFAULT '0',
`lifestat3` int(10) unsigned NOT NULL DEFAULT '0',
`lifestat4` int(10) unsigned NOT NULL DEFAULT '0',
`lifestat5` int(10) unsigned NOT NULL DEFAULT '0',
`injury` tinyint(3) unsigned NOT NULL DEFAULT '0',
`injuryduration` tinyint(3) unsigned NOT NULL DEFAULT '0',
`formationid` tinyint(3) unsigned NOT NULL DEFAULT '1',
`preferredposition` tinyint(3) unsigned NOT NULL DEFAULT '1',
`trainingcard` int(10) unsigned NOT NULL DEFAULT '0',
`lastsaleprice` int(10) unsigned NOT NULL DEFAULT '0',
PRIMARY KEY (`userid`,`cardid`),
UNIQUE KEY `cardid` (`cardid`),
KEY `userid_decktype_state` (`userid`,`decktype`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
''')


def tsprint(text):
  print( '[ ' + time.strftime("%Y-%m-%d %H:%M:%S") + ' ] ' + text )

def num_generator(size=2):
  return ''.join(random.choice(string.digits) for x in range(size))

def create_database(cursor):
  try:
    cursor.execute(
      "CREATE DATABASE {} DEFAULT CHARACTER SET 'utf8'".format(DB_NAME))
  except mysql.connector.Error as err:
      tsprint("Failed creating database: {}".format(err))
      exit(1)


class myThread (threading.Thread):
  def __init__(self, num_txns ):
    threading.Thread.__init__(self)
    self.num_txns = num_txns

  def run(self):
    #tsprint( "Starting " + self.name )
    run_query(self.num_txns)
    #tsprint( "Exiting " + self.name )

def run_query(num_txns):
  for x in xrange(0, num_txns):
    cnx = mysql.connector.connect( host=DB_HOST, unix_socket=DB_SOCKET, user=DB_USER, password=DB_PASS, database=DB_NAME )
    cursor = cnx.cursor(prepared=True)
    query = '''insert into fcc_cards (carddbid,type,usecount,userid,decktype,timestamp,state,owners,attribute7,attribute8,stat1,stat2,stat3,stat4,stat5,lifestat1,lifestat2,lifestat3,lifestat4,lifestat5,injury,injuryduration,formationid,preferredposition,trainingcard) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)'''
    data = (num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator(),num_generator())
    cursor.execute( query, data )
    cnx.commit()
    cursor.close()
    cnx.close()



def launch_threads( num_threads, num_txns ):
  for x in xrange(0,num_threads):
    thread = myThread(num_txns)
    thread.start()


try:
  cnx.database = DB_NAME
except mysql.connector.Error as err:
  if err.errno == errorcode.ER_BAD_DB_ERROR:
    create_database(cursor)
    cnx.database = DB_NAME
  else:
    tsprint(err)
    exit(1)


for name, ddl in TABLES.iteritems():
  try:
    tsprint("Creating table {}: ".format(name))
    cursor.execute(ddl)
  except mysql.connector.Error as err:
    if err.errno == errorcode.ER_TABLE_EXISTS_ERROR:
      tsprint("already exists.")
    else:
      tsprint(err.msg)
  else:
    tsprint("OK")

cursor.close()
cnx.close()


launch_threads( 2, 5000000 )

#launch_threads( 5, 1000, 50, '2' )

#launch_threads( 5, 1000, 50, '3' )
