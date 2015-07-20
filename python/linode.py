#!/usr/bin/python

import sys
import re
import requests

datacenters = False
plans = False

try: 
  f = open('.linodeapi', 'r')
  key = f.read()
except:
  print "You need to put the Linode API key in .linodeapi file!"
  exit()

url = '''https://api.linode.com/'''

ignored_nodes = [792915, 1141795]


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
  global datacenters
  if not datacenters:
    payload = { 'api_key': key, 'api_action': 'avail.datacenters' }
    r = requests.post(url, params=payload)
    datacenters = r.json()['DATA']

  print "\n\nList of data centers\n"
  print "DC ID:\tLocation:"
  print "------\t---------\n"

  for d in datacenters:
    print "{}\t{}".format(d['DATACENTERID'], d['LOCATION'])


def list_plan():
  global plans
  if not plans:
    payload = { 'api_key': key, 'api_action': 'avail.linodeplans' }
    r = requests.post(url, params=payload)
    plans = r.json()['DATA']

  print "\n\nList of Linode plans\n"
  print "Plan:\tPrice:\tCPU:\tRAM:\tStorage:"
  print "-----\t------\t----\t----\t--------\n"

  for d in plans:
    print "{}\t${}\t{}\t{}\t{}".format(d['PLANID'], str(int(d['PRICE'])), d['CORES'], d['RAM'], d['DISK'])


def wizard_add_server():

  '''One of these days, need to verify that the DC and Plan ID's are valid'''

  list_dc()
  dc_id = raw_input( "\nWhich DC? ")

  if not dc_id.isdigit(): print "\nNot a valid datacenter ID"

  list_plan()
  plan_id = raw_input( "\nWhich plan? ")

  if not dc_id.isdigit(): print "\nNot a valid datacenter ID"

  name = raw_input( "\nName of VM? ")

  if not len(name) > 0: print "\nNeed a name!"

  payload = { 'api_key': key, 'api_action': 'linode.create', 'DatacenterID': dc_id, 'PlanID': plan_id }
  print "Creating Node..."

  try:
    r = requests.post(url, params=payload)
    nodeid = r.json()['DATA']['LinodeID']
  except:
    print "Error!"
    print r.text
    exit()

  payload = { 'api_key': key, 'api_action': 'linode.update', 'LinodeID': nodeid, 'Label': name }
  print "Updating Node... (Label: {})".format(name)
  r = requests.post(url, params=payload)

  payload = { 'api_key': key, 'api_action': 'linode.ip.addprivate', 'LinodeID': nodeid }
  print "Adding Private IP..."
  r = requests.post(url, params=payload)

  payload = { 'api_key': key, 'api_action': 'linode.ip.list', 'LinodeID': nodeid }
  r = requests.post(url, params=payload)

  print "IP Addresses:"
  for d in r.json()['DATA']:

    ip = d['IPADDRESS']

    if d['ISPUBLIC'] == 1:
      type = "Public"
    else:
      type = "Private"
      privateip = ip

    print "{} IP: {}".format( type, ip )


  udf = '{"hostname": "' + name + '", "privateip": "' + privateip + '"}'
  payload = { 'api_key': key, 'api_action': 'linode.disk.createfromstackscript', 'LinodeID': nodeid, 'StackScriptID': 9958, 'StackScriptUDFResponses': udf, 'DistributionID': 127, 'Label': 'Disk', 'Size': 22000, 'rootPass': 'rootPass123' }
  print "Adding Will's Magic..."
  r = requests.post(url, params=payload)

  diskid = r.json()['DATA']['DiskID']

  payload = { 'api_key': key, 'api_action': 'linode.config.create', 'LinodeID': nodeid, 'KernelID': 138, 'Label': 'Stock Config', 'DiskList': diskid, 'RootDeviceNum': 1 }
  print "Configuring Node..."
  r = requests.post(url, params=payload)

  payload = { 'api_key': key, 'api_action': 'linode.boot', 'LinodeID': nodeid }
  print "Booting Node..."
  r = requests.post(url, params=payload)



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

  if action == 'add server':
    wizard_add_server()


  cmd = re.findall( '^delete (\d+)$', action)
  if cmd:
    delete_vm(cmd)


  print "\nType 'help' for the help menu.\n"

  action = raw_input( "Yes, me lord? ")



print "Bye!"


