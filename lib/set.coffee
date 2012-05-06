#Just a simple Set implementation
class Set

  constructor: ->
    @hash = {}
    # for now it seems easiest to keep track of this ourselves
    @_size = 0

  add: (element) ->
    unless @has(element)
      @_size++
      stringifiedElement = JSON.stringify element
      @hash[stringifiedElement] = element

  remove: (element) ->
    @_size--
    delete @hash[element]

  has: (element) -> @hash[JSON.stringify(element)]?

  equals: (set2) ->
    @.is_subset_of(set2) and set2.is_subset_of @

  to_array: ->
    (element for element of @hash)

  each: (f) ->
    for element of @hash
      f(element)

  size: -> @_size

  isEmpty: @_size == 0

exports.Set = Set