class Recommender
  constructor: ->
    {Set} = require './set'
    # normal set class doesn't seem to work appropriately, StringSet does
    # plus the author says that StringSet is faster for >= 110 elements
    @recommendables = new Set()

  processFeedback: (requestObject) ->
    console.log 'Got feedback'
    #TODO process feedback probably
    content =
      code: 200
      phrase: ''

  processImpression: (requestObject) ->
    @saveItem(requestObject.item) if requestObject.item.recommendable
    if requestObject.config.recommend
      recommendations = @findRecommendations(requestObject)
      content =
        code: 200
        data: recommendations
    else
      content =
        code: 200
        phrase: 'OK'

  saveItem: (item) -> @recommendables.add item

  findRecommendations: (requestObject) ->
    #TODO find real recommendations, for now they are empty)
    recommendations =
      items: []

exports.Recommender = Recommender