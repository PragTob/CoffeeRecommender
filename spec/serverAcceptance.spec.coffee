{Recommender} = require './../lib/recommender'
{ItemStorage} = require './../lib/itemStorage'
{ServerTester} = require './helper/serverTester'
PORT = 4050

ITEM_ID = "I'm a String ID - weird"

testJSON = ->
  '{
    "msg":"impression",
    "id":2,
    "client":{
      "id":1
    },
    "domain":{
      "id":1
    },
    "item":{
    	"id": "weirdly enough Im a string",
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

recommender = new Recommender(new ItemStorage)
helper = new ServerTester recommender, PORT

describe 'Acceptance tests for server and recommendation engine', ->

  it 'handles the example JSON well and does not respond when items are empty', ->
    helper.sendAndExpect testJSON(), (responseObject) ->
      expect(responseObject.items).toEqual([])

runs -> helper.stopServer()
