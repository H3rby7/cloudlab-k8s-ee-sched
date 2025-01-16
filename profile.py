#!/usr/bin/env python

import geni.portal as portal
import geni.rspec.pg as RSpec
import geni.rspec.igext as IG
# Emulab specific extensions.
import geni.rspec.emulab as emulab
from lxml import etree as ET
import crypt
import random
import os
import hashlib
import os.path
import sys

TBCMD = "sudo mkdir -p /local/setup && sudo chown `geni-get user_urn | cut -f4 -d+` /local/setup && sudo -u `geni-get user_urn | cut -f4 -d+` -Hi /bin/bash -c '/local/repository/setup-driver.sh >/local/logs/setup.log 2>&1'"

#
# For now, disable the testbed's root ssh key service until we can remove ours.
# It seems to race (rarely) with our startup scripts.
#
disableTestbedRootKeys = True

#
# Create our in-memory model of the RSpec -- the resources we're going
# to request in our experiment, and their configuration.
#
rspec = RSpec.Request()

#
# This geni-lib script is designed to run in the CloudLab Portal.
#
pc = portal.Context()

#
# Define some parameters.
#
pc.defineParameter(
    "nodeCount","Number of Nodes",
    portal.ParameterType.INTEGER,1,
    longDescription="Number of nodes.")

#
# Get any input parameter values that will override our defaults.
#
params = pc.bindParameters()

#
# Give the library a chance to return nice JSON-formatted exception(s) and/or
# warnings; this might sys.exit().
#
pc.verifyParameters()

#
# General kubernetes instruction text.
#
kubeInstructions = \
  """
## Test exposing params via profile instructions:

    host-node-0 {host-node-0} (this is just the address of node-0, not the public addr)

Failed attempts below:

Test varaints to display the public IP:

    node-0: {node-0}
    node-0-ipv4: {node-0-ipv4}
    node-0-ipv4-address: {node-0-ipv4-address}
    ipv4: {ipv4}
    ipv4-address: {ipv4-address}
    node-0-address: {node-0-address}

"""

#
# Customizable area for forks.
#
tourDescription = \
  "This profile attempts placeholder replacement to get the public IP addr."

tourInstructions = kubeInstructions

#
# Setup the Tour info with the above description and instructions.
#  
tour = IG.Tour()
tour.Description(IG.Tour.TEXT,tourDescription)
tour.Instructions(IG.Tour.MARKDOWN,tourInstructions)
rspec.addTour(tour)

nodes = dict({})

for i in range(0,params.nodeCount):
    nodename = "node-%d" % (i,)
    node = RSpec.RawPC(nodename)
    if TBCMD is not None:
        node.addService(RSpec.Execute(shell="sh",command=TBCMD))
    if disableTestbedRootKeys:
        node.installRootKeys(False, False)
    nodes[nodename] = node

for nname in nodes.keys():
    rspec.addResource(nodes[nname])

#
# Grab on public IP address for nginx.
#
apool = IG.AddressPool("node-0", 1)
rspec.addResource(apool)

pc.printRequestRSpec(rspec)
