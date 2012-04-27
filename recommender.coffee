class Recommender
  constructor: ->
    Sets = require 'simplesets'
    # normal set class doesn't seem to work appropriately, StringSet does
    # plus the author says that StringSet is faster for >= 110 elements
    @recommendables = new Sets.StringSet()

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
      console.log 'Received impression, but nothing has to be recommended'
      content =
        code: 200
        phrase: 'OK'

  saveItem: (item) ->
    console.log 'Save the item. Recommendable items now are:'
    @recommendables.add item
    console.log @recommendables

  findRecommendations: (requestObject) ->
    console.log "Let's recommend something"
    #TODO find real recommendations, for now they are 1,2,3 and 4 ;)
    recommendations =
      items: [1, 2, 3, 4]

exports.Recommender = Recommender