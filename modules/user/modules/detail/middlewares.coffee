module.exports = [
  (req, res, next) ->
    if req.session && req.session.userID && req.session.userID == req.param.userID then next()
    else if req.url == '/' then next()
    else throw new Error 'undefined'
]