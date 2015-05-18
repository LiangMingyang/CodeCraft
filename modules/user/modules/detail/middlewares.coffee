module.exports = [
  (req, res, next) ->
    console.log req.session
    if req.session && req.session.userID && req.session.userID == req.param.userID then next()
    else if req.url == '/' then next()
    else next()
]