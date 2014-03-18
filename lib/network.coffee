
class @Network
    ### Tiktalik network representation ###

    constructor: (@data, @connection) ->

    @get_by_uuid: (connection, uuid) ->
        ### Fetch network by uuid ###
        connection.get_network(uuid)
