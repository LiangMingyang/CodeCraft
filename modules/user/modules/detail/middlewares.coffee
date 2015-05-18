HOME_PAGE = '/'
INDEX_PAGE = '.'

module.exports = [
  (req, res, next) ->
    if req.session.user == null || req.session.user.id != parseInt req.param.userID
      console.log req.url
      if req.url != HOME_PAGE
        req.flash 'info', 'Unauthorized Access'
        res.redirect HOME_PAGE
      else
        next()
    else
      next()
]