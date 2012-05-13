{Recommender} = require './../lib/recommender'
{ItemStorage} = require './../lib/itemStorage'
{ServerTester} = require './helper/serverTester'
PORT = 4050

ITEM_ID = '1'
TEAM_ID = 1
OUR_TEAM_ID = 48
CATEGORY_ID = 77
DOMAIN_ID = 477
VERSION = '1.0'
RESULT_MESSAGE = 'result'

testJSON = ->
  msg:"impression"
  id:2
  client:
    id:1
  domain:
    id: DOMAIN_ID
  item:
    id: ITEM_ID
    title:"muuh"
    url:"google.de"
    created: 42
    text:"a cow"
    img:"google.de/images.jpg"
    recommendable:true
  context:
  	category:
  		id: CATEGORY_ID
  config:
  	team:
  		id: TEAM_ID
  	timeout:200.0
  	recommend:true
  	limit:5
  version: VERSION

jsonWithoutTeam = ->
  json = testJSON()
  json.config.team = undefined
  json


testJSONString = ->
  JSON.stringify(testJSON())

itemStorage = new ItemStorage
recommender = new Recommender(itemStorage)
helper = new ServerTester recommender, PORT

describe 'Acceptance tests for server and recommendation engine', ->

  it 'handles the example JSON well and does not respond when items are empty', ->
    helper.sendAndExpect testJSONString(), (responseObject) ->
      expect(responseObject.items).toEqual([])

  it 'sets the correct version number', ->
    helper.sendAndExpect testJSONString(), (responseObject) ->
      expect(responseObject.version).toEqual(VERSION)

  it 'sets the correct tem id', ->
    helper.sendAndExpect testJSONString(), (responseObject) ->
      expect(responseObject.team.id).toEqual(TEAM_ID)

  it 'sets the right msg type', ->
    helper.sendAndExpect testJSONString(), (responseObject) ->
      expect(responseObject.msg).toEqual(RESULT_MESSAGE)

  it 'handles messages without a team id', ->
    helper.sendAndExpect JSON.stringify(jsonWithoutTeam()), (responseObject) ->
      expect(responseObject.team.id).toEqual(OUR_TEAM_ID)

  it 'saves the category of an item appropriately', ->
    helper.sendAndExpect testJSONString(), (responseObject) -> # do nothing
    expect(itemStorage[DOMAIN_ID][ITEM_ID].category).toEqual CATEGORY_ID



runs -> helper.stopServer()
