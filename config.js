// Generated by CoffeeScript 1.9.2
(function() {
  var path;

  path = require('path');

  module.exports = {
    database: {
      name: 'oj4th',
      username: 'root',
      password: 'alimengmengda',
      config: {
        host: 'localhost',
        dialect: 'mysql',
        port: 3306,
        timezone: '+08:00',
        pool: {
          max: 5,
          min: 0,
          idle: 10000
        }
      }
    },
    problem_resource_path: path.resolve(__dirname, './modules/problem/resource')
  };

}).call(this);

//# sourceMappingURL=config.js.map
