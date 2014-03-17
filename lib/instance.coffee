
class @Instance
    ### VPS instance representation
        
    ###

    constructor: (@data, @connection) ->

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

    @get_by_uuid: (connection, uuid) ->
        ### Fetch single instance by UUID ###
        connection.get_instance(uuid)
