_ = require 'underscore'
{Recommender} = require './../lib/recommender'
{ItemStorageMock} = require './helper/itemStorageMock'

LIMIT = 6
DOMAIN_ID = 1
TEAM_ID = 77
VERSION = "1.0"
ITEM_ID = '1'
DEFAULT_TEAM_ID = 48

requestObject = (itemId = ITEM_ID) ->
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

expectToBeSortedDescending = (items) ->
  _.each items, (each) ->
    expect(each.hitcount).not.toBeGreaterThan(last.hitcount) if last?
    last = each

describe 'Recommender', ->

  beforeEach ->
    @storage = new ItemStorageMock
    @recommender = new Recommender(@storage)

  it 'can be created', ->
    expect(@recommender).toBeDefined()

  it 'can sort items by hitcount', ->
    items = @recommender.sortItemsByHitCount(@storage[DOMAIN_ID])
    last = null
    expectToBeSortedDescending items

  describe 'findRecommendations', ->

    beforeEach -> @recommendations = @recommender.findRecommendations(requestObject())

    it 'responds with an array of an appropriate size', ->
      expect(@recommendations.length).toEqual LIMIT

    it 'respondes with an array where every element is an object with an id', ->
      _.each @recommendations, (item) -> expect(item.id).toBeDefined()

    it 'responds with an array where no item is contained twice', ->
      length = @recommendations.length
      uniqLength = _.uniq(@recommendations, false, (item) -> item.id).length
      expect(length).toEqual uniqLength

    it 'does not contain the original item', ->
      expect(_.map(@recommendations, (item) -> item.id).indexOf(ITEM_ID)).toEqual -1

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
      expect(noTeamAnswer.data.team.id).toEqual DEFAULT_TEAM_ID

    it 'has an items array of the appropriate size', ->
      expect(@answer.data.items.length).toEqual(LIMIT)

  describe 'processImpression without item in request', ->

    beforeEach ->
      @answerWithoutItem = @recommender.processImpression(impressionMessageWithoutItem())

    it 'is defined', ->
      expect(@answerWithoutItem).toBeDefined()

    it 'has an items array of the appropriate size', ->
      expect(@answerWithoutItem.data.items.length).toEqual(LIMIT)

  describe 'recommendedItems', ->

    it 'returns items equal to the limit if it has enough items', ->
      limit = Object.keys(@storage[DOMAIN_ID][ITEM_ID].recommends).length
      items = @recommender.recommendedItems(@storage[DOMAIN_ID][ITEM_ID], limit)
      expect(items.length).toEqual limit

    it 'returns just the items it has if the limit is too large', ->
      max = Object.keys(@storage[DOMAIN_ID][ITEM_ID].recommends).length
      items = @recommender.recommendedItems(@storage[DOMAIN_ID][ITEM_ID], 1000)
      expect(items.length).toEqual max

    it 'returns the items in descending order', ->
      items = @recommender.recommendedItems(@storage[DOMAIN_ID][ITEM_ID], 1000)
      expectToBeSortedDescending items


