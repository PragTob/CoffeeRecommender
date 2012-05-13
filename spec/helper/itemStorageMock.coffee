# TODO: item IDs are Strings
# simply an object with several pseudo entries
class ItemStorageMock

  constructor: ->
    # the structure here is domain_id: item_id: item
    @[1] =
      '1':
        title: 'casual'
        id: '1'
        hitcount: 1
        recommends: {'17': 5, '2': 4, '77': 3}
      '2':
        title: 'uninteresting'
        id: '2'
        hitcount: 2
        recommends: {}
      '4':
        title: 'exciting'
        id: '4'
        hitcount: 5
        recommends: {}
      '7':
        title: 'nobody knows this'
        id: '7'
        hitcount: 1
        recommends: {}
      '8':
        title: 'a pair'
        id: '8'
        hitcount: 2
        recommends: {}
      '9':
        title: 'cool'
        id: '9'
        hitcount: 4
        recommends: {}
      '17':
        title: 'top of the pops'
        id: '17'
        hitcount: 100
        recommends: {}

exports.ItemStorageMock = ItemStorageMock