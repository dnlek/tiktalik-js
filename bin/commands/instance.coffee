{Computing} = require('../../lib/computing')
{Handler} = require('./handler')
prompt = require('prompt')
deferred = require('deferred')

class @CmdHandler extends Handler

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
        stop_instance.addArgument(['-w', '--wait'], {
            action: 'storeTrue'
        })

        start_instance = inst_subparsers.addParser('start', {addHelp: true})
        start_instance.addArgument(['query'])
        start_instance.addArgument(['-w', '--wait'], {
            action: 'storeTrue'
        })

        forcestop_instance = inst_subparsers.addParser('forcestop', {addHelp: true})
        forcestop_instance.addArgument(['query'])
        forcestop_instance.addArgument(['-w', '--wait'], {
            action: 'storeTrue'
        })

        restart_instance = inst_subparsers.addParser('restart', {addHelp: true})
        restart_instance.addArgument(['query'])
        restart_instance.addArgument(['-w', '--wait'], {
            action: 'storeTrue'
        })

        backup_instance = inst_subparsers.addParser('backup', {addHelp: true})
        backup_instance.addArgument(['query'])
        backup_instance.addArgument(['-w', '--wait'], {
            action: 'storeTrue'
        })

        create_instance = inst_subparsers.addParser('create', {addHelp: true})
        create_instance.addArgument(['hostname'])
        create_instance.addArgument(['-s', '--size'], {
            nargs: 1
        })
        create_instance.addArgument(['-i', '--image'], {
            nargs: 1
        })
        create_instance.addArgument(['-n', '--network'], {
            nargs: '*'
        })
        create_instance.addArgument(['--ssh_key'])
        create_instance.addArgument(['-w', '--wait'], {
            action: 'storeTrue'
        })
    
    @list: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.list_instances().done((instances) ->
            for instance in instances
                console.log(instance.short())
        )

    @std_wait_until_done: (instance) ->
        def = instance.wait_until_done()
        def.on('progress', () ->
            process.stdout.write('.')
        )
        def.done((instance) =>
            process.stdout.write('done\n')
        )

    @info: (key, secret, args) ->
        @get_instance(key, secret, args.query).done((instance) ->
            console.log(JSON.stringify(instance.data, null, 4))
        )

    @instance_operation: (key, secret, operation_name, func, args) ->
        process.stdout.write("Operation #{ operation_name } in progress.")
        @get_instance(key, secret, args.query).done((instance) =>
            process.stdout.write(".")
            instance[func]().done(() =>
                if args.wait
                    @std_wait_until_done(instance)
                else
                    process.stdout.write("done (operation enqueued)\n")
            )
        )

    @stop: (key, secret, args) ->
        @instance_operation(key, secret, 'Stop', 'stop', args)

    @forcestop: (key, secret, args) ->
        @instance_operation(key, secret, 'Force Stop', 'force_stop', args)

    @start: (key, secret, args) ->
        @instance_operation(key, secret, 'Start', 'start', args)

    @restart: (key, secret, args) ->
        process.stdout.write("Operation Restart in progress.")
        @get_instance(key, secret, args.query).done((instance) =>
            process.stdout.write(".")
            instance.force_stop().done(() =>
                def = instance.wait_until_done()
                def.on('progress', () ->
                    process.stdout.write('.')
                )
                def.done((instance) =>
                    instance.start().done(() =>
                        if args.wait
                            @std_wait_until_done(instance)
                        else
                            process.stdout.write("done (operation enqueued)\n")
                    )
                )
            )
        )

    @backup: (key, secret, args) ->
        @instance_operation(key, secret, 'Backup', 'backup', args)

    @create: (key, secret, args) ->
        conn = new Computing(key, secret)

        defs = []
        defs.push(@get_image(key, secret, args.image))

        if args.network != null
            for network in args.network
                defs.push(@get_network(key, secret, network))

        deferred.apply(null, defs)((results) =>
            image = results[0]
            if args.network != null
                networks = results.slice(1, 1 + args.network.length)
            else
                networks = []

            networks_uuids = networks.map((network) ->
                return network.get('uuid')
            )
            conn.create_instance(args.hostname, args.size, image.get('uuid'), networks_uuids, args.ssh_key).done((instance) ->
                console.log('Instance created')
            )
        )