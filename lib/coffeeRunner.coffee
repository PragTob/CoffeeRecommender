# not really needed however more convenient than writing JS :-)
{ItemStorage} = require './itemStorage'
{Recommender} = require './recommender'
recommender = new Recommender(new ItemStorage)
{Server} = require './server'
server = new Server(recommender)
server.start()