#!/usr/bin/python

import sys
import requests

if len(sys.argv) == 2:
  nodename = sys.argv[1]
else:
  print "You need to specify a name!"
  exit()

try: 
  f = open('.linodeapi', 'r')
  key = f.read()
except:
  print "You need to put the Linode API key in .linodeapi file!"
  exit()

url = '''https://api.linode.com/'''

payload = { 'api_key': key, 'api_action': 'linode.create', 'DatacenterID': 8, 'PlanID': 1 }
print "Creating Node..."
r = requests.post(url, params=payload)

nodeid = r.json()['DATA']['LinodeID']

payload = { 'api_key': key, 'api_action': 'linode.update', 'LinodeID': nodeid, 'Label': nodename }
print "Updating Node..."
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


udf = '{"hostname": "' + nodename + '", "privateip": "' + privateip + '"}'
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

