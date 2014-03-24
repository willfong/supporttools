#!/usr/bin/python

from __future__ import print_function

import time
import mysql.connector
import string
import random

from random import randint
from mysql.connector import errorcode

cnx = mysql.connector.connect( host='10.0.110.51', user='will', password='' )

cursor = cnx.cursor()

DB_NAME = 'test'
num_rows = 100

TABLES = {}
TABLES['large'] = ('''
CREATE TABLE large (
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  bigtext1 VARCHAR(200) NOT NULL DEFAULT '',
  bigtext2 VARCHAR(200) NOT NULL DEFAULT '',
  bigtext3 VARCHAR(200) NOT NULL DEFAULT '',
  KEY big1 ( bigtext1 ),
  KEY big2 ( bigtext2 )
) ENGINE=INNODB
''')

def tsprint(text):
  print( '[ ' + time.strftime("%Y-%m-%d %H:%M:%S") + ' ] ' + text )

def id_generator(size=200, chars=string.ascii_uppercase + string.digits):
  return ''.join(random.choice(chars) for x in range(size))

def create_database(cursor):
  try:
    cursor.execute(
      "CREATE DATABASE {} DEFAULT CHARACTER SET 'utf8'".format(DB_NAME))
  except mysql.connector.Error as err:
      tsprint("Failed creating database: {}".format(err))
      exit(1)


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


query = '''INSERT INTO large ( bigtext1, bigtext2, bigtext3 ) VALUES ( %s, %s, %s )'''

start = time.time()
for x in xrange(0, num_rows):
  data = ( id_generator(), id_generator(), id_generator() )
  cursor.execute( query, data )
end = time.time()
tsprint( "Transaction generated in " + str(end-start) + " seconds" )

cnx.commit()

cursor.close()
cnx.close()

