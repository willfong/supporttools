#!/usr/bin/python

import sys
import re
import requests

try: 
  f = open('.linodeapi', 'r')
  key = f.read()
except:
  print "You need to put the Linode API key in .linodeapi file!"
  exit()

url = '''https://api.linode.com/'''

ignored_nodes = [587382]


def help():

  print '''\nAvailable commands:

list - List nodes

delete - Delete VM node

help - This help menu
quit - Quit

'''


def list_vms():

  payload = { 'api_key': key, 'api_action': 'linode.list' }
  r = requests.post(url, params=payload)

  print "\n\nList of current nodes:"

  for d in r.json()['DATA']:

    if d['LINODEID'] not in ignored_nodes:
      p2 = { 'api_key': key, 'api_action': 'linode.ip.list', 'LinodeID': d['LINODEID'] }
      r2 = requests.post(url, params=p2)

      pubip = 'None'
      priip = 'None'

      for d2 in r2.json()['DATA']:

        if d2['ISPUBLIC'] == 1:
          pubip = d2['IPADDRESS']
        else:
          priip = d2['IPADDRESS']


      print "ID: {} \tName: {}\tPublic IP: {}\tPrivate IP: {}".format( d['LINODEID'], d['LABEL'], pubip, priip)


def list_dc():

  payload = { 'api_key': key, 'api_action': 'avail.datacenters' }
  r = requests.post(url, params=payload)

  print "\n\nList of data centers\n"
  print "DC ID:\tLocation:"
  print "------\t---------\n"

  for d in r.json()['DATA']:
    print "{}\t{}".format(d['DATACENTERID'], d['LOCATION'])


def list_plan():

  payload = { 'api_key': key, 'api_action': 'avail.linodeplans' }
  r = requests.post(url, params=payload)

  print "\n\nList of Linode plans\n"
  print "Plan:\tPrice:\tCPU:\tRAM:\tStorage:"
  print "-----\t------\t----\t----\t--------\n"

  for d in r.json()['DATA']:
    print "{}\t${}\t{}\t{}\t{}".format(d['PLANID'], str(int(d['PRICE'])), d['CORES'], d['RAM'], d['DISK'])


def delete_vm(args):

  nodeid = args[0]

  batch = '[{"api_action": "linode.shutdown", "LinodeID": '+str(nodeid)+'},'

  payload = { 'api_key': key, 'api_action': 'linode.disk.list', 'LinodeID': nodeid }
  r = requests.post(url, params=payload)
  print r.json()

  for d in r.json()['DATA']:
    diskid = d['DISKID']
    batch = batch + '{"api_action": "linode.disk.delete", "LinodeID": '+str(nodeid)+', "DiskID": '+str(diskid)+'},'

  batch = batch + '{"api_action": "linode.delete", "LinodeID": '+str(nodeid)+'}]'

  payload = { 'api_key': key, 'api_action': 'batch', "api_requestArray": batch }
  r = requests.post(url, params=payload)
  print r.json() 



action = 'list' # default action when we first start

while action != 'quit':

  if action == '':
    # Make a default if someone hits enter
    action = 'list'

  if action == 'help':
    help()

  if action == 'list':
    list_vms()

  if action == 'dc':
    list_dc()

  if action == 'plan':
    list_plan()

  cmd = re.findall( '^delete (\d+)$', action)
  if cmd:
    delete_vm(cmd)


  print "\nType 'help' for the help menu.\n"

  action = raw_input( "Yes, me lord? ")



print "Bye!"


