{RequestMaker} = require './requestmaker'
{Server} = require './../../lib/server'

TIMEOUT_TIME = 1000

# TODO I run a server... I'm worthy of a better name than SpecHelper
class SpecHelper

  constructor: (RecommenderClass, @port) ->
    @setupServer(RecommenderClass)
    @requestMaker = new RequestMaker(@port)

  setupServer: (RecommenderClass) ->
    recommender = new RecommenderClass()
    @server = new Server(recommender)
    @server.start @port

  sendAndExpectResponse: (send, response) ->
    runs => @requestMaker.post(send)
    waitsFor (=> @requestMaker.completed()), 'request timed out', TIMEOUT_TIME
    runs =>
      responseObject = @requestMaker.jsonResponse()
      expect(responseObject).toMatch response

  stopServer: -> @server.stop()

exports.SpecHelper = SpecHelper
