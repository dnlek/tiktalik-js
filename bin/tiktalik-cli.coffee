#!/usr/bin/env coffee
'use strict';

YAML = require('yamljs')
fs = require('fs')
path = require('path')

ArgumentParser = require('argparse').ArgumentParser;
prompt = require('prompt')
prompt.start()

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

cmds = ['instance', 'image', 'network', 'config']
commands = {}

for cmd in cmds
    {CmdHandler} = require("./commands/#{ cmd }")
    CmdHandler.get_parsers(subparsers)
    commands[cmd] = CmdHandler

args = parser.parseArgs();

config = {}
possible_config_files = [path.join(process.env.HOME, '.tiktalikjs'), './tiktalikjs']

for conf_file in possible_config_files
  if fs.existsSync(conf_file)
    config = YAML.load(conf_file)
    break

if args.key != null
  key = args.key
else if config.key
  key = config.key
else
  key = process.env.TIKTALIK_KEY

if args.secret != null
  secret = args.secret
else if config.secret
  secret = config.secret
else
  secret = process.env.TIKTALIK_SECRET

if not key or not secret
  console.log("Unauthorized")
  process.exit(1)

commands[args.group][args.subgroup](key, secret, args)
