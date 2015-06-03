passwordHash = require('password-hash')
myUtils = require('./utils')

HOME_PAGE = '/'
#CURRENT_PAGE = "./#{ req.url }"
INDEX_PAGE = '.'

exports.getIndex = (req, res) ->
  Group = global.db.models.group
  Submission = global.db.models.submission
  currentProblems = undefined
  problemIDs =undefined
  myUtils.findProblems(req, [
    model : Group
  ])
  .then (problems)->
    currentProblems = problems
    problemIDs = (problem.id for problem in problems)
    Submission.aggregate('creator_id', 'count', {
      where:
        problem_id : problemIDs
        result : 'AC'
      group : 'problem_id'
      distinct : true
      attributes : ['problem_id']
      plain : false
    })
  .then (ACcounts)->
    tmp = {}
    for p in ACcounts
      tmp[p.problem_id] = p.count
    for p in currentProblems
      p.acceptedPeopleCount = 0
      p.acceptedPeopleCount = tmp[p.id] if tmp[p.id]
    Submission.aggregate('creator_id', 'count', {
      where:
        problem_id : problemIDs
      group : 'problem_id'
      distinct : true
      attributes : ['problem_id']
      plain : false
    })
  .then (counts)->
    tmp = {}
    for p in counts
      tmp[p.problem_id] = p.count
    for p in currentProblems
      p.triedPeopleCount = 0
      p.triedPeopleCount = tmp[p.id] if tmp[p.id]
    res.render('problem/index', {
      user: req.session.user
      problems : currentProblems
    })

  .catch (err)->
    console.log err
    req.flash 'info', 'Unknown error!'
    res.redirect HOME_PAGE
