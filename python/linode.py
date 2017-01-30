#!/usr/bin/python

import sys
import re
import requests
import json
from subprocess import call

datacenters = False
plans = False
planstorage = {}
hosts = {}
vmid = {}
distros = []
distros.append({ 'id': 129, 'name': 'CentOS 7' })
distros.append({ 'id': 127, 'name': 'CentOS 6' })
distros.append({ 'id': 60, 'name': 'CentOS 5' })
distros.append({ 'id': 124, 'name': 'Ubuntu 14.04 LTS' })
distros.append({ 'id': 146, 'name': 'Ubuntu 16.04 LTS' })
distros.append({ 'id': 155, 'name': 'Fedora 25' })

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

transfer - Network Transfer Pool Quota
rest - Manuall call Linode API
help - This help menu
quit - Quit

'''


def transfer():
  payload = { 'api_key': key, 'api_action': 'account.info' }
  r = requests.post(url, params=payload)

  data_used = r.json()['DATA']['TRANSFER_USED']
  data_total = r.json()['DATA']['TRANSFER_POOL'] 

  print "\nTotal: {}\tUsed: {}\n".format(data_total, data_used)



def list_vms():
  global hosts
  global vmid

  payload = { 'api_key': key, 'api_action': 'linode.list' }
  r = requests.post(url, params=payload)

  print "\n\nList of current nodes:"

  vmid = {}
  counter = 0

  for d in r.json()['DATA']:

    if d['LINODEID'] not in ignored_nodes:

      # This is the counter to make it easy to delete
      counter = counter + 1
      vmid[counter] = d['LINODEID']

      if not d['LINODEID'] in hosts.keys():
        p2 = { 'api_key': key, 'api_action': 'linode.ip.list', 'LinodeID': d['LINODEID'] }
        r2 = requests.post(url, params=p2)
        hosts[d['LINODEID']] = r2.json()['DATA']

      pubip = 'None'
      priip = 'None'

      for d2 in hosts[d['LINODEID']]:

        if d2['ISPUBLIC'] == 1:
          pubip = d2['IPADDRESS']
        else:
          priip = d2['IPADDRESS']


      print "{}- {} ({})\tIP: {} ({})".format( counter, d['LABEL'], d['LINODEID'], pubip, priip)

def list_dc():
  global datacenters
  if not datacenters:
    print "Getting new list of datacenters from Linode..."
    payload = { 'api_key': key, 'api_action': 'avail.datacenters' }
    r = requests.post(url, params=payload)
    datacenters = r.json()['DATA']

  print "\n\nList of data centers\n"
  print "DC ID:\tLocation:"
  print "------\t---------\n"

  valid = []

  for d in datacenters:
    print "{}\t{}".format(d['DATACENTERID'], d['LOCATION'])
    valid.append(d['DATACENTERID'])

  return valid

def list_plan():
  global plans
  if not plans:
    print "Getting new list of plans from Linode..."
    payload = { 'api_key': key, 'api_action': 'avail.linodeplans' }
    r = requests.post(url, params=payload)
    plans = r.json()['DATA']

  print "\n\nList of Linode plans\n"
  print "Plan:\tPrice:\tCPU:\tRAM:\tStorage:"
  print "-----\t------\t----\t----\t--------\n"

  valid = []

  for d in plans:
    print "{}\t${}\t{}\t{}\t{}".format(d['PLANID'], str(int(d['PRICE'])), d['CORES'], d['RAM'], d['DISK'])
    valid.append(d['PLANID'])
    planstorage[d['PLANID']] = d['DISK']

  return valid



def list_distros():
  global distros

  print "\n\nList of distributions\n"
  print "ID:\tName:"
  print "---\t---------"

  valid = []
  for distro in distros:
    print "{}:\t{}".format(distro["id"], distro["name"])
    valid.append(distro["id"])

  return valid



def wizard_add_server():

  valid = list_dc()
  dc_id = raw_input( "\nWhich DC? ")

  try:
    if int(dc_id) not in valid:
      raise ValueError('Invalid ID')
  except:
    print "\nNot a valid datacenter ID"
    return

  valid = list_plan()
  plan_id = raw_input( "\nWhich plan? ")

  try:
    if int(plan_id) not in valid:
      raise ValueError('Invalid ID')
  except:
    print "\nNot a valid plan ID"
    return
  disksize = (int(planstorage[int(plan_id)]) - 2)*1000

  valid = list_distros()
  distro_id = raw_input( "\nWhich distro? ")

  try:
    if int(distro_id) not in valid:
      raise ValueError('Invalid ID')
  except:
    print "\nNot a valid distribution ID"
    return

  name = raw_input( "\nName of VM? ")

  if not len(name) > 0: 
    print "\nNeed a name!"
    return

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
  payload = { 'api_key': key, 'api_action': 'linode.disk.createfromstackscript', 'LinodeID': nodeid, 'StackScriptID': 9958, 'StackScriptUDFResponses': udf, 'DistributionID': distro_id, 'Label': 'Disk', 'Size': disksize, 'rootPass': 'rootPass123' }
  print "Adding Will's Magic..."
  r = requests.post(url, params=payload)

  diskid = r.json()['DATA']['DiskID']

  payload = { 'api_key': key, 'api_action': 'linode.config.create', 'LinodeID': nodeid, 'KernelID': 138, 'Label': 'Stock Config', 'DiskList': diskid, 'RootDeviceNum': 1 }
  print "Configuring Node..."
  r = requests.post(url, params=payload)

  payload = { 'api_key': key, 'api_action': 'linode.boot', 'LinodeID': nodeid }
  print "Booting Node..."
  r = requests.post(url, params=payload)



def call_rest(args):
  action = args[0]
  payload = { 'api_key': key, 'api_action': action }
  r = requests.post(url, params=payload)
  print json.dumps(r.json()["DATA"], sort_keys=True, indent=2, separators=(',', ': '))



def ssh_vm(args, cmd):

  if not int(args[0]) in vmid.keys():
    print "Invalid VM ID!"
    return

  nodeid = vmid[int(args[0])]

  pubip = 'None'
  priip = 'None'

  for d2 in hosts[nodeid]:

    if d2['ISPUBLIC'] == 1:
      pubip = d2['IPADDRESS']
    else:
      priip = d2['IPADDRESS']

  print "Connecting to: {}".format(pubip)  
  call( cmd + " " + pubip, shell=True )



def delete_vm(args):

  if not int(args[0]) in vmid.keys():
    print "Invalid VM ID!"
    return

  nodeid = vmid[int(args[0])]

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


if len(sys.argv) == 2:
  nodename = sys.argv[1]
  
  payload = { 'api_key': key, 'api_action': 'linode.list' }
  r = requests.post(url, params=payload)
  
  for d in r.json()['DATA']:
    if nodename == d['LABEL']:
      p2 = { 'api_key': key, 'api_action': 'linode.ip.list', 'LinodeID': d['LINODEID'] }
      r2 = requests.post(url, params=p2)

      pubip = 'None'
      priip = 'None'

      for d2 in r2.json()['DATA']:

        if d2['ISPUBLIC'] == 1:
          pubip = d2['IPADDRESS']
        else:
          priip = d2['IPADDRESS']
      
      print "Connecting to {} ({})".format( nodename, pubip )
      call( "ssh " + pubip, shell=True )
       

  sys.exit()

action = 'list' # default action when we first start

while action != 'quit' and action != 'exit':

  if action == '':
    # Make a default if someone hits enter
    action = 'list'

  if action == 'help':
    help()

  if action == 'transfer':
    transfer()

  if action == 'list':
    list_vms()

  if action == 'dc':
    list_dc()

  if action == 'plan':
    list_plan()

  if action == 'add server':
    wizard_add_server()

  cmd = re.findall( '^rest (.+)$', action )
  if cmd:
    call_rest(cmd)

  cmd = re.findall( '^ssh (\d+)$', action)
  if cmd:
    ssh_vm(cmd, 'ssh')

  cmd = re.findall( '^mosh (\d+)$', action)
  if cmd:
    ssh_vm(cmd, 'mosh')

  cmd = re.findall( '^delete (\d+)$', action)
  if cmd:
    delete_vm(cmd)



  print "\nType 'help' for the help menu.\n"

  action = raw_input( "> ")



print "Bye!"


