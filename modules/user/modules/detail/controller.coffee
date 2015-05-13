exports.getIndex = (req, res) ->
  res.render 'index', {
    title:'Your userID='+req.param.userID
  }

exports.getEdit = (req, res)->
  res.render 'index', {
    title: 'You are at EDIT page'
  }