_ = require 'underscore'
{ItemStorage} = require './../lib/itemStorage'

DOMAIN_ID = 1
ITEM_ID = 10
ITEM_TITLE = 'An item'
OTHER_DOMAIN_ID = 2
OTHER_ITEM_ID = 20
OTHER_ITEM_TITLE = 'Other item'

# messages simplified for this testing purpose
exampleMessage = ->
  domain:
    id: DOMAIN_ID
  item: exampleItem()

exampleItem = () ->
  id: ITEM_ID
  title: 'muuh'
  text: 'a cow'
  recommendable: true

otherExampleMessage = ->
  domain:
    id: OTHER_DOMAIN_ID
  item: otherExampleItem()

otherExampleItem = () ->
  id: OTHER_ITEM_ID
  title: 'HMMM'
  text: 'a dog'
  recommendable: true

describe 'ItemStorage class', ->

  beforeEach -> @storage = new ItemStorage()

  it 'can be created', ->
    expect(@storage).toBeDefined()

  describe 'saving items', ->

    beforeEach -> @storage.save(exampleMessage())

    it 'puts the item into the right domain id', ->
      expect(@storage[DOMAIN_ID]).toBeDefined()

    it 'saves an item', ->
      # no item equality since we add properties (hitcount)
      expect(@storage[DOMAIN_ID][ITEM_ID].title).toEqual exampleItem().title

    it 'sets the hitcount of a new item to one', ->
      expect(@storage[DOMAIN_ID][ITEM_ID].hitcount).toEqual(1)

    it 'saves 2 items correctly', ->
      @storage.save(otherExampleMessage())
      expect(@storage[DOMAIN_ID][ITEM_ID].title).toEqual exampleItem().title
      expect(@storage[OTHER_DOMAIN_ID][OTHER_ITEM_ID].title).toEqual otherExampleItem().title

    describe 'saving the same item twice', ->

      beforeEach -> @storage.save exampleMessage()

      it 'does not save the same item twice', ->
        size = 0
        _.each @storage[DOMAIN_ID], (each) -> size++
        expect(size).toEqual(1)

      it 'increases the hit count of the item', ->
        expect(@storage[DOMAIN_ID][ITEM_ID].hitcount).toEqual(2)


