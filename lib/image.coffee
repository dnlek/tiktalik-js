
class @Image
  ### Tiktalik image

  ###

  constructor: (@data, @connection) ->

  get: (name) ->
    return @data[name]
