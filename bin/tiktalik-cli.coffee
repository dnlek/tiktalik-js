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

cmds = ['instance']
commands = {}

for cmd in cmds
    {CmdHandler} = require("./commands/#{ cmd }")
    CmdHandler.get_parsers(subparsers)
    commands[cmd] = CmdHandler

args = parser.parseArgs();
console.dir(args);


commands[args.group][args.subgroup](key, secret, args)