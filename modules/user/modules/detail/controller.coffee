exports.getIndex = (req, res) ->
  User = global.db.models.user
  User.find req.param.userID.then (user) ->

    res.render 'index', {
      title: 'Your userID=' + req.param.userID,
      user: {
        email: user.username,
        nickname: user.nickname,
        school: user.school,
        college: user.college,
        description: user.description,
        student_id: user.student_id
      }
    }


exports.getEdit = (req, res)->
  res.render 'index', {
    title: 'You are at EDIT page'
  }

exports.postEdit = (req, res)->
  User = global.db.models.user
  User.find req.param.userID.then (user) ->
    if req.param.nickname then user.nickname = req.param.nickname
    if req.param.school then user.school = req.param.school
    if req.param.college then user.college = req.param.college
    if req.param.description then user.description = req.param.description
    user.save().then ->
      res.render 'index', {
        title: 'You have updated your info'
      }

exports.postPassword = (req, res)->
  User = global.db.models.user
  User.find req.param.userID.then (user) ->
    if req.param.oldPwd && req.param.oldPwd == req.param.newPwd then user.password = req.param.newPwd
    user.save().then ->
      res.render 'index', {
        title: 'You have updated your password'
      }
