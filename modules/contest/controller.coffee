passwordHash = require('password-hash')
#global.myUtils = require('./utils')
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
INDEX_PAGE = 'index'

#Foreign url
LOGIN_PAGE = '/user/login'

#index

exports.getIndex = (req, res) ->
  Group = global.db.models.group
  global.db.Promise.resolve()
  .then ->
    req.query.page ?= 1
    offset = (req.query.page-1)*global.config.pageLimit.contest
    global.myUtils.findAndCountContests(req.session.user, offset, {
      model :  Group
      attributes : [
        'id'
      ,
        'name'
      ]
    })
  .then (result)->
    contests = result.rows
    count = result.count
    res.render 'contest/index', {
      user : req.session.user
      contests : contests
      page : req.query.page
      pageLimit : global.config.pageLimit.contest
      contestCount : count
    }
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

