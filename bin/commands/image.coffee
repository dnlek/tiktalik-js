{Computing} = require('../../lib/computing')
prompt = require('prompt')
deferred = require('deferred')

class @CmdHandler

    @get_parsers: (subparsers) ->
        image = subparsers.addParser('image', {addHelp: true})

        subparsers = image.addSubparsers({
            title: 'Tiktalik Instance functions',
            dest: 'subgroup'
        })
        list_image = subparsers.addParser('list', {addHelp: true})

        get_image = subparsers.addParser('info', {addHelp: true})
        get_image.addArgument(['query'])

    @get_image: (key, secret, query) ->
        def = deferred()
        conn = new Computing(key, secret)
        conn.find_images(query).done((images) ->
            if images.length == 1
                def.resolve(images[0])
            else if images.length > 1
                i = 0
                console.log("Found more then one image (#{ images.length })")
                for image in images
                    console.log("#{ i++ }) #{ image.get('name') } (#{ image.get('uuid') })")

                prompt.get(['number'], (err, result) ->
                    def.resolve(images[result.number])
                )
            else
                console.log("Image not found")
                def.reject(new Error("Image not found"))
        )

        return def.promise

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
