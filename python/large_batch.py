#!/usr/bin/python

from __future__ import print_function

import threading
import time
import mysql.connector
import string
import random

from random import randint
from mysql.connector import errorcode


DB_NAME = 'test'
DB_HOST = '10.130.252.19'
DB_USER = 'c'
DB_PASS = 'c'

cnx = mysql.connector.connect( host=DB_HOST, user=DB_USER, password=DB_PASS )

cursor = cnx.cursor()



TABLES = {}
TABLES['table1'] = ('''
CREATE TABLE table1 (
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  digits INT UNSIGNED,
  bigtext1 VARCHAR(200) NOT NULL DEFAULT '',
  bigtext2 VARCHAR(200) NOT NULL DEFAULT '',
  KEY big1 ( bigtext1 ),
  KEY big2 ( digits )
) ENGINE=INNODB
''')
TABLES['table2'] = ('''
CREATE TABLE table2 (
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  digits INT UNSIGNED,
  bigtext1 VARCHAR(200) NOT NULL DEFAULT '',
  bigtext2 VARCHAR(200) NOT NULL DEFAULT '',
  KEY big1 ( bigtext1 ),
  KEY big2 ( digits )
) ENGINE=INNODB
''')
TABLES['table3'] = ('''
CREATE TABLE table3 (
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  digits INT UNSIGNED,
  bigtext1 VARCHAR(200) NOT NULL DEFAULT '',
  bigtext2 VARCHAR(200) NOT NULL DEFAULT '',
  KEY big1 ( bigtext1 ),
  KEY big2 ( digits )
) ENGINE=INNODB
''')

def tsprint(text):
  print( '[ ' + time.strftime("%Y-%m-%d %H:%M:%S") + ' ] ' + text )

def text_generator(size=200, chars=string.ascii_uppercase + string.digits):
  return ''.join(random.choice(chars) for x in range(size))

def num_generator(size=5):
  return ''.join(random.choice(string.digits) for x in range(size))

def create_database(cursor):
  try:
    cursor.execute(
      "CREATE DATABASE {} DEFAULT CHARACTER SET 'utf8'".format(DB_NAME))
  except mysql.connector.Error as err:
      tsprint("Failed creating database: {}".format(err))
      exit(1)


class myThread (threading.Thread):
  def __init__(self, threadID, name, num_txns, num_rows, tablenum ):
    threading.Thread.__init__(self)
    self.threadID = threadID
    self.name = name
    self.num_txns = num_txns
    self.num_rows = num_rows
    self.tablenum = tablenum

  def run(self):
    tsprint( "Starting " + self.name )
    run_query(self.name, self.num_txns, self.num_rows, self.tablenum)
    tsprint( "Exiting " + self.name )

def run_query(threadName, num_txns, num_rows, tablenum):
  cnx = mysql.connector.connect( host=DB_HOST, user=DB_USER, password=DB_PASS, database=DB_NAME )
  cursor = cnx.cursor()
  query = '''INSERT INTO table'''+tablenum+''' ( digits, bigtext1, bigtext2 ) VALUES ( %s, %s, %s )'''

  for y in xrange(0,num_txns):
    start = time.time()
    #tsprint( threadName + " - Starting Transaction: " + str(y) )
    for x in xrange(0, num_rows):
      data = ( num_generator(), text_generator(), text_generator() )
      cursor.execute( query, data )
    end = time.time()
    #tsprint( "Committing Transaction: " + str(y) )
    cnx.commit()
    endcommit = time.time()
    tsprint( threadName + " - Transaction generated in " + str(end-start) + " and took " + str(endcommit-end) + " to commmit." )




def launch_threads( num_threads, txn, rows, tablenum ):
  for x in xrange(0,num_threads):
    thread = myThread(x, "Thread " + str(x), txn, rows, tablenum )
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


launch_threads( 5, 1000, 50, '1' )

launch_threads( 5, 1000, 50, '2' )

launch_threads( 5, 1000, 50, '3' )

