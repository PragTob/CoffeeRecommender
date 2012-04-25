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
            content = @processFeedback(requestObject)
          when 'impression'
            content = @processImpression(requestObject)
          when 'error'
            content = @processError(requestObject)
          else
            content = @processUnknown(requestObject)
        @respond response, content


  @processFeedback: (requestObject) ->
    console.log 'Got feedback'
    #TODO process feedback probably
    content = 
      code: 200
      phrase: ''

  @processImpression: (requestObject) ->
    @saveItem(requestObject.item) if requestObject.item.recommendable
    recommendations = @makeRecommendation(requestObject) if requestObject.config.recommend
    content = 
      code: 200
      data: recommendations
      
  @saveItem: (item) ->
    console.log 'Save the item. Recommendable items now are:'
    @recommendables.add item
    console.log @recommendables['hash']

  @makeRecommendation: (requestObject) ->
    console.log "Let's recommend something"
    #TODO find real recommendations, for now they are 1,2,3 and 4 ;)
    recommendations = 
      items: [1, 2, 3, 4]

  @processError: (requestObject) ->
    console.log 'Just received an error'
    content = 
      code: 200
      phrase: "received 'error' request: #{requestObject.code} (#{requestObject.error})"

  @processUnknown: (requestObject) ->
    console.log 'We received a message we can\'t handle'
    content =
      code: 400
      phrase: "we couldn't process the request message '#{requestObject.msg}'."

  #TODO change to take res and value
  # helper function that responds to the client
  @respond: (res, content) ->
      data = JSON.stringify(
        content['data'] ? 
        {error: content['phrase'], code: content['code']}
      )
      
      res.writeHead content['code'],
          'Content-Type': 'application/json'
          'Content-Length': data.length
      res.write data
      #console.log res
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