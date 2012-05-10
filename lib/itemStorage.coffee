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
    item.category = element.config?.category?.id
    item.hitcount = 1
    @[element.domain.id][element.item.id] = item

  feedback: (element) ->
    @[element.domain.id][element.target.id].hitcount++ if @hasFeedback(element)

  has: (element) -> @[element.domain.id]? and @getItemFor(element)?

  # the objects are slightly different, so we need a different method... sigh
  hasFeedback: (element) -> @[element.domain.id]? and @[element.domain.id][element.target.id]?

  getItemFor: (element) -> @[element.domain.id][element.item.id]
  
  persist: (path) ->
    console.log 'persisted'
    stringRepresentation = JSON.stringify @
    fs.writeFileSync path, stringRepresentation, 'utf8'

exports.ItemStorage = ItemStorage
