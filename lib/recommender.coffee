_ = require 'underscore'

# TODO the item property might be missing

class Recommender
  constructor: (@itemStorage) ->

  processFeedback: (requestObject) ->
    console.log 'Got feedback'
    #TODO process feedback of unknown items and process it better
    @saveFeedback(requestObject)
    content =
      code: 200
      phrase: ''

  processImpression: (requestObject) ->
    @saveItem(requestObject) if requestObject.item.recommendable
    if requestObject.config.recommend
      recommendations = @findRecommendations(requestObject)
      content =
        code: 200
        data:
          msg: 'result'
          items: recommendations
          team:
            id: requestObject.config.team.id
          version: requestObject.version
    else
      content =
        code: 200
        phrase: 'OK'

  saveFeedback: (request) -> @itemStorage.feedback request

  saveItem: (item) -> @itemStorage.save item

  findRecommendations: (requestObject) ->
    domainId = requestObject.domain.id
    limit = requestObject.config.limit
    itemsWithoutRequested =  _.reject @itemStorage[domainId], (item) ->
      item.id == requestObject.item.id
    items = @sortItemsByHitCount(itemsWithoutRequested).slice(0, limit)
    recommendations = _.map items, (item) -> id: item.id

  sortItemsByHitCount: (items) ->
    # minus so we get a descending sort not an ascending
    _.sortBy items, (item) -> -item.hitcount

exports.Recommender = Recommender
