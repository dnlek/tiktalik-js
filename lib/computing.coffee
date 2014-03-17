'use strict'

{Connection} = require('./connection')
{Instance} = require('./instance')
deferred = require('deferred')

class @Computing extends Connection

    base_url: ->
        '/api/v1/computing'

    list_instances: ->
        resp = []
        def = deferred()
        self = this

        @request('GET', '/instance').done((response) -> 
            for instance in response.body
                resp.push(new Instance(instance, self))

            def.resolve(resp)
        )

        return def.promise

    get_instance: (uuid) ->
        def = deferred()
        self = this

        @request('GET', "/instance/#{ uuid }").done((response) -> 
            console.log('got instance');
            resp = new Instance(response.body, self)
            def.resolve(resp)
        )

        return def.promise        

