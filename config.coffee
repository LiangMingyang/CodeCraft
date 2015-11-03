path = require('path')
module.exports = {
  database:
    name: 'oj4th'
    username: 'root'
    password: 'alimengmengda'
    config:
      host: 'localhost'
      dialect: 'mysql'
      port: 3306
      timezone: '+08:00'
      pool:
        max: 500
        min: 0
        idle: 10000
      logging: null
  pageLimit :
    submission : 15
    contest : 15
    member : 100
    problem : 20
  problem_resource_path : path.resolve(__dirname,'modules/problem/resource')
  cluster: 3
  judge :
    penalty : 20 * 60 * 1000 #每次的罚时时间
    cache : 1000 #间歇性封榜时间
    max_code_length : 233333 #限制提交的代码长度
}