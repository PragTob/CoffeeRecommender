PORT = 4531

# not really needed however more convenient than writing JS :-)
{ItemStorage} = require './itemStorage'
{Recommender} = require './recommender'
{Server} = require './server'
CronJob = require('cron').CronJob

STORAGE_FILE_PATH = 'item.store'

storage = new ItemStorage(STORAGE_FILE_PATH)
recommender = new Recommender(storage)
server = new Server(recommender)

process.on 'exit', ->
  console.log 'Process exits'
  storage.persist(STORAGE_FILE_PATH)

process.on 'uncaughtException', (exception) ->
  console.trace "Still running, but caught an exception: \n #{exception}"

# pattern for cron jobs can be found at
# http://help.sap.com/saphelp_xmii120/helpdata/en/44/89a17188cc6fb5e10000000a155369/content.htm
new CronJob '0 0 */6 * * *',
            -> storage.persist(STORAGE_FILE_PATH),
            -> console.log 'Stopped cron job',
            true

server.start(PORT)