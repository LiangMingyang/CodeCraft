myUtils = require('./utils')
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
MEMBER_PAGE = 'member'
CONTEST_PAGE = 'contest'
PROBLEM_PAGE = 'problem'
INDEX_PAGE = '.'

#Foreign url
LOGIN_PAGE = '/user/login'

exports.getIndex = (req, res) ->
  Group = global.db.models.group
  User  = global.db.models.user
  Group
  .find(req.param.groupID, {
      include : [
        model: User
        as   : 'creator'
      ]
    })
  .then (group)->
    throw new myUtils.Error.UnknownGroup() if not group
    throw new myUtils.Error.UnknownGroup() if group.access_level in ['verifying','private']
    console.log group
    res.render 'group/detail', {
      user : req.session.user
      group : group
    }

  .catch myUtils.Error.UnknownGroup, (err)->
    req.flash 'info', err.message
    res.redirect INDEX_PAGE

exports.getEdit = (req, res)->
  res.render 'index', {
    title: 'You are at EDIT page'
  }