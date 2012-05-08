_ = require 'underscore'
{Recommender} = require './../lib/recommender'
{ItemStorageMock} = require './helper/itemStorageMock'

LIMIT = 4
DOMAIN_ID = 1

requestObject = (itemId = "5") ->
  domain:
    id: DOMAIN_ID
  item:
    id: itemId
  config:
    limit: LIMIT

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

    it 'responds with an array of an appropriate size', ->
      recommendations = @recommender.findRecommendations(requestObject())
      expect(recommendations.length).toEqual LIMIT



