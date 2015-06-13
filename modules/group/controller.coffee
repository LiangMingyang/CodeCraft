passwordHash = require('password-hash')
myUtils = require('./utils')
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
CREATE_PAGE = 'create'
INDEX_PAGE = 'index'

#Foreign url
LOGIN_PAGE = '/user/login'

#index

exports.getIndex = (req, res) ->
  User  = global.db.models.user
  currentUser = undefined
  currentGroups = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    myUtils.findGroups(user, [
      model : User
      as : 'creator'
    ])
  .then (groups)->
    currentGroups = groups
    myUtils.getGroupPeopleCount(groups)
  .then (counts)->
    myUtils.addGroupsCountKey(counts,currentGroups,'member_count')
  .then ->
    res.render 'group/index', {
      title: 'You have got group index here'
      user : req.session.user
      groups : currentGroups
    }

  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info',err.message
    res.redirect LOGIN_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE

#create

exports.getCreate = (req, res) ->
  res.render 'group/create', {
    title: 'create group'
    user : req.session.user
  }

exports.postCreate = (req, res) ->

  form = {
    name : req.body.name
    description : req.body.description
  }

  #preCheckForCreate
  User = global.db.models.user
  Group = global.db.models.group
  creator = undefined
  global.db.Promise.resolve() #开启一个解决方案链
  .then ->
    throw new myUtils.Error.UnknownUser() if not req.session.user
    User.find req.session.user.id
  .then (user)->
    throw new myUtils.Error.UnknownUser() if not user
    creator = user
    Group.create(form)
  .then (group) ->
    group.setCreator(creator)  #TODO: 把这个分成两行写总是让我十分的不舒服，求一种可以直接在create中就建立关系的方法
  .then (group) ->
    group.addUser(creator, {access_level : 'owner'}) #添加owner关系
  .then ->
    req.flash 'info', 'create group successfully'
    res.redirect INDEX_PAGE

  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch global.db.ValidationError, (err)->
    req.flash 'info', "#{err.errors[0].path} : #{err.errors[0].message}"
    res.redirect CREATE_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE
