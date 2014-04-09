{Computing} = require('../../lib/computing')
prompt = require('prompt')
deferred = require('deferred')

class @Handler

    @get_instance: (key, secret, query) ->
        def = deferred()
        conn = new Computing(key, secret)
        conn.find_instances(query).done((instances) ->
            if instances.length == 1
                def.resolve(instances[0])
            else if instances.length > 1
                i = 0
                console.log("Found more then one instance (#{ instances.length })")
                for instance in instances
                    console.log("#{ i++ }) #{ instance.get('hostname') } (#{ instance.get('uuid') })")

                prompt.get(['number'], (err, result) ->
                    def.resolve(instances[result.number])
                )
            else
                console.log("Instance not found")
                def.reject(new Error("Instance not found"))
        )

        return def.promise

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