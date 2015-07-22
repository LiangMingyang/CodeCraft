// Generated by CoffeeScript 1.9.3
(function() {
  var config, db;

  config = require('./config');

  db = require('./database')(config.database.name, config.database.username, config.database.password, config.database.config).sync({
    force: true
  }).then(function(db) {
    console.log('Sync successfully!');
    return require('./init')(db);
  })["catch"](function(err) {
    return console.log(err.message);
  });

}).call(this);

//# sourceMappingURL=dbsync.js.map
