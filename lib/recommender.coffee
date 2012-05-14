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
    itemId = requestObject.item?.id
    item = @itemStorage[domainId][itemId]
    recommendations = []

    if item?
      recommendations = @recommendedItems(item, limit)
      limit -= recommendations.length

    if limit > 0
      popularItems = @findPopularItems(domainId, itemId, recommendations, limit)
      recommendations = recommendations.concat popularItems

    _.map recommendations, (item) -> id: item.id

  findPopularItems: (domainId, itemId, currentRecommendations, limit) ->
    unwantedItems = _.map currentRecommendations, (each) -> each.id
    unwantedItems.push itemId
    cleanedItems =  _.select @itemStorage[domainId], (item) ->
        unwantedItems.indexOf(item.id) == -1
    items = @sortItemsByHitCount(cleanedItems).slice(0, limit)

  sortItemsByHitCount: (items) ->
    # minus so we get a descending sort not an ascending
    _.sortBy items, (item) -> -item.hitcount

  recommendedItems: (item, limit) ->
    items = _.sortBy(item.recommends, (item) -> -item.count).slice(0, limit)

  ourId: -> @itemStorage.ourId ? DEFAULT_ID

exports.Recommender = Recommender
