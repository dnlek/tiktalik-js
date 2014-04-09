{Computing} = require('../../lib/computing')
{Handler} = require('./handler')
prompt = require('prompt')
deferred = require('deferred')

class @CmdHandler extends Handler

    @get_parsers: (subparsers) ->
        image = subparsers.addParser('image', {addHelp: true})

        subparsers = image.addSubparsers({
            title: 'Tiktalik Instance functions',
            dest: 'subgroup'
        })
        list_image = subparsers.addParser('list', {addHelp: true})

        get_image = subparsers.addParser('info', {addHelp: true})
        get_image.addArgument(['query'])

    @list: (key, secret, args) ->
        conn = new Computing(key, secret)
        conn.list_images().done((images) ->
            for image in images
                console.log(JSON.stringify(image.data, null, 4))
        )

    @info: (key, secret, args) ->
        @get_image(key, secret, args.query).done((image) ->
            console.log(JSON.stringify(image.data, null, 4))
        )
