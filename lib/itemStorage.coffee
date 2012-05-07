#Just a simple Set implementation
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

  has: (element) -> @[element.domain.id]? and @getItemFor(element)?

  getItemFor: (element) -> @[element.domain.id][element.item.id]

exports.ItemStorage = ItemStorage
