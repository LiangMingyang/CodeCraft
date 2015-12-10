exports.getContest = (req, res)->
  Group = global.db.models.group
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findContest(req.session.user, req.params.contestId, [
      model : Group
    ,
      model : Problem
    ])
  .then (contest)->
    throw new global.myErrors.UnknownUser() if not contest and not req.session.user
    throw new global.myErrors.UnknownContest() if not contest
    contest = contest.get(plain:true)
    OFFSET = 1000*60*2
    if contest.start_time.getTime()-OFFSET > (new Date()).getTime()
      contest.problems = []
    res.json(contest)
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)


exports.getRank = (req, res)->
  Problem = global.db.models.problem
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findContest(req.session.user, req.params.contestId, [
      model : Problem
      attributes : [
        'id'
      ]
    ])
  .then (contest)->
    throw new global.myErrors.UnknownUser() if not contest and not req.session.user
    throw new global.myErrors.UnknownContest() if not contest
    throw new global.myErrors.UnknownContest() if contest.start_time > (new Date())
    contest.problems.sort (a,b)->
      a.contest_problem_list.order-b.contest_problem_list.order
    global.myUtils.getRank(contest)
  .then (rank)->
    res.json(rank)
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)

exports.getSubmissions = (req, res)->
  Submission = global.db.models.submission
  global.db.Promise.resolve()
  .then ->
    return [] if not req.session.user
    Submission.findAll(
      where:
        creator_id: req.session.user.id
        contest_id: req.params.contestId
      order : [
        ['created_at', 'DESC']
      ,
        ['id','DESC']
      ]
    )
  .then (submissions)->
    res.json(submission.get(plain:true) for submission in submissions)
  .catch (err)->
    res.status(err.status)
    res.json(error:err.message)

exports.postSubmissions = (req, res) ->
  User = global.db.models.user
  Problem = global.db.models.problem
  currentUser = undefined
  currentProblem = undefined
  currentContest = undefined
  currentSubmission = undefined


  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    throw new global.myErrors.UnknownUser() if not user
    global.myUtils.findContest(user,req.params.contestId,[
      model: Problem
    ])
  .then (contest)->
    throw new global.myErrors.UnknownUser() if not contest and not req.session.user
    throw new global.myErrors.UnknownContest() if not contest
    throw new global.myErrors.InvalidAccess() if (new Date()) < contest.start_time or contest.end_time < (new Date())
    contest.problems.sort (a,b)->
      a.contest_problem_list.order-b.contest_problem_list.order
    currentContest = contest
    problem = currentContest.problems[req.body.order]
    throw new global.myErrors.UnknownProblem() if not problem
    currentProblem = problem
    form = {
      lang : req.body.lang
      code_length : req.body.code.length
    }
    form_code = {
      content: req.body.code
    }
    global.myUtils.createSubmissionTransaction(form, form_code, currentProblem, currentUser)
  .then (submission) ->
    currentSubmission = submission.get(plain: true) if submission
    currentContest.addSubmission(submission)
  .then ->
    res.json(currentSubmission)

  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)

exports.getTime = (req, res)->
  now = new Date()
  res.json(server_time:now)