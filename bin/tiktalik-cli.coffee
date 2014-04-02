#!/usr/bin/env coffee
'use strict';

ArgumentParser = require('argparse').ArgumentParser;
parser = new ArgumentParser({
  version: '0.0.1',
  addHelp:true,  
  description: 'Tiktalik CLI',
})

subparsers = parser.addSubparsers({
  title:'Tiktalik Instances',
  dest:'group'
})

commands = {}


{InstanceCmd} = require('./commands/instance')
InstanceCmd.get_parsers(subparsers)
commands['instance'] = InstanceCmd

args = parser.parseArgs();
console.dir(args);

key = 'cOaszKCTQJYUsAISCXcjMpqddBXVKJoY'
secret = '6ayKSKRMmVQ52pm7w67rmBqTl9I2YiruW3r73BP4vfaG5Ff17pPEku+yoOA4mV9SWahQImH6kXpxUuBcNMZw/A=='

console.log('command group', args.group)
console.log('subgroup', args.subgroup)
console.log('command', commands[args.group])
commands[args.group][args.subgroup](key, secret, args)