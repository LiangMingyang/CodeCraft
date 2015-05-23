LOGIN_PAGE = '/user/login'

module.exports = [
  (req, res, next) ->
    if req.session.user == null
        req.flash 'info', 'Please Login First'
        res.redirect LOGIN_PAGE
    else
      next()
]