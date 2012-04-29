{Server} = require './../lib/server'
{Recommender} = require './../lib/recommender'
{RequestMaker} = require './helper/requestmaker'
PORT = 4050
TIMEOUT_TIME = 1000

setupServer = ->
  recommender = new Recommender()
  server = new Server(recommender)
  server.start PORT
  server

testJSON = ->
  '{
    "msg":"impression",
    "id":2,
    "client":{
      "id":1
    },
    "domain":{
      "id":2
    },
    "item":{
    	"id":5,
    	"title":"muuh",
    	"url":"google.de",
    	"created":42,
    	"text":"a cow",
    	"img":"google.de/images.jpg",
    	"recommendable":true
    },
    "context":{
    	"category":{
    		"id":77
    	}
    },
    "config":{
    	"team":{
    		"id":2
    	},
    	"timeout":200.0,
    	"recommend":true,
    	"limit":5
    },
    "version": "1.0"
  }'

server = setupServer()
requestMaker = new RequestMaker(PORT)

describe 'Acceptance tests for server and recommendation engine', ->

  it 'handles the example JSON well and does not respond when items is empty', ->
    runs -> requestMaker.post(testJSON())
    waitsFor (-> requestMaker.completed()), 'acceptance takes too long', TIMEOUT_TIME
    runs ->
      responseObject = requestMaker.jsonResponse()
      expect(responseObject.items).toMatch []

runs -> server.stop()