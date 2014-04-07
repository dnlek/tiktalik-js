{Computing} = require('../../lib/computing')

class @CmdHandler

    @get_parsers: (subparsers) ->
        image = subparsers.addParser('image', {addHelp: true})

        subparsers = image.addSubparsers({
            title: 'Tiktalik Instance functions',
            dest: 'subgroup'
        })
        list_image = subparsers.addParser('list', {addHelp: true})

        get_image = subparsers.addParser('get', {addHelp: true})
        get_image.addArgument(['uuid'])

    @list: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.list_images().done((images) ->
            for image in images
                console.log(JSON.stringify(image.data, null, 4))
        )

    @get: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.get_image(args.uuid).done((image) ->
            console.log(JSON.stringify(image.data, null, 4))
        )        
