class Server

  http = require 'http'

  # helper function that responds to the client
  @respond: (res, code, contentType, data) ->
      res.writeHead code,
          'Content-Type': contentType
          'Content-Length': data.length
      res.write data
      res.end()

  @setup: ->
    @server = http.createServer (request, response) ->
      console.log "Request: #{request.method} #{request.url}"
      data = Server.testJSON()
      request.on 'data', (chunk) -> data += chunk
      request.on 'end', () ->
        console.log "Data: #{data}"
        requestObject = JSON.parse(decodeURIComponent(data.trim()))
        console.log requestObject
        switch requestObject.msg
          when 'feedback'
            Server.processFeedback(requestObject)
          when 'impression'
            Server.processImpression(requestObject)
          when 'error'
            Server.processError(requestObject)
          else
            console.log 'lol?'
        Server.respond response, 200, 'text/plain', 'Hi'


  @processFeedback: (requestObject) ->    console.log 'Got feedback'

  @processImpression: (requestObject) ->
    Server.saveItem(requestObject.item) if requestObject.item.recommendable
    Server.makeRecommendation(requestObject) if requestObject.config.recommend

  @saveItem: (item) ->
    console.log 'Save the item'

  @makeRecommendation: (requestObject) ->
    console.log "Let's recommend something"

  @processError: (requestObject) ->
    console.log 'Just received an error'

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