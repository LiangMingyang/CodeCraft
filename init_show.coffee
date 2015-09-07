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
  .then ->
    User.create {
      username: "test@test.com"
      password: 'sha1$32f5d6c9$1$c84e8c6ed82e32549513da9444d940599ad30b96'
      nickname: 'test'
    }
  .then (user)-> #create groups
    testUser = user
    Group.create {
      name : 'C++程序设计'
      description : '一门重要的课'
      access_level : 'protect'
    }
  .then (group)->
    testGroup = group
    group.setCreator(testUser)
  .then (group) ->
    group.addUser(testUser, {access_level : 'owner'}) #添加owner关系
