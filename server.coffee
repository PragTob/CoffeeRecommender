class Server

  set = require './Set'
  @recommendables = set.createSet()

  http = require 'http'

  @setup: =>
    @server = http.createServer (request, response) =>
      #console.log "Request: #{request.method} #{request.url}"
      data = @testJSON()
      request.on 'data', (chunk) -> data += chunk
      request.on 'end', () =>
       # console.log "Data: #{data}"
        requestObject = JSON.parse(decodeURIComponent(data.trim()))
        #console.log requestObject
        switch requestObject.msg
          when 'feedback'
            @processFeedback(requestObject)
          when 'impression'
            @processImpression(requestObject)
          when 'error'
            @processError(requestObject)
          else
            console.log 'lol?'
        @respond response, 200, 'text/plain', 'Hi'


  @processFeedback: (requestObject) ->
    console.log 'Got feedback'

  @processImpression: (requestObject) ->
    @saveItem(requestObject.item) if requestObject.item.recommendable
    @makeRecommendation(requestObject) if requestObject.config.recommend

  @saveItem: (item) ->
    console.log 'Save the item. Recommendable items now are:'
    @recommendables.add item
    console.log @recommendables

  @makeRecommendation: (requestObject) ->
    console.log "Let's recommend something"

  @processError: (requestObject) ->
    console.log 'Just received an error'

  # helper function that responds to the client
  @respond: (res, code, contentType, data) ->
      res.writeHead code,
          'Content-Type': contentType
          'Content-Length': data.length
      res.write data
      res.end()

  @start: ->
    @server.listen process.env.C9_PORT

  @testJSON: ->
    '{
      "msg":"impression",
      "id":2,
      "client":{
        "id":1
      },
      "domain":{
      	"id":2
      },
      "item":{
      	"id":5,
      	"title":"muuh",
      	"url":"google.de",
      	"created":42,
      	"text":"a cow",
      	"img":"google.de/images.jpg",
      	"recommendable":true
      },
      "context":{
      	"category":{
      		"id":77
      	}
      },
      "config":{
      	"team":{
      		"id":2
      	},
      	"timeout":200.0,
      	"recommend":true,
      	"limit":5
      },
      "version": "1.0"
    }'

Server.setup()
Server.start()