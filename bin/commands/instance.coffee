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

        start_instance = inst_subparsers.addParser('start', {addHelp: true})
        start_instance.addArgument(['query'])

        forcestop_instance = inst_subparsers.addParser('forcestop', {addHelp: true})
        forcestop_instance.addArgument(['query'])

        backup_instance = inst_subparsers.addParser('backup', {addHelp: true})
        backup_instance.addArgument(['query'])

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

    @stop: (key, secret, args) ->
        @get_instance(key, secret, args.query).done((instance) =>
            instance.stop().done(() =>
                process.stdout.write("Operation Stop in progress")
                @std_wait_until_done(instance)
            )
        )

    @forcestop: (key, secret, args) ->
        @get_instance(key, secret, args.query).done((instance) =>
            instance.force_stop().done(() ->
                process.stdout.write("Operation Force Stop in progress")
                @std_wait_until_done(instance)
            )
        )
    @start: (key, secret, args) ->
        @get_instance(key, secret, args.query).done((instance) =>
            instance.start().done(() =>
                process.stdout.write("Operation Start in progress")
                @std_wait_until_done(instance)
            )
        )

    @backup: (key, secret, args) ->
        @get_instance(key, secret, args.query).done((instance) =>
            instance.backup().done(() ->
                process.stdout.write("Operation Backup in progress")
                @std_wait_until_done(instance)
            )
        )


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

