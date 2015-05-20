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
  res.render 'index', {
    title: 'You have got group index here'
    user : req.session.user
  }

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

  global.db.Promise.resolve() #开启一个解决方案链
  .then ->
    throw new myUtils.Error.UnknownUser() if not req.session.user
    User.find req.session.user.id
  .then (user)->
    throw new myUtils.Error.UnknownUser() if not user
    form.creator_id = user.id   #加入外键
    Group.create(form)
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
