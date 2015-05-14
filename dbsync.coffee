config = require('./config')

db = require('./database')(
  config.database.name,
  config.database.username,
  config.database.password,
  config.database.config
)
  .sync {force:true}
  .catch (err)->
    console.log err.message
  .done ->
    console.log 'Sync successfully!'
    process.exit(0)