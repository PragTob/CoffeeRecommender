class ItemStorage

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
    item.hitcount = 1
    @[element.domain.id][element.item.id] = item

  feedback: (element) ->
    @[element.domain.id][element.target.id].hitcount++ if @hasFeedback(element)

  has: (element) -> @[element.domain.id]? and @getItemFor(element)?

  # the objects are slightly different, so we need a different method... sigh
  hasFeedback: (element) -> @[element.domain.id]? and @[element.domain.id][element.target.id]?

  getItemFor: (element) -> @[element.domain.id][element.item.id]

exports.ItemStorage = ItemStorage
