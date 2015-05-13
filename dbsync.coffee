require('./db')('form', 'root', 'alimengmengda', {
  host: 'localhost'
  dialect: 'mysql'
  port: 3306
  timezone: '+08:00'
  pool:
    max: 5
    min: 0
    idle: 10000
}).sync {force:true}
  .catch (err)->
    console.log err.message
  .done ->
    console.log 'Sync successfully!'
    process.exit(0)