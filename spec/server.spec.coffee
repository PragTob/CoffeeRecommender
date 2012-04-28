console.log 'we start'
{RecommenderMock} = require './helper/recommenderMock'
{Server} = require './../server'
http = require 'http'
PORT = process.env.PORT
completed = false
allData = null

console.log 'ir goes on'

postOptions = ->
  options =
    host: '0.0.0.0',
    port: PORT,
    path: '/',
    method: 'POST'

makePostRequest = (sendData) ->
  options = postOptions()
  request = http.request options, (response) ->
    response.on 'data', (chunk) -> responseData += chunk
    response.on 'end', ->
      allData = responseData
      completed = true
  request.write sendData
  request.end

setupServer = ->
  recommenderMock = new RecommenderMock()
  server = new Server(recommenderMock)

'setting up the server'
server = setupServer()
server.start PORT

'boom?'


describe 'the server is able to handle basic requests', ->

  afterEach -> completed = false

  it 'can handle a basic feedback request', ->
    json =
      msg: 'feedback'
    data = JSON.stringify json
    makePostRequest(data)
    console.log 'lol?'
    waitsFor (-> completed), 'epic fail', 1000
    console.log 'we will never get here?'
    responseObject = JSON.parse(decodeURIComponent(allData.trim()))
    expect(responseObject.phrase).toEqual 'feedback'



