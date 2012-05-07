{ServerTester} = require './helper/serverTester'
{RecommenderMock} = require './helper/recommenderMock'

createTestMessage = (message) ->
  json =
    msg: message
  data = JSON.stringify json

PORT = 2048
helper = new ServerTester(new RecommenderMock, PORT)


describe 'the server is able to handle basic requests', ->

  it 'handles basic feedback requests', ->
    helper.sendAndExpectPassphrase(createTestMessage('feedback'), 'feedback test')

  it 'handles basic impression requests', ->
    helper.sendAndExpectPassphrase(createTestMessage('impression'), 'impression test')

  it 'handles basic error requests', ->
    helper.sendAndExpectPassphrase(createTestMessage('error'), 'error')

runs -> helper.stopServer()
