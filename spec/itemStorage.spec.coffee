_ = require 'underscore'
fs = require 'fs'
path = require 'path'

{ItemStorage} = require './../lib/itemStorage'

DOMAIN_ID = 1
ITEM_ID = '10'
ITEM_TITLE = 'An item'
OTHER_DOMAIN_ID = 2
OTHER_ITEM_ID = 20
OTHER_ITEM_TITLE = 'Other item'
FILE_PATH = 'spec/testFiles/storage.test'

# messages simplified for this testing purpose
exampleMessage = (id = ITEM_ID) ->
  domain:
    id: DOMAIN_ID
  item: exampleItem(id)

exampleItem = (id) ->
  id: id
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

exampleFeedbackMessage = (itemId = ITEM_ID) ->
  msg: 'feedback'
  domain:
    id: DOMAIN_ID
  target:
    id: itemId

saveFeedbackWithSource = (storage) ->
  feedbackWithSource = exampleFeedbackMessage()
  feedbackWithSource.source = { id: OTHER_ITEM_ID }
  # other item has to be present
  storage.save(exampleMessage(OTHER_ITEM_ID))
  storage.feedback feedbackWithSource

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

    it 'starts of with an empty hash for recommends', ->
      expect(@storage[DOMAIN_ID][ITEM_ID].recommends).toEqual({})

    describe 'saving the same item twice', ->

      beforeEach -> @storage.save exampleMessage()

      it 'does not save the same item twice', ->
        size = 0
        _.each @storage[DOMAIN_ID], (each) -> size++
        expect(size).toEqual(1)

      it 'increases the hit count of the item', ->
        expect(@storage[DOMAIN_ID][ITEM_ID].hitcount).toEqual(2)

    describe 'handling feedback', ->

      it 'can tell that it has an item that feedback applies to', ->
        expect(@storage.hasFeedbackTarget exampleFeedbackMessage()).toBeTruthy()

      it 'can tell when there is no such item the feedback applies to', ->
        expect(@storage.hasFeedbackTarget exampleFeedbackMessage('not existent')).toBeFalsy()

      it 'can tell that it has no source FeedbackMessage', ->
        expect(@storage.hasFeedbackSource exampleFeedbackMessage()).toBeFalsy()

      it 'increases the hitcount of the item', ->
        @storage.feedback exampleFeedbackMessage()
        expect(@storage[DOMAIN_ID][ITEM_ID].hitcount).toEqual(2)

      it 'adjusts the recommends hash of the source to show how often it has been recommended', ->
        saveFeedbackWithSource(@storage)
        expect(@storage[DOMAIN_ID][OTHER_ITEM_ID].recommends[ITEM_ID].count).toEqual 1

      it 'also saves the id of the item', ->
        saveFeedbackWithSource(@storage)
        expect(@storage[DOMAIN_ID][OTHER_ITEM_ID].recommends[ITEM_ID].id).toBeDefined()

      it 'increases the recommends score if further feedback messages come along', ->
        saveFeedbackWithSource(@storage)
        saveFeedbackWithSource(@storage)
        expect(@storage[DOMAIN_ID][OTHER_ITEM_ID].recommends[ITEM_ID].count).toEqual 2

    describe 'persists the storage', ->

      beforeEach -> @storage.persist(FILE_PATH)

      afterEach -> fs.unlinkSync(FILE_PATH)

      it 'can save the items to a file', ->
        expect(path.existsSync(FILE_PATH)).toBeTruthy()

      describe 'storage loaded from file', ->

        beforeEach -> @savedStorage = new ItemStorage FILE_PATH

        it 'loads the saved storage correctly from file', ->
          expect(@savedStorage[DOMAIN_ID][ITEM_ID]).toBeDefined()

        it 'operates as a normal storage', ->
          @savedStorage.save(otherExampleMessage())
          expect(@savedStorage[OTHER_DOMAIN_ID][OTHER_ITEM_ID].title).toEqual otherExampleItem().title

  describe 'handling of categories', ->

    it 'can save an item with a category', ->
      json = exampleMessage()
      json.context = {category: { id: 1}}
      @storage.save json

      expect(@storage[DOMAIN_ID][ITEM_ID].category).toEqual 1
