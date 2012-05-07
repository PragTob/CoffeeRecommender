#Just a simple Set implementation
class ItemSet

  save: (element) ->
    unless @has(element)
      @[element.domain.id]?= {}
      @[element.domain.id][element.item.id] = element.item

  has: (element) -> @[element.domain.id]? and @[element.domain.id][element.item.id]?

exports.ItemSet = ItemSet
