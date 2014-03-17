
class @Instance
    ### VPS instance representation
        
    ###

    constructor: (@data, @connection) ->

    stop: () ->
        ### Stops instance (using acpi) ###
        @connection.request("POST", "/instance/#{ @data.uuid }/stop")

    force_stop: () ->
        ### Forces instance shutdown ###
        @connection.request("POST", "/instance/#{ @data.uuid }/force_stop")

    start: () ->
        ### Starts instance ###
        @connection.request("POST", "/instance/#{ @data.uuid }/start")

    backup: () ->
        ### Creates instance backup ###
        @connection.request("POST", "/instance/#{ @data.uuid }/backup")

    list_interfaces: () ->
        ### List instance network interfaces ###

    add_interface: (network_uuid) ->
        ### Adds network interface for instance ###

    remove_interface: () ->
        ### Removes instance network interface ###

    @get_by_uuid: (connection, uuid) ->
        ### Fetch single instance by UUID ###
        connection.get_instance(uuid)
