#Just a simple Set implementation
class ItemSet

  save: (element) ->
    if @has(element)
      @increaseHitCount(element)
    else
      @saveNewItem(element)
      
  increaseHitCount: (element) ->
    @[element.domain.id][element.item.id].hitcount++
    
  saveNewItem: (element) ->
    @[element.domain.id]?= {}
    item = element.item
    item.hitcount = 1
    @[element.domain.id][element.item.id] = item

  has: (element) -> @[element.domain.id]? and @[element.domain.id][element.item.id]?

exports.ItemSet = ItemSet
