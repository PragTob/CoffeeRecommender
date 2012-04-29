# not really needed however more convenient than writing JS :-)
{Recommender} = require './recommender'
recommender = new Recommender()
{Server} = require './server'
server = new Server(recommender)
server.start()