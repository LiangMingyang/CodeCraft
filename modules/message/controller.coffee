myUtils = require('./utils')

LOGIN_PAGE = 'user/login'
HOME_PAGE = '/'

exports.getIndex = (req, res) ->
  Message = global.db.models.message
  Message.findAll({
    where: {
      user_id: req.session.user.id
    }
  })
  .then (messages) ->
    req.flash 'info', 'message success'
    res.render 'message/index', {
      title: 'Message List',
      user: req.session.user
      messages: messages
    }
  .catch myUtils.Error.UnknownUser, (err)->
    console.log err
    req.flash 'info', "Please Login First!"
    res.redirect LOGIN_PAGE
  .catch (err)->
    console.log err
    req.flash 'info', "Unknown Error!"
    res.redirect HOME_PAGE
