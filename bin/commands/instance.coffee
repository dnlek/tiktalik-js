{Computing} = require('../../lib/computing')

class @CmdHandler

    @get_parsers: (subparsers) ->
        instance = subparsers.addParser('instance', {addHelp: true})

        inst_subparsers = instance.addSubparsers({
            title: 'Tiktalik Instance functions',
            dest: 'subgroup'
        })
        list_instance = inst_subparsers.addParser('list', {addHelp: true})

        get_instance = inst_subparsers.addParser('info', {addHelp: true})
        get_instance.addArgument(['query'])

        stop_instance = inst_subparsers.addParser('stop', {addHelp: true})
        stop_instance.addArgument(['uuid'])

        start_instance = inst_subparsers.addParser('start', {addHelp: true})
        start_instance.addArgument(['uuid'])

        forcestop_instance = inst_subparsers.addParser('forcestop', {addHelp: true})
        forcestop_instance.addArgument(['uuid'])

        backup_instance = inst_subparsers.addParser('backup', {addHelp: true})
        backup_instance.addArgument(['uuid'])
    
    @list: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.list_instances().done((instances) ->
            for instance in instances
                console.log(instance.short())
        )

    @info: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.find_instances(args.query).done((instances) ->
            if instances.length == 1
                console.log(JSON.stringify(instances[0].data, null, 4))
            else
                console.log("Found more then one instance (#{ instances.length })")
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