http = require 'http'

# helper function that responds to the client
respond = (res, code, contentType, data) ->
    res.writeHead code,
        'Content-Type': contentType
        'Content-Length': data.length
    res.write data
    res.end()
    
server = http.createServer (request, response) -> 
  console.log "Request: #{request.method} #{request.url}"
  data = '{}'
  request.on 'data', (chunk) -> data += chunk
  request.on 'end', () ->
    console.log "Data: #{data}"
    requestObject = JSON.parse(decodeURIComponent(data.trim()))
    console.log requestObject
    respond response, 200, 'text/plain', 'Hi'

server.listen process.env.C9_PORT