{Recommender} = require './../lib/recommender'

@recommender = null

describe 'Recommender', ->

  beforeEach ->
    @recommender = new Recommender()

  it 'can be created', ->
    expect(@recommender).toBeDefined()
