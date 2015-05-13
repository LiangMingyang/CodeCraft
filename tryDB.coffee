db = require('./db')('form', 'root', 'alimengmengda', {
  host: 'localhost',
  dialect: 'mysql',
  port: 3306,
  timezone: '+08:00',
  pool: {
    max: 5,
    min: 0,
    idle: 10000
  }
});

User = db.models.user
Submission = db.models.submission

User.create {
  username : 'lmy'
  password : 'password'
  email    : 'lmysoar@hotmail.com'
}
  .then (user)->
    #user = res.get()
    console.log user
    user.email = 'heheda'
    user.save()
  .catch (errs)->
    console.log errs

