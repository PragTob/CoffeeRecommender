# not really needed however more convenient than writing JS :-)
{ItemStorage} = require './itemStorage'
{Recommender} = require './recommender'
{Server} = require './server'

STORAGE_FILE_PATH = 'item.store'

storage = new ItemStorage(STORAGE_FILE_PATH)
recommender = new Recommender(storage)
server = new Server(recommender)

process.on 'exit', -> storage.persist(STORAGE_FILE_PATH)
process.on 'uncaughtException', -> storage.persist(STORAGE_FILE_PATH)
server.start()