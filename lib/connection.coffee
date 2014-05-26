'use strict';

request = require('request')
querystring = require('querystring')
Hashes = require('jshashes')
unirest = require('unirest')
moment = require('moment')
crypto = require('crypto')
deferred = require('deferred')

class @Connection

    constructor: (@api_key, api_secret, @host="https://tiktalik.com") ->
        @api_secret_buff = new Buffer(api_secret, 'base64')

    base_url: ->
        null

    canonical_string: (method, path, headers) ->
        return [
            method,
            if headers['content-md5'] then headers['content-md5'] else '',
            if headers['content-type'] then headers['content-type'] else '',
            headers.date,
            path
        ].join('\n')

    sign_string: (str) ->
        crypto.createHmac('sha1', @api_secret_buff).update(new Buffer(str, 'utf-8')).digest('base64');

    add_auth_header: (method, path, headers) ->
        date = new Date()
        headers.date = date.toUTCString()

        canonical_string = @canonical_string(method, path, headers)
        sign_string = @sign_string(canonical_string)

        headers.Authorization = "TKAuth #{ @api_key }:#{ sign_string }"

        return headers

    params_checksum: (body) ->
        return crypto.createHash('md5').update(body).digest('hex')

    list: (method, path, Cls) ->
        ### Meta list function ###
        def = deferred()
        resp = []

        @request(method, path).done((response) =>
            for obj_data in response.body
                resp.push(new Cls(obj_data, this))

            def.resolve(resp)
        , (err) ->
          def.reject(err)
        )

        return def.promise

    get_by_uuid: (method, path, Cls, uuid) ->
        ### Fetch single network by uuid ###

        def = deferred()
        self = this

        @request(method, "#{ path }/#{ uuid }").done((response) =>
            resp = new Cls(response.body, this)
            def.resolve(resp)
        , (err) ->
            def.reject(err)
        )

        return def.promise

    request: (method='GET', path='', params=null, query_params=null, headers={}) ->
        def = deferred()

        url = @base_url() + path

        req = unirest(method, @host + url)

        if params
            body = querystring.stringify(params)
            headers['content-md5'] = @params_checksum(body)
            headers['content-type'] = 'application/x-www-form-urlencoded'
            req.send(body)

        if query_params
            req.query(query_params)

        headers = @add_auth_header(method, url, headers)

        # set headers
        req.headers(headers)

        req.as.json((response) ->
            if response.status == 200
                def.resolve(response)
            else
                def.reject(new Error("Error"))
        )

        return def.promise
