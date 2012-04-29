{Recommender} = require './../lib/recommender'
{SpecHelper} = require './helper/specHelper'
PORT = 4050

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

itemsJSON = (recommendedItems) ->
  json =
    items: recommendedItems

helper = new SpecHelper Recommender, PORT

describe 'Acceptance tests for server and recommendation engine', ->

  it 'handles the example JSON well and does not respond when items is empty', ->
    helper.sendAndExpectResponse(testJSON(), itemsJSON([]))

runs -> helper.stopServer()