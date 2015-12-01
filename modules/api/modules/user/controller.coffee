exports.getMe = (req, res)->
  global.db.Promise.resolve()
  .then ->
    res.json(req.session.user)
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)
