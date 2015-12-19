config = require('./config')

db = require('./database')(
  config.database.name,
  config.database.username,
  config.database.password,
  config.database.config
)

require('./init')(db)

