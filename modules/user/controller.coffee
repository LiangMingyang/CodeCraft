exports.getIndex = (req, res) ->
  res.render 'index', {
    title: 'You have got user index here'
  }

exports.getLogin = (req, res) ->
  res.render 'index', {
    title: 'You are in login page now'
  }

exports.postLogin = (req, res) ->
  res.render 'index', {
    title: 'You logged in'
  }

exports.getRegister = (req, res) ->
  res.render 'index', {
    title: 'You are in register page now'
  }

exports.postRegister = (req, res) ->
  res.render 'index', {
    title: 'You registered'
  }