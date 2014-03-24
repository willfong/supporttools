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
DB_USER = 'c'
DB_PASS = 'c'
DB_NAME = 'test'
DB_PORT = '33002'
THREADS_TO_LAUNCH = 10

SETUPSQL = []
# The first line is the command name that gets printed
SETUPSQL.append('''Create Concurrent
CREATE TABLE IF NOT EXISTS concurrent (
  id INT UNSIGNED PRIMARY KEY,
  foo DATETIME,
  bar TEXT
) ENGINE=INNODB
''')
SETUPSQL.append('''Clear Table
TRUNCATE TABLE concurrent
''')
SETUPSQL.append('''Insert first record
INSERT INTO concurrent ( id, foo, bar ) VALUES ( 1, NOW(), 'hello')
''')


class myThread (threading.Thread):
  def __init__(self, threadID, name ):
    threading.Thread.__init__(self)
    self.threadID = threadID
    self.name = name

  def run(self):
    tsprint( "Successful connection to MySQL on thread ID: {}".format(self.threadID) )
    run_query(self)


def run_query(self):
  cnx = mysql.connector.connect( host=DB_HOST, port=DB_PORT, user=DB_USER, password=DB_PASS, database=DB_NAME )
  cur = cnx.cursor()
  query = '''INSERT INTO concurrent ( id, foo, bar ) SELECT id+1, NOW(), 'hello' FROM concurrent ORDER BY id DESC LIMIT 1'''
  try:
    cur.execute( query )
  except mysql.connector.Error as err:
    tsprint("Transaction ID: " + str(self.threadID) + "; Error: " + err.msg)
  else:
    tsprint("Transaction ID: " + str(self.threadID) + "; Query Ok!")
  cnx.commit()


def launch_threads( num_threads ):
  for x in xrange(0,num_threads):
    thread = myThread(x, "Thread " + str(x) )
    thread.start()

def tsprint(text):
  print( '[ ' + time.strftime("%Y-%m-%d %H:%M:%S") + ' ] ' + text )


def reset_db():


  cnx = mysql.connector.connect( host=DB_HOST, port=DB_PORT, user=DB_USER, password=DB_PASS, database=DB_NAME )
  cursor = cnx.cursor()

  for entry in SETUPSQL:
    try:
      command, sql = entry.split('|', 1)
      tsprint("Executing: {}".format(command.strip()))
      cursor.execute(sql)
      cnx.commit()
    except mysql.connector.Error as err:
      tsprint(err.msg)
    else:
      tsprint("OK")

  cursor.close()
  cnx.close()


reset_db()
launch_threads(THREADS_TO_LAUNCH)

