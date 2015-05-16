#index

exports.getIndex = (req, res) ->
  res.render 'index', {
    title: 'You have got user index here'
  }

#login

exports.getLogin = (req, res) ->
  res.render 'login', {
    title: 'login'
  }

exports.postLogin = (req, res) ->
  res.render 'index', {
    title: 'You logged in'
  }

#register

exports.getRegister = (req, res) ->
  res.render 'index', {
    title: 'You are in register page now'
  }

exports.postRegister = (req, res) ->
  res.render 'index', {
    title: 'You registered'
  }