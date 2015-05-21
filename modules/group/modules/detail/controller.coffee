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
    throw new myUtils.Error.UnknownGroup() if group.access_level not in ['protect','public']
    res.render 'group/detail', {
      user : req.session.user
      group : group
    }

  .catch myUtils.Error.UnknownGroup, (err)->
    req.flash 'info', err.message
    res.redirect INDEX_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect INDEX_PAGE

exports.getMember = (req, res) ->
  Group = global.db.models.group
  User  = global.db.models.user
  Group
  .find(req.param.groupID, {
      include : [
        model: User
        through:
          where:
            access_level : ['member', 'admin', 'owner'] #仅显示以上权限的成员
      ]
    })
  .then (group)->
    throw new myUtils.Error.UnknownGroup() if not group
    throw new myUtils.Error.UnknownGroup() if group.access_level not in ['protect','public']
    res.render 'group/member', {
      user : req.session.user
      group : group
    }

  .catch myUtils.Error.UnknownGroup, (err)->
    req.flash 'info', err.message
    res.redirect INDEX_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect INDEX_PAGE

exports.getProblem = (req, res) ->
  res.render 'index', {
    titile : "Problems of #{req.param.groupID}"
  }

exports.getContest = (req, res) ->
  res.render 'index', {
    titile : "Contests of #{req.param.groupID}"
  }
