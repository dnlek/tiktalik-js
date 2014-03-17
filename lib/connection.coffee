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
        [
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
        console.log('canonical_string', canonical_string)
        sign_string = @sign_string(canonical_string)

        headers.Authorization = "TKAuth #{ @api_key }:#{ sign_string }"

        return headers

    request: (method='GET', path='', params=null, query_params=null, headers={}) ->
        def = deferred()

        url = @base_url() + path
        headers = @add_auth_header(method, url, headers)

        req = unirest(method, @host + url)

        # if params
        #     console.log('params?')
        #     req.form(params)

        # if query_params
        #     console.log('query_params?')
        #     req.query(query_params)

        # set headers
        req.headers(headers)

        # follow possible redirects
        # req.followAllRedirects(true)

        req.as.json((response) ->
            if response.status == 200
                def.resolve(response)
            else
                def.reject(new Error("Error"))
        )

        return def.promise