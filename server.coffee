class Server

  constructor: (recommendationEngine) ->
    @recommender = recommendationEngine
    @setupHttpServer()

  setupHttpServer: ->
    http = require 'http'
    @server = http.createServer (request, response) =>
      data = @testJSON()
      request.on 'data', (chunk) -> data += chunk
      request.on 'end', => @sendResponse(data, response)

  sendResponse: (data, response)->
    requestObject = JSON.parse(decodeURIComponent(data.trim()))
    switch requestObject.msg
      when 'feedback'
        content = @recommender.processFeedback(requestObject)
      when 'impression'
        content = @recommender.processImpression(requestObject)
      when 'error'
        content = @processError(requestObject)
      else
        content = @processUnknown(requestObject)
    @respond response, content

  processError: (requestObject) ->
    console.log 'Just received an error'
    content =
      code: 200
      phrase: "received 'error' request: #{requestObject.code} (#{requestObject.error})"

  processUnknown: (requestObject) ->
    console.log 'We received a message we can\'t handle'
    content =
      code: 400
      phrase: "we couldn't process the request message '#{requestObject.msg}'."

  respond: (res, content) ->
      data = JSON.stringify(
        content['data'] ?
        passphrase: content['phrase'], code: content['code']
      )

      res.writeHead content['code'],
          'Content-Type': 'application/json'
          'Content-Length': data.length
      res.write data
      res.end()

  start: (port = process.env.PORT) ->
    @server.listen port

  testJSON: ->
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

exports.Server = Server
