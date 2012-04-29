http = require 'http'

class RequestMaker

  constructor: (@port) -> @completeData = ''

  post: (sendData) ->
    @completeData = ''
    options = @postOptions()
    request = http.request options, (response) =>
      responseData = ''
      response.on 'data', (chunk) -> responseData += chunk
      response.on 'end', => @completeData = responseData

    request.end sendData

  postOptions: ->
    options =
      host: '0.0.0.0',
      port: @port,
      path: '/',
      method: 'POST'

  completed: -> @completeData != ''

  jsonResponse: -> JSON.parse(decodeURIComponent(@completeData.trim()))

exports.RequestMaker = RequestMaker
