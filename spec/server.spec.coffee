{RecommenderMock} = require './helper/recommenderMock'
{Server} = require './../lib/server'
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

  it 'handles basic feedback requests', ->
    runs -> requestMaker.post(createTestMessage 'feedback' )
    waitsFor (-> requestMaker.completed()), 'no feedback', TIMEOUT_TIME
    runs ->
      responseObject = requestMaker.jsonResponse()
      expect(responseObject.passphrase).toMatch 'feedback test'

  it 'handles basic impression requests', ->
    runs -> requestMaker.post(createTestMessage 'impression' )
    waitsFor (-> requestMaker.completed()), 'no impression', TIMEOUT_TIME
    runs ->
      responseObject = requestMaker.jsonResponse()
      expect(responseObject.passphrase).toMatch 'impression test'

  it 'handles basic error requests', ->
    runs -> requestMaker.post(createTestMessage 'error' )
    waitsFor (-> requestMaker.completed()), 'no answer for error', TIMEOUT_TIME
    runs ->
      responseObject = requestMaker.jsonResponse()
      expect(responseObject.passphrase).toMatch 'error'

runs -> server.stop()
