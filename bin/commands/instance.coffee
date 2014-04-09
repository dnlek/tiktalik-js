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
        console.log(args)

        # conn.create_instance(args.hostname, args.size, args.image, [args.network], args.ssh_key).done((instance) ->

        # )