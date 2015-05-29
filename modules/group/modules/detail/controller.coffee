myUtils = require('./utils')
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
MEMBER_PAGE = 'member'
CONTEST_PAGE = 'contest'
PROBLEM_PAGE = 'problem'
INDEX_PAGE = 'index'
GROUP_PAGE = '/group'

#Foreign url
LOGIN_PAGE = '/user/login'#然而这个东西并不能用相对路径

exports.getIndex = (req, res) ->
  Group = global.db.models.group
  User  = global.db.models.user
  currentGroup = undefined
  isMember = false
  Group
  .find(req.params.groupID, {
      include : [
        model: User
        as   : 'creator'
      ]
    })
  .then (group)->
    throw new myUtils.Error.UnknownGroup() if not group
    throw new myUtils.Error.UnknownGroup() if group.access_level not in ['protect','public']
    currentGroup = group
    if req.session.user
      group
        .hasUser(req.session.user.id)
        .then (joined)->
          isMember = joined
  .then ->
    res.render 'group/detail', {
      user : req.session.user
      group : currentGroup
      isMember : isMember
    }

  .catch myUtils.Error.UnknownGroup, (err)->
    req.flash 'info', err.message
    res.redirect GROUP_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getMember = (req, res) ->
  Group = global.db.models.group
  User  = global.db.models.user
  Group
  .find(req.params.groupID, {
      include : [
        model: User
        through:
          where:
            access_level : ['member', 'admin', 'owner'] #仅显示以上权限的成员
      ,
        model: User
        as : 'creator'
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
    res.redirect HOME_PAGE

exports.getJoin = (req, res) ->
  Group = global.db.models.group
  User  = global.db.models.user
  joiner = undefined
  currentGroup = undefined
  global.db.Promise.resolve()
  .then ->
    throw new myUtils.Error.UnknownUser() if not req.session.user
    User.find(req.session.user.id)
  .then (user)->
    throw new myUtils.Error.UnknownUser() if not user
    joiner = user
    Group.find(req.params.groupID)
  .then (group)->
    throw new myUtils.Error.UnknownGroup() if not group
    throw new myUtils.Error.UnknownGroup() if group.access_level not in ['protect','public']
    currentGroup = group
    group.hasUser(joiner)
  .then (res) ->
    throw new myUtils.Error.UnknownGroup() if res
    currentGroup.addUser(joiner, {access_level : 'verifying'})
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
    res.redirect HOME_PAGE

exports.getProblem = (req, res) ->
  Group = global.db.models.group
  Problem = global.db.models.problem
  User = global.db.models.user
  currentGroup = undefined
  Group
  .find(req.params.groupID, {
      include : [
        model: User
        as   : 'creator'
      ]
    })
  .then (group)->
    throw new myUtils.Error.UnknownGroup() if not group
    currentGroup = group
    group.getProblems()
  .then (problems)->
    res.render 'group/problem', {
      user   : req.session.user
      group  : currentGroup
      problems : problems
    }

  .catch myUtils.Error.UnknownGroup, (err)->
    req.flash 'info', err.message
    res.redirect GROUP_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getContest = (req, res) ->
  res.render 'index', {
    user : req.session.user
    title : "Contests of #{req.params.groupID}"
  }
