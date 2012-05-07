{Recommender} = require './../lib/recommender'
{ItemStorageMock} = require './helper/itemStorageMock'

@recommender = null

describe 'Recommender', ->

  beforeEach ->
    @recommender = new Recommender(new ItemStorageMock)

  it 'can be created', ->
    expect(@recommender).toBeDefined()
