{Recommender} = require './../lib/recommender'
{ItemStorage} = require './../lib/itemStorage'
{ServerTester} = require './helper/serverTester'
_ = require 'underscore'
PORT = 4050

ITEM_ID = 1
TEAM_ID = 1
OUR_TEAM_ID = 48
CATEGORY_ID = 77
DOMAIN_ID = 477
VERSION = '1.0'
RESULT_MESSAGE = 'result'
TARGET_ID = 55
LIMIT = 5

feedbackJSON = ->
  msg: 'feedback'
  client: { id: 7345 }
  domain: { id: DOMAIN_ID }
  source: { id: ITEM_ID }
  target: { id: TARGET_ID }
  context: { category: { id: 74 } }
  config: { team: { id: '48' } }
  version: '1.0'

testJSON = (id = ITEM_ID)->
  msg:"impression"
  id:2
  client:
    id:1
  domain:
    id: DOMAIN_ID
  item:
    id: id
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
  	limit:LIMIT
  version: VERSION

jsonWithoutTeam = ->
  json = testJSON()
  json.config.team = undefined
  json

string = (json) ->
  JSON.stringify json

itemStorage = new ItemStorage
recommender = new Recommender(itemStorage)
helper = new ServerTester recommender, PORT

describe 'Acceptance tests for server and recommendation engine', ->

  describe 'Impression test messages', ->

    it 'handles the example JSON well and does not respond when items are empty', ->
      helper.sendAndExpect string(testJSON()), (responseObject) ->
        expect(responseObject.items).toEqual([])

    it 'sets the correct version number', ->
      helper.sendAndExpect string(testJSON()), (responseObject) ->
        expect(responseObject.version).toEqual(VERSION)

    it 'sets the correct tem id', ->
      helper.sendAndExpect string(testJSON()), (responseObject) ->
        expect(responseObject.team.id).toEqual(TEAM_ID)

    it 'sets the right msg type', ->
      helper.sendAndExpect string(testJSON()), (responseObject) ->
        expect(responseObject.msg).toEqual(RESULT_MESSAGE)

    it 'handles messages without a team id', ->
      helper.sendAndExpect string(jsonWithoutTeam()), (responseObject) ->
        expect(responseObject.team.id).toEqual(OUR_TEAM_ID)

    it 'saves the category of an item appropriately', ->
      helper.send string(testJSON()), ->
        expect(itemStorage[DOMAIN_ID][ITEM_ID].category).toEqual CATEGORY_ID

  describe 'feedback messages', ->

    beforeEach ->
      # we need an item in our db
      helper.sendAndExpect string(testJSON()), (responseObject) -> #nothing

    it 'increases the recommends attribute of the item appropriately', ->
      helper.send string(feedbackJSON()), ->
        expect(itemStorage[DOMAIN_ID][ITEM_ID].recommends[TARGET_ID].count).toEqual 1

    it 'sets the id of the item appropriately', ->
      helper.send string(feedbackJSON()), ->
        expect(itemStorage[DOMAIN_ID][ITEM_ID].recommends[TARGET_ID].id).toEqual TARGET_ID

    it 'responds with the recommended item if the source item is requested', ->
      helper.sendAndExpect string(testJSON()), (response) ->
        expect(_.select(response.items, (item) -> item.id == TARGET_ID).length).toEqual 1

  describe 'put on quite some load', ->

    for i in [1..20]
      helper.send string(testJSON(i)), -> #nothing

    it 'responds with the amount of items specified in the limit parameter', ->
      helper.sendAndExpect string(testJSON()), (response) ->
        expect(response.items.length).toEqual LIMIT

    it 'responds with a well formed array of item ids', ->
      helper.sendAndExpect string(testJSON()), (response) ->
        _.each response.items, (item) ->
          # looks simple but checks for the existance of the id attribute and
          # for the numericality of the ids
          expect(item.id).toBeGreaterThan 0

runs -> helper.stopServer()
