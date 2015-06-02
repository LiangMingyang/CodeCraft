passwordHash = require('password-hash')
myUtils = require('./utils')

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
INDEX_PAGE = '.'

exports.getIndex = (req, res) ->
  myUtils.findProblems(req)
  .then (problems)->
    console.log problems
    res.render('problem/index', {
      title: 'Problem List Page',
      user: req.session.user,
      problems : problems
    })
