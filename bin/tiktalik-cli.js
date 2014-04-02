#!/usr/bin/env node
'use strict';

var ArgumentParser = require('argparse').ArgumentParser;
var parser = new ArgumentParser({
  version: '0.0.1',
  addHelp:true,  
  description: 'Tiktalik CLI',
});

var subparsers = parser.addSubparsers({
  title:'Tiktalik Instances',
  dest:'group'
});

var instance = subparsers.addParser('instance', {addHelp: true});

var inst_subparsers = instance.addSubparsers({
    title: 'Tiktalik Instance functions',
    dest: 'subgroup'
});

var list_instance = inst_subparsers.addParser('list', {addHelp: true});

var get_instance = inst_subparsers.addParser('get', {addHelp: true});
get_instance.addArgument(['uuid']);

var args = parser.parseArgs();
console.dir(args);

require('./' + args.group + '/' + args.subgroup);