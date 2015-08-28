#global.myUtils = require('./utils')
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
  User  = global.db.models.user
  currentGroup = undefined
  isMember = false
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    global.myUtils.findGroup(user, req.params.groupID, [
      model : User
      as : 'creator'
    ])
  .then (group)->
    throw new global.myErrors.UnknownGroup() if not group
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

  .catch global.myErrors.UnknownGroup, (err)->
    req.flash 'info', err.message
    res.redirect GROUP_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getMember = (req, res) ->
  User  = global.db.models.user
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    global.myUtils.findGroup(user, req.params.groupID, [
      model : User
      as : 'creator'
    ,
      model: User
      through:
        where:
          access_level : ['member', 'admin', 'owner'] #仅显示以上权限的成员
    ])
  .then (group)->
    throw new global.myErrors.UnknownGroup() if not group
    res.render 'group/member', {
      user : req.session.user
      group : group
    }

  .catch global.myErrors.UnknownGroup, (err)->
    req.flash 'info', err.message
    res.redirect GROUP_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getJoin = (req, res) ->
  User  = global.db.models.user
  joiner = undefined
  currentGroup = undefined
  global.db.Promise.resolve()
  .then ->
    throw new global.myErrors.UnknownUser() if not req.session.user
    User.find(req.session.user.id)
  .then (user)->
    throw new global.myErrors.UnknownUser() if not user
    joiner = user
    global.myUtils.findGroup(user, req.params.groupID)
  .then (group)->
    throw new global.myErrors.UnknownGroup() if not group
    currentGroup = group
    group.hasUser(joiner)
  .then (res) ->
    throw new global.myErrors.UnknownGroup() if res
    currentGroup.addUser(joiner, {access_level : 'verifying'})
  .then ->
    req.flash 'info', 'Please waiting for verifying'
    res.redirect INDEX_PAGE

  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch global.myErrors.UnknownGroup, (err)->
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
  User = global.db.models.user
  Group = global.db.models.group
  currentGroup = undefined
  currentUser = undefined
  problemCount = undefined
  currentProblems = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    global.myUtils.findGroup(user, req.params.groupID, [
      model : User
      as : 'creator'
    ])
  .then (group)->
    throw new global.myErrors.UnknownGroup() if not group
    currentGroup = group
    req.query.page ?= 1
    offset = (req.query.page-1)*global.config.pageLimit.problem
    global.myUtils.findAndCountProblems(currentUser, offset, [
      model : Group
      where :
        id : group.id
    ])
  .then (result)->
    problemCount = result.count
    currentProblems = result.rows
    global.myUtils.getProblemsStatus(currentProblems,currentUser)
  .then ->
    res.render 'group/problem', {
      user   : req.session.user
      group  : currentGroup
      problems : currentProblems
      page : req.query.page
      pageLimit : global.config.pageLimit.problem
      problemCount : problemCount
    }

  .catch global.myErrors.UnknownGroup, (err)->
    req.flash 'info', err.message
    res.redirect GROUP_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

exports.getContest = (req, res) ->
  User = global.db.models.user
  Group = global.db.models.group
  currentGroup = undefined
  currentUser = undefined
  contestCount = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    global.myUtils.findGroup(user, req.params.groupID)
  .then (group)->
    throw new global.myErrors.UnknownGroup() if not group
    currentGroup = group
    req.query.page ?= 1
    offset = (req.query.page-1)*global.config.pageLimit.contest
    global.myUtils.findAndCountContests(currentUser, offset, [
      model : Group
      where :
        id : group.id
    ])
  .then (result)->
    contests = result.rows
    contestCount = result.count
    res.render 'group/contest', {
      user   : req.session.user
      group  : currentGroup
      contests : contests
      page : req.query.page
      pageLimit : global.config.pageLimit.contest
      contestCount : contestCount
    }

  .catch global.myErrors.UnknownGroup, (err)->
    req.flash 'info', err.message
    res.redirect GROUP_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE
