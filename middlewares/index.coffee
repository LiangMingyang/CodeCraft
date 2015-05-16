module.exports = [
  (req, res, next) ->
    if req.session.userID
        req.flash 'userID', req.session.userID
    next()
  ,
  (req, res, next) ->
    #console.log 'I am the second middleware of index'
    next()
]