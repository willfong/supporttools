#!/usr/bin/python

from __future__ import print_function

import time
import mysql.connector

from mysql.connector import errorcode


# ======================================================================

num_rows = 10            # Number of rows to insert per transaction
num_interations = 1000   # Number of transactions
sleep = 0               # Sleep before second query
commit = 'group'         # 'auto', 'group', 'row'

DB1 = {}
DB1['host'] = '128.199.239.243'
DB1['username'] = 'w'
DB1['password'] = 'password'
DB1['database'] = 'test'

DB2 = {}
DB2['host'] = '128.199.239.244'
DB2['username'] = 'w'
DB2['password'] = 'password'
DB2['database'] = 'test'


startqueries = '''
SELECT VERSION()
SHOW GLOBAL VARIABLES LIKE 'binlog_format'
SET GLOBAL wsrep_debug = ON
SHOW GLOBAL VARIABLES LIKE 'wsrep_debug'
SET GLOBAL wsrep_causal_reads = ON
SHOW GLOBAL VARIABLES LIKE 'wsrep_causal_reads'
'''


DDL = {}
DDL['drop_concurrent'] = ('''
DROP TABLE IF EXISTS concurrent
''')
DDL['create_concurrent'] = ('''
CREATE TABLE concurrent (
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  user_id INT UNSIGNED DEFAULT 0,
  bigtext VARCHAR(200) NOT NULL DEFAULT '',
  KEY (user_id),
  KEY (bigtext)
) ENGINE=INNODB
''')
DDL['drop_empty'] = ('''
DROP TABLE IF EXISTS emptytable
''')
DDL['create_empty'] = ('''
CREATE TABLE emptytable (
  id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
) ENGINE=INNODB
''')

insertquery = ('''INSERT INTO concurrent ( user_id, bigtext ) VALUES ( %s, %s )''')
updatequery = ('''UPDATE concurrent SET bigtext = %s WHERE user_id = %s''')

# Logging, 0 = disable, 1 = enable
verbose = 0
compare_global_status_node1 = 0
compare_global_status_node2 = 0
show_status_values = 1

STATUS_TO_PRINT = '''
wsrep_local_cert_failures
wsrep_local_bf_aborts
'''


# ======================================================================


def tsprint(text):
  print( '[' + time.strftime("%Y-%m-%d %H:%M:%S") + '] ' + text )

def makearray( cursor ):

  stats = {}

  for (x,y) in cursor:
    stats[x] = y

  return stats

def diffarray( stat1, stat2, title ):

  print( "\n\nChecking {}".format(title) )

  keys = stat1.keys()
  keys.sort()

  for key in keys:
    if stat1[key] != stat2[key]:
      diff1 = float(stat1[key]) if '.' in stat1[key] else int(stat1[key])
      diff2 = float(stat2[key]) if '.' in stat2[key] else int(stat2[key])
      diff = diff2 - diff1
      print( "{}\t{}\t{}\t{}".format( key.ljust(40), stat1[key].ljust(10), stat2[key].ljust(10), str(diff).ljust(10) ) )

  print( "\n\n" )

def printstatus( data, stat1, stat2, title ):

  print( "\n\n{}\t{}\t{}\t{}".format(title.ljust(40), 'Before:'.ljust(10), 'After:'.ljust(10), 'Change:'.ljust(10) ) )

  for key in [s.strip() for s in data.strip().splitlines()]:
    changed = str(int(stat2[key]) - int(stat1[key]))
    print( "{}\t{}\t{}\t{}".format( key.ljust(40), stat1[key].ljust(10), stat2[key].ljust(10), changed.ljust(10) ) )

def runqueries( cursor, query, title ):

  print( "\n{}".format(title) )

  for key in [s.strip() for s in query.strip().splitlines()]:
    try:
      cursor.execute(key)
      print( "{}\t{}".format( key.ljust(50), cursor.fetchall() ) )
    except:
      pass

print( "\nStarting Tests...\n" )
print( "Configuration:\n\tRows Per Group: {}\n\tTotal Transactions: {}\n\tSleep: {}\n\tCommit: {}\n".format( num_rows, num_interations, sleep, commit ) )
cnx1 = mysql.connector.connect( host=DB1['host'], user=DB1['username'], password=DB1['password'], database=DB1['database'] )
cnx2 = mysql.connector.connect( host=DB2['host'], user=DB2['username'], password=DB2['password'], database=DB2['database'] )
if commit == 'auto': 
  cnx1.autocommit = True
  cnx2.autocommit = True

cursor1 = cnx1.cursor()
cursor2 = cnx2.cursor()

runqueries( cursor1, startqueries, "Starting queries for Connection 1" )
runqueries( cursor1, startqueries, "Starting queries for Connection 2" )

print( "\n\n" )

cursor1.execute(DDL['drop_concurrent'])
cursor1.execute(DDL['create_concurrent'])
cursor1.execute(DDL['drop_empty'])
cursor1.execute(DDL['create_empty'])

if compare_global_status_node1 or show_status_values:
  cursor1.execute('''SHOW GLOBAL STATUS''')
  status_node1_before = makearray(cursor1)

if compare_global_status_node2 or show_status_values:
  cursor2.execute('''SHOW GLOBAL STATUS''')
  status_node2_before = makearray(cursor2)

error_num = 0

for x in xrange(0, num_interations):

  if verbose: tsprint( "Iteration: {}".format(x) )

  inserted = 0
  if commit == 'group': cursor1.execute( 'START TRANSACTION')
  try:
    for y in xrange(0, num_rows):
      if commit == 'row': cursor1.execute( 'START TRANSACTION')
      data = ( x, 'NEW' )
      cursor1.execute( insertquery, data )
      inserted += cursor1.rowcount
      if commit == 'row':
        try:
          cnx1.commit()
        except mysql.connector.Error as err:
          error_num += 1
          tsprint("%d: [ERROR %d] INSERT %s" % (x, error_num, err) )
  except mysql.connector.Error as err:
    error_num += 1
    tsprint("%d: [ERROR %d] INSERT %s" % (x, error_num, err) )

  if commit == 'group':
    try:
      cnx1.commit()
    except mysql.connector.Error as err:
      error_num += 1
      tsprint("%d: [ERROR %d] INSERT %s" % (x, error_num, err) )

  if verbose: tsprint( "  T1: Inserted {}".format(inserted) )

  if sleep: time.sleep( sleep )

  data = ( 'DONE', x )
  try:
    if commit != 'auto': cursor2.execute( 'START TRANSACTION')
    cursor2.execute( updatequery, data )
    updated = cursor2.rowcount
    if verbose: tsprint( "  T2:  Updated {}".format(updated) )
    if inserted != updated: tsprint( "%d: [WARNING] Updated didn't matched the inserted! Inserted: %d, Updated: %d" % (x, inserted, updated) )
    if commit != 'auto': cnx2.commit()
  except mysql.connector.Error as err:
    error_num += 1
    tsprint("%d: [ERROR %d] %s" % (x, error_num, err) )

  '''
  try:
    cnx2.commit()
  except mysql.connector.Error as err:
    error_num += 1
    tsprint("%d: [ERROR %d] UPDATE %s" % (x, error_num, err) )
  '''

if compare_global_status_node1 or show_status_values:
  cursor1.execute('''SHOW GLOBAL STATUS''')
  status_node1_after = makearray(cursor1)

if compare_global_status_node2 or show_status_values:
  cursor2.execute('''SHOW GLOBAL STATUS''')
  status_node2_after = makearray(cursor2)

cursor1.close()
cursor2.close()
cnx1.close()
cnx2.close()

if compare_global_status_node1: diffarray( status_node1_before, status_node1_after, "Node 1 Status" )
if compare_global_status_node2: diffarray( status_node2_before, status_node2_after, "Node 2 Status" )

if show_status_values:
  printstatus( STATUS_TO_PRINT, status_node1_before, status_node1_after, "Node 1 Status" )
  printstatus( STATUS_TO_PRINT, status_node2_before, status_node2_after, "Node 2 Status" )

print( "\n" )
