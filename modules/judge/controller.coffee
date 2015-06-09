myUtils = require('./utils')

INDEX_PAGE = 'index'

LOGIN_PAGE = 'user/login'
HOME_PAGE = '/'

exports.postTask = (req, res)->
  myUtils.auth(req.body.judge)
  .then ->
