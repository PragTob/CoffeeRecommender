console.log 'we start'
{RecommenderMock} = require './helper/recommenderMock'
{Server} = require './../server'
http = require 'http'
PORT = 2055
completed = false
allData = null

console.log 'ir goes on'

isCompleted = -> completed == true

postOptions = ->
  options =
    host: '0.0.0.0',
    port: PORT,
    path: '/',
    method: 'POST'

makePostRequest = (sendData) ->
  options = postOptions()
  request = http.request options, (response) ->
    responseData = ''
    response.on 'data', (chunk) ->
      responseData += chunk
      console.log 'received some data: ' + responseData
    response.on 'end', ->
      console.log 'received end: ' + responseData
      allData = responseData
      completed = true
  request.end sendData

setupServer = ->
  recommenderMock = new RecommenderMock()
  server = new Server(recommenderMock)

console.log 'setting up the server'
server = setupServer()
server.start PORT

waits 20

console.log 'boom?'


describe 'the server is able to handle basic requests', ->

  afterEach -> completed = false

  it 'can handle a basic feedback request', ->
    @after ->
      console.log 'We should ne be here before the spec breaks'
      server.stop()
    runs ->
      json =
        msg: 'feedback'
      data = JSON.stringify json
      console.log data
      makePostRequest(data)
      console.log 'lol?'
    waitsFor (-> isCompleted()), 'epic fail', 10000
    runs ->
      console.log 'we will never get here?'
      console.log allData
      responseObject = JSON.parse(decodeURIComponent(allData.trim()))
      console.log responseObject
      expect(responseObject.passphrase).toEqual 'feedback test'
