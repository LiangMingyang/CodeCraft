passwordHash = require('password-hash')
myUtils = require('./utils')

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
INDEX_PAGE = '.'

exports.getIndex = (req, res) ->
  Group = global.db.models.group
  User = global.db.models.user
  currentProblems = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    myUtils.findProblems(user, [
      model : Group
    ])
  .then (problems)->
    currentProblems = problems
    myUtils.getResultPeopleCount(problems, 'AC')
  .then (counts)->
    tmp = {}
    for p in counts
      tmp[p.problem_id] = p.count
    for p in currentProblems
      p.acceptedPeopleCount = 0
      p.acceptedPeopleCount = tmp[p.id] if tmp[p.id]
    myUtils.getResultPeopleCount(currentProblems)
  .then (counts)->
    tmp = {}
    for p in counts
      tmp[p.problem_id] = p.count
    for p in currentProblems
      p.triedPeopleCount = 0
      p.triedPeopleCount = tmp[p.id] if tmp[p.id]
    return currentProblems
  .then (problems)->
    res.render('problem/index', {
      user: req.session.user
      problems : problems
    })

  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown error!'
    res.redirect HOME_PAGE
