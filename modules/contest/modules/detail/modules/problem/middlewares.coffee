myUtils = require('./utils')

LOGIN_PAGE = '/user/login'
HOME_PAGE = '/'
CONTEST_PAGE = '/contest'

module.exports = [
  (req, res, next) ->
    myUtils.findContest(req, req.params.contestID)
    .then (contest)->
      throw new myUtils.Error.UnknownContest() if not contest
      throw new myUtils.Error.UnknownContest() if contest.start_time > (new Date())
      req.body.contest = contest
      order = myUtils.lettersToNumber(req.params.problemID)
      contest.getProblems(
        through:
          where:
            order : order
        attributes : ['id']
      )
    .then (problems)->
      throw new myUtils.Error.UnknownProblem() if problems.length is 0
      req.body.problemID = problems[0].id
    .then ->
      next()

    .catch myUtils.Error.UnknownContest, myUtils.Error.UnknownProblem, (err)->
      req.flash 'info', err.message
      res.redirect CONTEST_PAGE
    .catch (err)->
      console.log err
      req.flash 'info', 'Unknown error'
      res.redirect HOME_PAGE
]