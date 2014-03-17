'use strict'

{Connection} = require('./connection')
{Instance} = require('./instance')
deferred = require('deferred')

class @Computing extends Connection

    base_url: ->
        '/api/v1/computing'

    list_instances: ->
        ### Fetch all user instances ###
        
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
        ### Fetch single instance by uuid ###

        def = deferred()
        self = this

        @request('GET', "/instance/#{ uuid }").done((response) -> 
            console.log('got instance');
            resp = new Instance(response.body, self)
            def.resolve(resp)
        )

        return def.promise

    create_instance: (hostname, size, image_uuid, networks, ssh_key=null) ->
        ### Create new Tiktalik Instance ###

        def = deferred()
        self = this

        params = {
            'hostname': hostname,
            'size': size,
            'image_uuid': image_uuid,
            'networks[]': networks
        }

        @request('POST', "/instance", params).done((response) -> 
            resp = new Instance(response.body, self)
            def.resolve(resp)
        )

        return def.promise               

