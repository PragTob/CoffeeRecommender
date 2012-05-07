_ = require 'underscore'

class Recommender
  constructor: (@itemStorage) ->

  processFeedback: (requestObject) ->
    console.log 'Got feedback'
    #TODO process feedback probably
    content =
      code: 200
      phrase: ''

  processImpression: (requestObject) ->
    @saveItem(requestObject) if requestObject.item.recommendable
    if requestObject.config.recommend
      recommendations = @findRecommendations(requestObject)
      content =
        code: 200
        data: recommendations
    else
      content =
        code: 200
        phrase: 'OK'

  saveItem: (item) -> @itemStorage.save item

  findRecommendations: (requestObject) ->
    #TODO find real recommendations, for now they are empty)
    recommendations =
      items: []

  sortItemsByHitCount: (items) ->
    # minus so we get a descending sort not an ascending
    _.sortBy items, (item) -> -item.hitcount

exports.Recommender = Recommender
