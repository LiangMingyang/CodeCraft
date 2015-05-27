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

  db.Promise.resolve()
  .then -> #create users
    User.create {
      username: 'test@test.com'
      password: 'sha1$32f5d6c9$1$c84e8c6ed82e32549513da9444d940599ad30b96'
      nickname: 'test'
    }
  .then (user)-> #create groups
    testUser = user
    Group
      .create {
          name: 'test_group_private'
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
    Problem
      .create {
        title: 'test_problem_protect'
        access_level: 'protect'
      }
      .then (problem)->
        testUser.addProblem(problem)
        testGroup.addProblem(problem)
    Problem
      .create {
        title: 'test_problem_public'
        access_level: 'public'
      }
      .then (problem)->
        testUser.addProblem(problem)
        testGroup.addProblem(problem)
    Problem
      .create {
        title: 'test_problem'
        access_level: 'private'
      }
      .then (problem)->
        testUser.addProblem(problem)
        testGroup.addProblem(problem)
  .then ->
    console.log 'init: ok!'