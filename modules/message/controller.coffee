#global.myUtils = require('./utils')
Promise = require('sequelize').Promise

LOGIN_PAGE = 'user/login'
HOME_PAGE = '/'



exports.getIndex = (req, res) ->
  throw new global.myErrors.UnknownUser() if not req.session.user
  Message = global.db.models.message
  Message.findAll({
    where: {
      user_id: req.session.user.id
    },
    order: [
      ['created_at','DESC']
    ,
      ['id','DESC']
    ]
  })
  .then (messages) ->
    req.flash 'info', 'message success'
    res.render 'message/index', {
      title: 'Message List',
      user: req.session.user
      messages: messages
    }
  .catch global.myErrors.UnknownUser, (err)->
    req.flash 'info', err.messages
    res.redirect LOGIN_PAGE
  .catch (err)->
    console.log err.message
    err.message = "未知错误"
    res.render 'error', error: err
