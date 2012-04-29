{RecommenderMock} = require './helper/recommenderMock'
{Server} = require './../server'
{RequestMaker} = require './helper/requestmaker'
PORT = 2048
TIMEOUT_TIME = 1000

setupServer = ->
  recommenderMock = new RecommenderMock()
  server = new Server(recommenderMock)
  server.start PORT
  server

createTestMessage = (message) ->
  json =
    msg: message
  data = JSON.stringify json

server = setupServer()
requestMaker = new RequestMaker(PORT)

describe 'the server is able to handle basic requests', ->

  it 'can handle a basic feedback request', ->
    runs ->
      requestMaker.post(createTestMessage 'feedback' )
    waitsFor (-> requestMaker.completed()), 'no feedback', TIMEOUT_TIME
    runs ->
      responseObject = requestMaker.jsonResponse()
      expect(responseObject.passphrase).toEqual 'feedback test'

runs ->
  server.stop()
