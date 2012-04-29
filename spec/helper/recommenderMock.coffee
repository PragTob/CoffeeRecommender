class RecommenderMock
  processFeedback: (requestObject) ->
    content =
      code: 200
      phrase: 'feedback test'

  processImpression: (requestObject) ->
    content =
      code: 200
      phrase: 'impression test'

exports.RecommenderMock = RecommenderMock