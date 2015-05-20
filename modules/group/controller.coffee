passwordHash = require('password-hash')
myUtils = require('./utils')
#page

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
CREATE_PAGE = 'create'
INDEX_PAGE = '.'

#Foreign url
LOGIN_PAGE = '/user/login'

#index

exports.getIndex = (req, res) ->
  Group = global.db.models.group
  User  = global.db.models.user
  Group
  .findAll({
      where   :
        access_level: ["protect","public"]
      include : [
        {
          model: User
          as   : 'creator'
        }
      ]
    })
  .then (groups)->
    res.render 'group/index', {
      title: 'You have got group index here'
      user : req.session.user
      groups : groups
    }

  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect INDEX_PAGE

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
    res.redirect HOME_PAGE

  .catch myUtils.Error.UnknownUser, (err)->
    req.flash 'info', err.message
    res.redirect LOGIN_PAGE
  .catch global.db.ValidationError, (err)->
    req.flash 'info', "#{err.errors[0].path} : #{err.errors[0].message}"
    res.redirect CREATE_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect INDEX_PAGE
