# TODO: get the POST stuff into a separate class
{RecommenderMock} = require './helper/recommenderMock'
{Server} = require './../server'
http = require 'http'
PORT = 2056
completed = false
allData = null

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
    response.on 'data', (chunk) -> responseData += chunk
    response.on 'end', ->
      allData = responseData
      completed = true

  request.end sendData

setupServer = ->
  recommenderMock = new RecommenderMock()
  server = new Server(recommenderMock)
  server.start PORT
  server

server = setupServer()

describe 'the server is able to handle basic requests', ->

  afterEach -> completed = false

  it 'can handle a basic feedback request', ->
    runs ->
      json =
        msg: 'feedback'
      data = JSON.stringify json
      makePostRequest(data)
    waitsFor (-> isCompleted()), 'epic fail', 10000
    runs ->
      responseObject = JSON.parse(decodeURIComponent(allData.trim()))
      expect(responseObject.passphrase).toEqual 'feedback test'

runs ->
  server.stop()
