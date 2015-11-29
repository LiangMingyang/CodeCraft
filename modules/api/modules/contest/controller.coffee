exports.get = (req, res)->
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
    throw new global.myError.UnknownContest() if not contest
    res.json(contest.get({plain:true}))
  .catch (err)->
    res.json(err)
    console.log err

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
    return [] if not req.session.user
    Submission.findAll(
      where:
        creator_id: req.session.user.id
        contest_id: req.params.contestId
    )
  .then (submissions)->
    res.json(submission.get(plain:true) for submission in submissions)
  .catch (err)->
    console.log err