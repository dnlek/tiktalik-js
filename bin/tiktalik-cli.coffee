#!/usr/bin/env coffee
'use strict';

ArgumentParser = require('argparse').ArgumentParser;
parser = new ArgumentParser({
  version: '0.0.1',
  addHelp:true,  
  description: 'Tiktalik CLI',
})

parser.addArgument(
    ['-k', '--key'],
    {
        action: 'store',
        help: 'Set Tiktalik API key'
    }
)

parser.addArgument(
    ['-s', '--secret'],
    {
        action: 'store',
        help: 'Set Tiktalik API secret'
    }
)

subparsers = parser.addSubparsers({
  title:'Tiktalik Instances',
  dest:'group'
})

# fs = require('fs')
# dirs = fs.readdirSync('./commands')
# console.log('dirs', dirs)

cmds = ['instance', 'image']
commands = {}

for cmd in cmds
    {CmdHandler} = require("./commands/#{ cmd }")
    CmdHandler.get_parsers(subparsers)
    commands[cmd] = CmdHandler

args = parser.parseArgs();
console.dir(args);

if args.key != null
    key = args.key
else
    key = process.env.TIKTALIK_KEY

if args.secret != null
    secret = args.secret
else
    secret = process.env.TIKTALIK_SECRET

commands[args.group][args.subgroup](key, secret, args)