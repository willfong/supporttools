import mysql.connector

cnx = mysql.connector.connect( host='192.168.7.173', user='will', password='will', database='test' )
cursor = cnx.cursor()

#cursor.execute( 'DROP PROCEDURE f2tproc')

sp = '''CREATE PROCEDURE f2tproc ( IN idgroup INT )
START TRANSACTION;
UPDATE sptest SET c = 'T' WHERE b = idgroup;
COMMIT;
END'''

cursor.execute( sp )
cursor.execute( 'CALL f2tproc(2)')
