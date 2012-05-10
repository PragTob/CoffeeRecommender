_ = require 'underscore'
{Recommender} = require './../lib/recommender'
{ItemStorageMock} = require './helper/itemStorageMock'

LIMIT = 4
DOMAIN_ID = 1
TEAM_ID = 77
VERSION = "1.0"

requestObject = (itemId = "5") ->
  domain:
    id: DOMAIN_ID
  item:
    id: itemId
  config:
    limit: LIMIT

requestObjectWithoutItem = ->
  domain:
    id: DOMAIN_ID
  config:
    limit: LIMIT

impressionMessage = (teamIdGiven = true) ->
  json = requestObject()
  json.version = VERSION
  json.config.recommend = true
  json.config.team = {id: TEAM_ID} if teamIdGiven
  json

impressionMessageWithoutItem = (teamIdGiven = true) ->
  json = requestObjectWithoutItem()
  json.version = VERSION
  json.config.recommend = true
  json.config.team = {id: TEAM_ID} if teamIdGiven
  json

describe 'Recommender', ->

  beforeEach ->
    @storage = new ItemStorageMock
    @recommender = new Recommender(@storage)

  it 'can be created', ->
    expect(@recommender).toBeDefined()

  it 'can sort items by hitcount', ->
    items = @recommender.sortItemsByHitCount(@storage[DOMAIN_ID])
    last = null
    _.each items, (each) ->
      expect(each.hitcount).not.toBeGreaterThan(last.hitcount) if last?
      last = each

  describe 'findRecommendations', ->

    beforeEach -> @recommendations = @recommender.findRecommendations(requestObject())

    it 'responds with an array of an appropriate size', ->
      expect(@recommendations.length).toEqual LIMIT

    it 'respondes with an array where every element is an object with an id', ->
      _.each @recommendations, (item) -> expect(item.id).toBeDefined()

  describe 'processImpression', ->
    beforeEach -> 
      @answer = @recommender.processImpression(impressionMessage())

    it 'is defined', ->
      expect(@answer).toBeDefined()

    it 'has the Version', ->
      expect(@answer.data.version).toEqual(VERSION)

    it 'has a team id', ->
      expect(@answer.data.team.id).toEqual(TEAM_ID)

    it 'has the team id set to an empty string if no team id was given', ->
      noTeamAnswer = @recommender.processImpression(impressionMessage(false))
      expect(noTeamAnswer.data.team.id).toEqual 48

    it 'has an items array of the appropriate size', ->
      expect(@answer.data.items.length).toEqual(LIMIT)
  describe 'processImpression without item in request', ->  
    
    beforeEach ->
      @answerWithoutItem = @recommender.processImpression(impressionMessageWithoutItem())
    
    it 'is defined', ->
      expect(@answerWithoutItem).toBeDefined()
    
    it 'works with a request that has no item', ->
      expect(@answerWithoutItem.data.items.length).toEqual(LIMIT)