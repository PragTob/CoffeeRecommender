_ = require 'underscore'

# TODO the item property might be missing

DEFAULT_ID = 48

class Recommender
  constructor: (@itemStorage) ->

  processFeedback: (requestObject) ->
    @saveFeedback(requestObject)
    content =
      code: 200
      phrase: ''

  processImpression: (requestObject) ->
    @saveItem(requestObject) if requestObject.item?.recommendable
    if requestObject.config.recommend
      recommendations = @findRecommendations(requestObject)
      teamId = requestObject.config.team?.id ? @ourId()
      content =
        code: 200
        data:
          msg: 'result'
          items: recommendations
          team:
            id: teamId
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
    itemId = requestObject.item?.id ? null
    #recommended = @itemStorage[domainId][itemId].recommends
    itemsWithoutRequested =  _.reject @itemStorage[domainId], (item) ->
      item.id == itemId
    items = @sortItemsByHitCount(itemsWithoutRequested).slice(0, limit)
    recommendations = _.map items, (item) -> id: item.id

  sortItemsByHitCount: (items) ->
    # minus so we get a descending sort not an ascending
    _.sortBy items, (item) -> -item.hitcount

  recommendedItems: (item, limit) ->
    _.sortBy(item.recommends, (recommendCount) -> -recommendCount).slice(0, limit)

  ourId: -> @itemStorage.ourId ? DEFAULT_ID

exports.Recommender = Recommender
