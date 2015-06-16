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
  User = global.db.models.user
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    myUtils.findAndCountContests(user, req.query.offset)
  .then (result)->
    contests = result.rows
    count = result.count
    res.render 'contest/index', {
      user : req.session.user
      contests : contests
      offset : req.query.offset
      pageLimit : global.config.pageLimit.contest
      count : count
    }
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

