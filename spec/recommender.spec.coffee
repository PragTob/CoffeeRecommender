_ = require 'underscore'
{Recommender} = require './../lib/recommender'
{ItemStorageMock} = require './helper/itemStorageMock'

@recommender = null
@storage = null

describe 'Recommender', ->

  beforeEach ->
    @storage = new ItemStorageMock
    @recommender = new Recommender(@storage)

  it 'can be created', ->
    expect(@recommender).toBeDefined()

  it 'can sort items by hitcount', ->
    items = @recommender.sortItemsByHitCount(@storage[1])
    console.log items
    last = null
    _.each items, (each) ->
      expect(each.hitcount).not.toBeGreaterThan(last.hitcount) if last?
      last = each

