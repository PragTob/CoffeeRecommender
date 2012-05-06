{ServerTester} = require './helper/serverTester'
{RecommenderMock} = require './helper/recommenderMock'

passphrase = (phrase) ->
  json =
    passphrase: phrase

createTestMessage = (message) ->
  json =
    msg: message
  data = JSON.stringify json

PORT = 2048
helper = new ServerTester(RecommenderMock, PORT)


describe 'the server is able to handle basic requests', ->

  it 'handles basic feedback requests', ->
    helper.sendAndExpectResponse(createTestMessage('feedback'), passphrase('feedback test'))

  it 'handles basic impression requests', ->
    helper.sendAndExpectResponse(createTestMessage('impression'), passphrase('impression test'))

  it 'handles basic error requests', ->
    helper.sendAndExpectResponse(createTestMessage('error'), passphrase('error'))

runs -> helper.stopServer()
