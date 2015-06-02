passwordHash = require('password-hash')
myUtils = require('./utils')

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
INDEX_PAGE = '.'

exports.getIndex = (req, res) ->
  Group = global.db.models.group
  myUtils.findProblems(req, [
    model : Group
  ])
  .then (problems)->
    res.render('problem/index', {
      title: 'Problem List Page',
      user: req.session.user,
      problems : problems
    })
