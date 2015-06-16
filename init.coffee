module.exports = (db) ->
  Contest = db.models.contest
  ContestProblemList = db.models.contest_problem_list
  Group = db.models.group
  Judge = db.models.judge
  Membership = db.models.membership
  Problem = db.models.problem
  Submission = db.models.submission
  SubmissionCode = db.models.submission_code
  User = db.models.user
  Message = db.models.message
  Issue = db.models.issue
  IssueReply = db.models.issue_reply

  testUser = undefined
  testGroup = undefined
  testContest = undefined
  testProblem = undefined
  db.Promise.resolve()
  .then -> #create users
    User.create {
      username: "test@test.com"
      password: 'sha1$32f5d6c9$1$c84e8c6ed82e32549513da9444d940599ad30b96'
      nickname: 'test'
    }
  .then (user)-> #create groups
    testUser = user
    for i in [0..100]
      Group
        .create {
            name: "test_group_private#{i}"
            description: 'This group is created for testing private.'
            access_level: 'private'
          }
        .then (group)->
          group.setCreator(testUser)
        .then (group) ->
          group.addUser(testUser, {access_level : 'owner'}) #添加owner关系
    Group
      .create {
        name: 'test_group_verifying'
        description: 'This group is created for testing verifying.'
        access_level: 'verifying'
      }
      .then (group)->
        group.setCreator(testUser)
      .then (group) ->
        group.addUser(testUser, {access_level : 'owner'}) #添加owner关系
    Group
      .create {
        name: 'test_group'
        description: 'This group is created for testing.'
        access_level: 'protect'
      }
      .then (group)->
        testGroup = group
        group.setCreator(testUser)
      .then (group) ->
        group.addUser(testUser, {access_level : 'owner'}) #添加owner关系
  .then ->
    for i in [0..100]
      User
        .create {
          username: "test#{i}@test.com"
          password: 'sha1$32f5d6c9$1$c84e8c6ed82e32549513da9444d940599ad30b96'
          nickname: "test#{i}"
        }
        .then (user)->
          testGroup.addUser(user,{access_level : 'member'})
    Problem
      .create {
        title: 'test_problem_public'
        access_level: 'public'
      }
      .then (problem)->
        testProblem = problem
        testUser.addProblem(problem)
        testGroup.addProblem(problem)
  .then ->
    Problem
      .create {
        title: 'test_problem'
        access_level: 'private'
      }
      .then (problem)->
        testUser.addProblem(problem)
        testGroup.addProblem(problem)
  .then ->
    for i in [0..100]
      Problem
      .create {
        title: "test_problem_protect#{i}"
        access_level: 'protect'
      }
      .then (problem)->
        testUser.addProblem(problem)
        testGroup.addProblem(problem)
  .then ->
    for i in [0..100]
      Contest
        .create {
          title: "test_contest_private#{i}"
          access_level: 'private'
          description: '用来测试的比赛，权限是private'
          start_time : new Date("2015-05-20 10:00")
          end_time : new Date("2015-05-21 10:00")
        }
        .then (contest)->
          testUser.addContest(contest)
          testGroup.addContest(contest)
    db.Promise.all [
      Contest
        .create {
          title: 'test_contest_private'
          access_level: 'private'
          description: '用来测试的比赛，权限是private'
          start_time : new Date("2015-05-20 10:00")
          end_time : new Date("2015-05-21 10:00")
        }
        .then (contest)->
          testUser.addContest(contest)
          testGroup.addContest(contest)
    ,
      Contest
        .create {
          title: 'test_contest_public'
          access_level: 'public'
          description: '用来测试的比赛，权限是public'
          start_time : new Date("2016-05-20 10:00")
          end_time : new Date("2016-09-21 10:00")
        }
        .then (contest)->
          testUser.addContest(contest)
          testGroup.addContest(contest)
    ,
      Contest
        .create {
          title: 'test_contest'
          access_level: 'protect'
          description: '用来测试的比赛，权限是protect'
          start_time : new Date("2015-05-21 10:00")
          end_time : new Date("2015-06-21 10:00")
        }
        .then (contest)->
          testUser.addContest(contest)
          testGroup.addContest(contest)
          contest.addProblem(testProblem, {
            order : 0
            score : 1
          })
    ]
  .then ->
    db.Promise.all [
      Judge.create {
        name : "Judge1"
        secret_key : "沛神太帅了"
      }
    ,
      Judge.create {
        name : "Judge2"
        secret_key : "梁明阳专用judge"
      }
    ]
  .then ->
    for i in [0..100]
      Submission.create(
        result : 'AC'
      ).then (submission)->
        submission.setCreator(testUser)
        testUser.addSubmission(submission)
        testProblem.addSubmission(submission)
    return undefined
  .then ->
    console.log "init ok!"