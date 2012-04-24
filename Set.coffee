#Just a simple Set implementation
class Set

  exports.createSet = (elems...) ->
    @hash = {}
    for elem in elems
      @hash[elem] = elem
    @
 
  exports.add = (elem) ->
    @hash[elem] = elem
 
  exports.remove = (elem) ->
    delete @hash[elem]
 
  exports.has = (elem) ->
    @hash[elem]?
 
  exports.equals = (set2) ->
    this.is_subset_of(set2) and set2.is_subset_of this
 
  exports.to_array = ->
    (elem for elem of @hash)
 
  exports.each = (f) ->
    for elem of @hash
      f(elem)