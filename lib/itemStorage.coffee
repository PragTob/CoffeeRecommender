fs = require 'fs'
path = require 'path'

class ItemStorage

  constructor: (filePath = null) ->
    @loadFromFile(filePath) if filePath

  loadFromFile: (filePath) ->
    if path.existsSync filePath
      savedStorage = JSON.parse(fs.readFileSync filePath,'utf8')
      for key, value of savedStorage
        @[key] = value

  save: (element) ->
    if @has(element)
      @increaseHitCount(element)
    else
      @saveNewItem(element)

  increaseHitCount: (element) ->
    @getItemFor(element).hitcount++

  saveNewItem: (element) ->
    @[element.domain.id]?= {}
    item = element.item
    item.category = element.context?.category?.id
    item.hitcount = 1
    item.recommends = {}
    @[element.domain.id][element.item.id] = item

  feedback: (element) ->
    @[element.domain.id][element.target.id].hitcount++ if @hasFeedbackTarget element
    @increaseRecommends element if @hasFeedbackSource element

  has: (element) -> @[element.domain.id]? and @getItemFor(element)?

  # the objects are slightly different, so we need a different method... sigh
  hasFeedbackTarget: (element) -> @[element.domain.id]? and @[element.domain.id][element.target.id]?

  hasFeedbackSource: (element) -> @[element.domain.id]? and @[element.domain.id][element.source?.id]?

  increaseRecommends: (element) ->
    item = @[element.domain.id][element.source.id]
    targetItem = element.target.id
    if item.recommends[targetItem]?
      item.recommends[targetItem]++
    else
      item.recommends[targetItem] = 1

  getItemFor: (element) -> @[element.domain.id][element.item.id]

  persist: (path) ->
    console.log 'persisted'
    stringRepresentation = JSON.stringify @
    fs.writeFileSync path, stringRepresentation, 'utf8'

exports.ItemStorage = ItemStorage
