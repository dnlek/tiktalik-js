{Computing} = require('../../lib/computing')
prompt = require('prompt')
deferred = require('deferred')

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
        stop_instance.addArgument(['query'])

        start_instance = inst_subparsers.addParser('start', {addHelp: true})
        start_instance.addArgument(['query'])

        forcestop_instance = inst_subparsers.addParser('forcestop', {addHelp: true})
        forcestop_instance.addArgument(['query'])

        backup_instance = inst_subparsers.addParser('backup', {addHelp: true})
        backup_instance.addArgument(['query'])

        create_instance = inst_subparsers.addParser('create', {addHelp: true})
        create_instance.addArgument(['hostname'])
        create_instance.addArgument(['-s', '--size'])
        create_instance.addArgument(['-i', '--image'])
        create_instance.addArgument(['-n', '--network'])
        create_instance.addArgument(['--ssh_key'])
    
    @list: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.list_instances().done((instances) ->
            for instance in instances
                console.log(instance.short())
        )

    @get_instance: (key, secret, query) ->
        def = deferred()
        conn = new Computing(key, secret)
        conn.find_instances(query).done((instances) ->
            if instances.length == 1
                def.resolve(instances[0])
            else
                i = 0
                console.log("Found more then one instance (#{ instances.length })")
                for instance in instances
                    console.log("#{ i++ }) #{ instance.get('hostname') } (#{ instance.get('uuid') })")

                prompt.get(['number'], (err, result) ->
                    def.resolve(instances[result.number])
                )
        )

        return def.promise

    @info: (key, secret, args) ->
        @get_instance(key, secret, args.query).done((instance) ->
            console.log(JSON.stringify(instance.data, null, 4))
        )      

    @stop: (key, secret, args) ->
        @get_instance(key, secret, args.query).done((instance) ->
            instance.stop().done(() ->
                console.log("Operation Stop in progress")
            )
        )

    @forcestop: (key, secret, args) ->
        @get_instance(key, secret, args.query).done((instance) ->
            instance.force_stop().done(() ->
                console.log("Operation Force Stop in progress")
            )
        )
    @start: (key, secret, args) ->
        @get_instance(key, secret, args.query).done((instance) ->
            instance.start().done(() ->
                console.log("Operation Start in progress")
            )
        )

    @backup: (key, secret, args) ->
        @get_instance(key, secret, args.query).done((instance) ->
            instance.backup().done(() ->
                console.log("Operation Backup in progress")
            )
        )

    @create: (key, secret, args) ->
        conn = new Computing(key, secret)
        console.log(args)

        # conn.create_instance(args.hostname, args.size, args.image, [args.network], args.ssh_key).done((instance) ->

        # )