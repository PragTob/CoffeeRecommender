class Server

  constructor: (recommendationEngine) ->
    @recommender = recommendationEngine
    @setupHttpServer()

  setupHttpServer: ->
    http = require 'http'
    @server = http.createServer (request, response) =>
      data = '' #@testJSON()
      request.on 'data', (chunk) -> data += chunk
      request.on 'end', =>  @sendResponse(data, response)

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
    content =
      code: 200
      phrase: "received 'error' request: #{requestObject.code} (#{requestObject.error})"

  processUnknown: (requestObject) ->
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

  start: (port = process.env.PORT) -> @server.listen port

  stop: -> @server.close()

exports.Server = Server
