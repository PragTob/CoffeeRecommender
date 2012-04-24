http = require 'http'

# helper function that responds to the client
respond = (res, code, contentType, data) ->
    res.writeHead code,
        'Content-Type': contentType
        'Content-Length': data.length
    res.write data
    res.end()

startServer = () ->
  server = http.createServer (request, response) ->
    console.log "Request: #{request.method} #{request.url}"
    data = '{}'
    request.on 'data', (chunk) -> data += chunk
    request.on 'end', () ->
      console.log "Data: #{data}"
      requestObject = JSON.parse(decodeURIComponent(data.trim()))
      console.log requestObject
      switch requestObject.msg
        when 'feedback'
          processFeedback(requestObject)
        when 'impression'
          processImpression(requestObject)
        when 'error'
          processError(requestObject)
        else
          console.log 'lol?'
      respond response, 200, 'text/plain', 'Hi'

  server.listen process.env.C9_PORT

processFeedback = (requestObject) ->
  console.log 'Got feedback'

processImpression = (requestObject) ->
  saveItem(requestObject.item) if requestObject.item.recommendable
  makeRecommendation(requestObject) if requestObject.config.recommend

saveItem = (item) ->
  console.log 'Save the item'

makeRecommendation = (requestObject) ->
  console.log "Let's recommend something"

processError = (requestObject) ->
  console.log 'Just received an error'