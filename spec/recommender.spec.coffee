{Recommender} = require './../lib/recommender'

@recommender = null

exampleItem = ->
  id: 5
  title: 'muuh'
  url: 'google.de'
  created: 42
  text: 'a cow'
  img: 'google.de/images.jpg'
  recommendable: true

otherExampleItem = ->
  id: 8
  title: 'HMMM'
  url: 'tagesschau.de'
  created: 45
  text: 'a dog'
  img: 'tagesschau.de/images.jpg'
  recommendable: true

describe 'Recommender', ->

  beforeEach ->
    @recommender = new Recommender

  describe 'saving items', ->

    beforeEach ->
      @recommender.saveItem(exampleItem())

    it 'saves an item', ->
      expect(@recommender.recommendables.size()).toEqual(1)
      expect(@recommender.recommendables).toMatch(exampleItem())

    it 'does not save the same item twice', ->
      @recommender.saveItem(exampleItem())
      expect(@recommender.recommendables.size()).toEqual(1)

    it 'saves 2 items correctly', ->
      @recommender.saveItem(otherExampleItem())
      expect(@recommender.recommendables.has(otherExampleItem())).toBeTruthy
      expect(@recommender.recommendables.size()).toEqual(2)
