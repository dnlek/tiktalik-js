'use strict'

{Connection} = require('./connection')
{Instance} = require('./instance')
{Image} = require('./image')
{Network} = require('./network')
deferred = require('deferred')

class @Computing extends Connection

    base_url: ->
        '/api/v1/computing'

    list_instances: ->
        ### Fetch all user instances ###
        return @list('GET', '/instance', Instance)

    get_instance: (uuid) ->
        ### Fetch single instance by uuid ###
        return @get_by_uuid('GET', '/instance', Instance, uuid)

    create_instance: (hostname, size, image_uuid, networks, ssh_key=null) ->
        ### Create new Tiktalik Instance ###

        def = deferred()

        params = {
            'hostname': hostname,
            'size': size,
            'image_uuid': image_uuid,
            'networks[]': networks
        }

        @request('POST', "/instance", params).done((response) => 
            resp = new Instance(response.body, this)
            def.resolve(resp)
        )

        return def.promise               


    list_networks: () ->
        ### List available networks ###
        return @list('GET', '/network', Network)

    get_network: (uuid) ->
        ### Fetch single network by uuid ###
        return @get_by_uuid('GET', '/network', Network, uuid)

    list_images: () ->
        ### List available images ###
        return @list('GET', '/image', Image)

    get_image: (uuid) ->
        ### Get single image by uuid ###
        return @get_by_uuid('GET', '/image', Image, uuid)
