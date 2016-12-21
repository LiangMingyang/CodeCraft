config = require('./config')

db = require('./database')(
  config.database.name,
  config.database.username,
  config.database.password,
  config.database.config
)
db.sync(force:false);
#require('./init')(db)

