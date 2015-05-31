passwordHash = require('password-hash')
myUtils = require('./utils')
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
INDEX_PAGE = 'index'

#Foreign url
LOGIN_PAGE = '/user/login'

#index

exports.getIndex = (req, res) ->
  Contest = global.db.models.contest
  User = global.db.models.user
  myUtils.findContests(req)
  .then (contests)->
    res.render 'contest/index', {
      user : req.session.user
      contests : contests
    }
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

