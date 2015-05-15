models = require '../../../../database'

exports.getIndex = (req, res) ->
  console.log models
  models.User.find req.param.userID
    .then (user) ->
      console.log user
      res.render 'index', {
        title: 'Your userID=' + req.param.userID
      }


exports.getEdit = (req, res)->
  res.render 'index', {
    title: 'You are at EDIT page'
  }

exports.postEdit = (req, res)->
  res.render 'index', {
    title: 'You have updated your info'
  }

exports.postPassword = (req, res)->
  res.render 'index', {
    title: 'You have updated your password'
  }
