{Computing} = require('../../lib/computing')

class @InstanceCmd

    @get_parsers: (subparsers) ->
        instance = subparsers.addParser('instance', {addHelp: true})

        inst_subparsers = instance.addSubparsers({
            title: 'Tiktalik Instance functions',
            dest: 'subgroup'
        })
        list_instance = inst_subparsers.addParser('list', {addHelp: true})

        get_instance = inst_subparsers.addParser('get', {addHelp: true})
        get_instance.addArgument(['uuid'])

        stop_instance = inst_subparsers.addParser('stop', {addHelp: true})
        stop_instance.addArgument(['uuid'])

        stop_instance = inst_subparsers.addParser('start', {addHelp: true})
        stop_instance.addArgument(['uuid'])

        stop_instance = inst_subparsers.addParser('forcestop', {addHelp: true})
        stop_instance.addArgument(['uuid'])

        stop_instance = inst_subparsers.addParser('backup', {addHelp: true})
        stop_instance.addArgument(['uuid'])
    
    @list: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.list_instances().done((instances) ->
            for instance in instances
                console.log(JSON.stringify(instance.data, null, 4))
        )

    @get: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.get_instance(args.uuid).done((instance) ->
            console.log(JSON.stringify(instance.data, null, 4))
        )        

    @stop: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.get_instance(args.uuid).done((instance) ->
            instance.stop().done(() ->
                console.log("Operation Stop in progress")
            )
        )

    @forcestop: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.get_instance(args.uuid).done((instance) ->
            instance.force_stop().done(() ->
                console.log("Operation Force Stop in progress")
            )
        )
    @start: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.get_instance(args.uuid).done((instance) ->
            instance.start().done(() ->
                console.log("Operation Start in progress")
            )
        )

    @backup: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.get_instance(args.uuid).done((instance) ->
            instance.backup().done(() ->
                console.log("Operation Backup in progress")
            )
        )