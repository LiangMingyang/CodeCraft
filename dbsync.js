// Generated by CoffeeScript 1.10.0
(function() {
  var config, db;

  config = require('./config');

  db = require('./database')(config.database.name, config.database.username, config.database.password, config.database.config);

  db.sync({
    force: false
  });

}).call(this);

//# sourceMappingURL=dbsync.js.map
