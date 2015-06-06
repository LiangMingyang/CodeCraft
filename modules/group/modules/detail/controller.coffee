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
  User  = global.db.models.user
  currentGroup = undefined
  isMember = false
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    myUtils.findGroup(user, req.params.groupID, [
      model : User
      as : 'creator'
    ])
  .then (group)->
    throw new myUtils.Error.UnknownGroup() if not group
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
  User  = global.db.models.user
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    myUtils.findGroup(user, req.params.groupID, [
      model : User
      as : 'creator'
    ,
      model: User
      through:
        where:
          access_level : ['member', 'admin', 'owner'] #仅显示以上权限的成员
    ])
  .then (group)->
    throw new myUtils.Error.UnknownGroup() if not group
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
    myUtils.findGroup(user, req.params.groupID)
  .then (group)->
    throw new myUtils.Error.UnknownGroup() if not group
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
  User = global.db.models.user
  Group = global.db.models.group
  currentGroup = undefined
  currentUser = undefined
  currentProblems = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    myUtils.findGroup(user, req.params.groupID, [
      model : User
      as : 'creator'
    ])
  .then (group)->
    throw new myUtils.Error.UnknownGroup() if not group
    currentGroup = group
    myUtils.findProblems(currentUser, [
      model : Group
      where :
        id : group.id
    ])
  .then (problems)->
    currentProblems = problems
    myUtils.getResultPeopleCount(problems, 'AC')
  .then (counts)-> #AC people counts
    tmp = {}
    for p in counts
      tmp[p.problem_id] = p.count
    for p in currentProblems
      p.acceptedPeopleCount = 0
      p.acceptedPeopleCount = tmp[p.id] if tmp[p.id]
    myUtils.getResultPeopleCount(currentProblems)
  .then (counts)-> #Tried people counts
    tmp = {}
    for p in counts
      tmp[p.problem_id] = p.count
    for p in currentProblems
      p.triedPeopleCount = 0
      p.triedPeopleCount = tmp[p.id] if tmp[p.id]
    myUtils.getResultCount(currentUser,currentProblems,'AC')
  .then (counts)-> #this user accepted problems
    tmp = {}
    for p in counts
      tmp[p.problem_id] = p.count
    for p in currentProblems
      p.accepted = 0
      p.accepted = tmp[p.id] if tmp[p.id]
    myUtils.getResultCount(currentUser,currentProblems)
  .then (counts)-> #this user tried problems
    tmp = {}
    for p in counts
      tmp[p.problem_id] = p.count
    for p in currentProblems
      p.tried = 0
      p.tried = tmp[p.id] if tmp[p.id]
    return currentProblems
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
  User = global.db.models.user
  currentGroup = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    myUtils.findGroup(user, req.params.groupID, [
      model : User
      as : 'creator'
    ])
  .then (group)->
    throw new myUtils.Error.UnknownGroup() if not group
    currentGroup = group
    group.getUsers(
      where :
        id : (
          if req.session.user
            req.session.user.id
          else
            null
        )
      attributes : []
    )
  .then (users)->
    access = ['public']
    if users.length isnt 0
      user = users[0]
      access.push 'protect' if user.membership.access_level isnt 'verifying'
      access.push 'private' if user.membership.access_level in ['owner','admin']
    currentGroup.getContests(
      where:
        $or:[
          access_level : access
        ,
          creator_id : req.session.user.id if req.session.user
        ]
    )
  .then (contests)->
    res.render 'group/contest', {
      user   : req.session.user
      group  : currentGroup
      contests : contests
    }

  .catch myUtils.Error.UnknownGroup, (err)->
    req.flash 'info', err.message
    res.redirect GROUP_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE
