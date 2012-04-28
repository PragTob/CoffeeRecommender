class RecommenderMock
  processFeedback: (requestObject) ->
    content =
      code: 200
      phrase: 'Feedback'

  processImpression: (requestObject) ->
    content =
      code: 200
      phrase: 'Impression'

exports.RecommenderMock = RecommenderMock