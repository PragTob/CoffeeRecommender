# simply an object with several pseudo entries
class ItemStorageMock

  constructor: ->
    # the structure here is domain_id: item_id: item
    @[1] =
      1:
        title: 'casual'
        hitcount: 1
      2:
        title: 'uninteresting'
        hitcount: 2
      4:
        title: 'exciting'
        hitcount: 5
      7:
        title: 'nobody knows this'
        hitcount: 1
      8:
        title: 'a pair'
        hitcount: 2
      9:
        title: 'cool'
        hitcount: 4
      17:
        title: 'top of the pops'
        hitcount: 100

exports.ItemStorageMock = ItemStorageMock