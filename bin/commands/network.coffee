{Computing} = require('../../lib/computing')

class @CmdHandler

    @get_parsers: (subparsers) ->
        network = subparsers.addParser('network', {addHelp: true, help: 'Perform Tiktalik Network operations'})

        subparsers = network.addSubparsers({
            title: 'Tiktalik Netowk functions',
            dest: 'subgroup'
        })
        list_network = subparsers.addParser('list', {addHelp: true, help: 'List available networks'})

        get_network = subparsers.addParser('get', {addHelp: true, help: 'Get network details'})
        get_network.addArgument(['uuid'])

    @list: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.list_networks().done((networks) ->
            for network in networks
                console.log(JSON.stringify(network.data, null, 4))
        )

    @get: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.get_image(args.uuid).done((network) ->
            console.log(JSON.stringify(network.data, null, 4))
        )        
