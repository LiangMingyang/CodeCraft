passwordHash = require('password-hash')
myUtils = require('./utils')

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
INDEX_PAGE = '.'

exports.getIndex = (req, res) ->
  res.render('problem/index', {
    title: 'Problem List Page',
    headline: 'Problem index(SHEN ME DOU MEI YOU!)'
  })
