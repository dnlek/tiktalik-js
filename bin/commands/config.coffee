prompt = require('prompt')
deferred = require('deferred')
YAML = require('yamljs')
fs = require('fs')
path = require('path')
{Computing} = require('../../lib/computing')

class @CmdHandler
  @get_parsers: (subparsers) ->
    config = subparsers.addParser('config', {addHelp: true})

    subparsers = config.addSubparsers({
      title: 'TiktalikJS Config functions',
      dest: 'subgroup'
    })

    init = subparsers.addParser('init', {addHelp: true})

  @init: (key, secret, args) ->
    #TODO handle per project config file
    conf_file = path.join(process.env.HOME, '.tiktalikjs')
    yesno_schema = {
      properties: {
        yesno: {
          message: 'Config file already exists, do you want to overwrite it? Please confirm [y/n]',
          required: true
        }
      }
    }
    config_schema = {
      properties: {
        key: {
          message: 'Enter your API key',
          required: true
        },
        secret: {
          message: 'Enter your API secret',
          required: true
        }
      }
    }
    if fs.existsSync(conf_file)
      prompt.get(yesno_schema, (err, result) ->
        if err || result.yesno.toLowerCase() not in ['y', 'yes']
          return

        prompt.get(config_schema, (err, result) ->
          conn = new Computing(result.key, result.secret)
          conn.list_instances().done((instances) ->
            process.stdout.write("Authentication successfull\n")
            conf_file = fs.openSync(conf_file, 'w+')
            conf_data = YAML.stringify(result, 4)
            fs.writeSync(conf_file, conf_data)
          , (err) ->
            process.stdout.write("Authentication failed\n")
          )

        )

      )
