{RecommenderMock} = require './helper/recommenderMock'
{Server} = require './../server'
{RequestMaker} = require './helper/requestmaker'
PORT = 2048

setupServer = ->
  recommenderMock = new RecommenderMock()
  server = new Server(recommenderMock)
  server.start PORT
  server

server = setupServer()
requestMaker = new RequestMaker(PORT)

describe 'the server is able to handle basic requests', ->

  it 'can handle a basic feedback request', ->
    runs ->
      json =
        msg: 'feedback'
      data = JSON.stringify json
      requestMaker.post(data)
    waitsFor (-> requestMaker.completed()), 'epic fail', 10000
    runs ->
      responseObject = JSON.parse(decodeURIComponent(requestMaker.completeData.trim()))
      expect(responseObject.passphrase).toEqual 'feedback test'

runs ->
  server.stop()
