deferred = require('deferred')

class @Instance
    ### VPS instance representation
        
    ###

    constructor: (@data, @connection) ->

    get: (name) ->
        return @data[name]

    is_running: () ->
        return @data.state == 12 && @data.running == true

    is_waiting: () ->
        return @data.actions_pending_count > 0

    status_str: () ->
        if @is_running()
            return 'running'.green
        else
            return 'stoped'

    ips: () ->
        ret = []
        for iface in @data.interfaces
            ret.push(iface.ip)

        return ret

    short_info: () ->
        return "#{ @data.hostname } (ip: #{ @ips().join(', ') }, running: #{ @is_running() }, uuid: #{ @data.uuid })"

    full_info: () ->
        str = "\n"
        str += "Hostname:         #{ @data.hostname }\n"
        str += "UUID:             #{ @data.uuid }\n"
        str += "Status:           #{ @status_str() }\n"
        str += "IPs:              #{ @ips().join(', ') }\n"
        str += "Image UUID:       #{ @data.image_uuid }\n"
        str += "Size ID:          #{ @data.size }\n"
        return str

    stop: () ->
        ### Stops instance (using acpi) ###
        @connection.request('POST', "/instance/#{ @data.uuid }/stop")

    force_stop: () ->
        ### Forces instance shutdown ###
        @connection.request('POST', "/instance/#{ @data.uuid }/force_stop")

    start: () ->
        ### Starts instance ###
        @connection.request('POST', "/instance/#{ @data.uuid }/start")

    backup: () ->
        ### Creates instance backup ###
        @connection.request('POST', "/instance/#{ @data.uuid }/backup")

    destroy: () ->
        ### Destroys instance ###
        @connection.request('DELETE', "/instance/#{ @data.uuid }")

    restart: () ->
        def = deferred()

        @stop().done(() =>
            @wait_until_done().done(() =>
                @start().done(() =>
                    def.resolve()
                )
            )
        )

        return def.promise

    get_interfaces: () ->
        ### List instance network interfaces ###
        @connection.request('GET', "/instance/#{ @data.uuid }/interface")

    add_interface: (network_uuid, seq=null) ->
        ### Adds network interface for instance 
            
            @param network_uuid UUID of selected network
            @param seq sequential number of network interface
        ###

        params = {
            'network_uuid': network_uuid,
            'seq': seq
        }

        @connection.request('POST', "/instance/#{ @data.uuid }/interface", params)

    remove_interface: (net_iface_uuid) ->
        ### Removes instance network interface 
            
            @param net_iface_uuid UUID of instance network interface to be removed
        ###

        @connection.request('DELETE', "/instance/#{ @data.uuid }/interface#{ net_iface_uuid }")

    update: (instance) ->
        @data = instance.data

    wait_until_done: () ->
        ### Wait for current operation on instance ###
        def = deferred()
        @__wait_until_done(def)
        return def.promise

    fetch: () ->
        ### Fetches instance data ###
        def = deferred()
        @connection.get_instance(@data.uuid).done((instance) =>
            @update(instance)
            def.resolve(this)
        )

        return def.promise

    @get_by_uuid: (connection, uuid) ->
        ### Fetch single instance by UUID ###
        connection.get_instance(uuid)

    __wait_until_done: (def) ->
        ### Fetch instance, check state - repeat ###
        @fetch().done((instance) =>
            if @is_waiting()
                setTimeout(() =>
                    def.promise.emit('progress');
                    @__wait_until_done(def);
                , 2 * 1000)
            else
                def.resolve(instance)
        )