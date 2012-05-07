_ = require 'underscore'
{ItemSet} = require './../lib/itemStorage'

DOMAIN_ID = 1
ITEM_ID = 10
OTHER_DOMAIN_ID = 2
OTHER_ITEM_ID = 20

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

@storage = null

describe 'ItemSet class', ->
  
  beforeEach -> @storage = new ItemSet()
  
  it 'can be created', ->
    expect(@storage).toBeDefined
    
  describe 'saving items', ->

    beforeEach -> @storage.save(exampleMessage())
    
    it 'puts the item into the right domain id', ->
      expect(@storage[DOMAIN_ID]).toBeDefined()

    it 'saves an item', ->
      expect(@storage[DOMAIN_ID][ITEM_ID]).toEqual exampleItem()

    it 'does not save the same item twice', ->
      @storage.save(otherExampleMessage())
      size = 0
      _.each @storage[DOMAIN_ID], (each) -> size++
      expect(size).toEqual(1)

    it 'saves 2 items correctly', ->
      @storage.save(otherExampleMessage())
      expect(@storage[DOMAIN_ID][ITEM_ID]).toEqual exampleItem()
      expect(@storage[OTHER_DOMAIN_ID][OTHER_ITEM_ID]).toEqual otherExampleItem()
    
  
