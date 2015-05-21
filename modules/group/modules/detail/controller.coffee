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
GROUP_PAGE = '/group' #然而这个东西并不能用相对路径

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
    res.redirect GROUP_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect GROUP_PAGE

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
    res.redirect GROUP_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect INDEX_PAGE

exports.getJoin = (req, res) ->
  Group = global.db.models.group
  User  = global.db.models.user
  joiner = undefined
  global.db.Promise.resolve()
  .then ->
    throw new myUtils.Error.UnknownUser() if not req.session.user
    User.find(req.session.user.id)
  .then (user)->
    throw new myUtils.Error.UnknownUser() if not user
    joiner = user
    Group.find(req.param.groupID)
  .then (group)->
    throw new myUtils.Error.UnknownGroup() if not group
    throw new myUtils.Error.UnknownGroup() if group.access_level not in ['protect','public']
    group.addUser(joiner, {access_level : 'verifying'})
  .then ->
    req.flash 'info', 'Please waiting for verifying'
    res.redirect INDEX_PAGE

  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch myUtils.Error.UnknownGroup, (err)->
    req.flash 'info', err.message
    res.redirect GROUP_PAGE
  .catch global.db.ValidationError, (err)->
    req.flash 'info', "#{err.errors[0].path} : #{err.errors[0].message}"
    res.redirect INDEX_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect INDEX_PAGE

exports.getProblem = (req, res) ->
  res.render 'index', {
    user   : req.session.user
    title : "Problems of #{req.param.groupID}"
  }

exports.getContest = (req, res) ->
  res.render 'index', {
    user : req.session.user
    title : "Contests of #{req.param.groupID}"
  }
