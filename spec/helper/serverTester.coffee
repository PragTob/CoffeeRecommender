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

  sendAndExpectPassphrase: (data, passphrase) ->
    @sendAndExpect data, (responseObject) ->
      expect(responseObject.passphrase).toMatch passphrase

  sendAndExpect: (data, func) ->
    @send data, ->
      responseObject = @requestMaker.jsonResponse()
      func.call @, responseObject
      
  send: (data, callback) ->
    runs => @requestMaker.post(data)
    waitsFor (=> @requestMaker.completed()), 'request timed out', TIMEOUT_TIME
    runs => callback.call @

  stopServer: -> @server.stop()

exports.ServerTester = ServerTester
