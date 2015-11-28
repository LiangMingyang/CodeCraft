exports.get = (req, res)->
  Group = global.db.models.group
  Problem = global.db.models.problem
  User = global.db.models.user
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findContest(req.session.user, req.params.contestId, [
      model : Group
    ,
      model : Problem
    ])
  .then (contest)->
    res.json(contest.get({plain:true}))
  .catch (err)->
    res.json(err)
    console.log err

exports.getRank = (req, res)->
  Problem = global.db.models.problem
  Group = global.db.models.group
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findContest(req.session.user, req.params.contestId, [
      model : Problem
      attributes : [
        'id'
      ]
    ])
  .then (contest)->
    throw new global.myErrors.UnknownContest() if not contest
    throw new global.myErrors.UnknownContest() if contest.start_time > (new Date())
    contest.problems.sort (a,b)->
      a.contest_problem_list.order-b.contest_problem_list.order
    global.myUtils.getRank(contest)
  .then (rank)->
    res.json(rank)
  .catch (err)->
    res.json(err)
    console.log err

exports.getSubmissions = (req, res)->
  Submission = global.db.models.submission
  global.db.Promise.resolve()
  .then ->
    Submission.findAll(
      where:
        creator_id: req.user.id
        contest_id: req.params.contestId
    )
  .then (submissions)->
    res.json(submission.get(plain:true) for submission in submissions)
  .catch (err)->
    console.log err