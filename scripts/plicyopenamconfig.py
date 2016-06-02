#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2016, Andrii Petruk <andrey.petruk@gmail.com>

# 
#
#

import urllib
import requests
import threading
import os
import json
#import amlib

class AMConnection:
    def __init__(self, url, admin, password):
        self.url = url
        authheaders =  {"Content-type": "application/json",
            "X-OpenAM-Username": admin ,
            "X-OpenAM-Password": password}
        authurl = url + "/json/authenticate"
        r = requests.post(authurl, data="{}", headers=authheaders)
        t = json.loads(r.text)
        id =   t['tokenId']
        r.close()
        self.id = id

def createPolicy(openam, uuid, PolicySets, policy_name, policy_description, policy_actionvalues, policy_resources, policy_subject):
    body = '{ "name": "'+policy_name+'", "active": true, "description": "'+policy_description+'", "applicationName": "'+PolicySets+'", "actionValues": { '+policy_actionvalues+' }, "resources": [ '+policy_resources+' ], "subject": '+policy_subject+', "resourceTypeUuid": "'+uuid+'" }'
    #print body
    url = openam.url + "/json/policies?_action=create"
    headers = {"Content-type": "application/json",
        "iplanetDirectoryPro": openam.id }
    response = requests.post(url, data=body, headers=headers)
    print response.text
    response.close()


def getResourceTypeUuid(openam,PolicySets):
    url = openam.url + "/json/applications/"+PolicySets+"?_fields=resourceTypeUuids"
    headers = {"iplanetDirectoryPro": openam.id }
    response = requests.get(url, headers=headers)
    data = response.json()
    return data['resourceTypeUuids'][0]
    response.close()

def createAgen(openam, username, password, fqdn, agenturl):
    url = openam.url + "/json/agents/?_action=create"
    headers = {"Content-type": "application/json",
        "iplanetDirectoryPro": openam.id }
    body = '{"username":"'+username+'", "com.sun.identity.agents.config.fqdn.default": ["'+fqdn+'"], "com.sun.identity.agents.config.repository.location": ["centralized"], "agenttype":["WebAgent"], "serverurl":["'+openam.url+'"], "agenturl":["'+agenturl+'"], "userpassword":["'+password+'"], "com.sun.identity.agents.config.login.url": ["[0]='+openam.url+'/UI/Login"], "com.sun.identity.agents.config.logout.url": ["[0]='+openam.url+'/UI/Logout"], "sunidentityserverdevicestatus":["Active"] }'
    response = requests.post(url, data=body, headers=headers)
    print response.text 
    response.close()

def main():
    base_url = "http://mantlam01.cisco.com:8081/openam"
    PolicySets      = "iPlanetAMWebAgentService"
    openam_login = "amadmin"
    openam_password = "password"
    openam = AMConnection(base_url,openam_login,openam_password)
    uuid = getResourceTypeUuid(openam, PolicySets)

    policy_name = ["admin_acl", "kubernetes_acl", "mesos_acl"]
    policy_description = ["access fro admin(full)", "Marathon and Kubernetes access", "Mesos access"]
    policy_actionvalues = ['"POST": true, "GET": true', '"POST": true, "GET": true', '"POST": true, "GET": true']
    policy_resources = ['"http://mantlctr01.cisco.com:80/mesos/*"', '"http://mantlctr01.cisco.com:80/marathon/*"', '"http://mantlctr01.cisco.com:80/Kubernetes/*"', '"http://mantlctr01.cisco.com:80/Consul/*"',  '"http://mantlctr01.cisco.com:80/Traefik/*"'] 
    policy_subject = ['{ "type": "Identity", "subjectValues": [ "uid=demo,ou=People,dc=example,dc=com" ] }', '{ "type": "Identity", "subjectValues": [ "uid=demo,ou=People,dc=example,dc=com" ] }', '{ "type": "Identity", "subjectValues": [ "uid=demo,ou=People,dc=example,dc=com" ] }', '{ "type": "Identity", "subjectValues": [ "uid=demo,ou=People,dc=example,dc=com" ] }', '{ "type": "Identity", "subjectValues": [ "uid=demo,ou=People,dc=example,dc=com" ] }']
    agent_username = "myAgent"
    agent_password = "superpass"
    agent_fqdn = "mantlctr01.cisco.com"
    agent_prefix = "http://"
    agent_port  = "80"
    agent_url = agent_prefix+agent_fqdn+':'+agent_port+'/'
    

    createAgen(openam, agent_username, agent_password, agent_fqdn, agent_url)
 
    i=0 
    while i <= len(policy_name) - 1:
       createPolicy(openam, uuid, PolicySets, policy_name[i], policy_description[i], policy_actionvalues[i], policy_resources[i], policy_subject[i])
       i += 1 


main()

