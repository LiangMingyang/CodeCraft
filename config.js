// Generated by CoffeeScript 1.9.3
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
          max: 50,
          min: 0,
          idle: 10000
        },
        logging: null
      }
    },
    pageLimit: {
      submission: 15,
      contest: 15,
      member: 100,
      problem: 20
    },
    problem_resource_path: path.resolve(__dirname, 'modules/problem/resource'),
    cluster: 1,
    judge: {
      penalty: 20 * 60 * 1000,
      cache: 1000,
      max_code_length: 233333
    }
  };

}).call(this);

//# sourceMappingURL=config.js.map
