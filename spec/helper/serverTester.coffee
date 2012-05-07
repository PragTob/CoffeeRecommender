{RequestMaker} = require './requestmaker'
{Server} = require './../../lib/server'

TIMEOUT_TIME = 1000

class ServerTester

  constructor: (recommender, @port) ->
    @setupServer(recommender)
    @requestMaker = new RequestMaker(@port)

  setupServer: (recommender) ->
    @server = new Server(recommender)
    @server.start @port

  sendAndExpectPassphrase: (send, passphrase) ->
    @sendAndExpect send, (responseObject) ->
      expect(responseObject.passphrase).toMatch passphrase

  sendAndExpect: (send, func) ->
    runs => @requestMaker.post(send)
    waitsFor (=> @requestMaker.completed()), 'request timed out', TIMEOUT_TIME
    runs =>
      responseObject = @requestMaker.jsonResponse()
      func.call @, responseObject

  stopServer: -> @server.stop()

exports.ServerTester = ServerTester
