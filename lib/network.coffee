
class @Network
    ### Tiktalik network representation ###

    constructor: (@data, @connection) ->

    get: (name) ->
        return @data[name]

    @get_by_uuid: (connection, uuid) ->
        ### Fetch network by uuid ###
        connection.get_network(uuid)
