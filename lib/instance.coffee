
class @Instance
    constructor: (@data, @connection) ->

    stop: () ->
        @connection.request("POST", "/instance/#{ @data.uuid }/stop")

    start: () ->
        @connection.request("POST", "/instance/#{ @data.uuid }/start")