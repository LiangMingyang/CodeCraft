Sequelize = require('sequelize')
path = require('path')
models = require('./models')

module.exports = (database, username, password, config)->
  sequelize = new Sequelize(database, username, password, config)

  #models

  Contest = sequelize.import path.join(__dirname, 'models/contest')
  ContestProblemList = sequelize.import path.join(__dirname, 'models/contest-problem-list')
  Group = sequelize.import path.join(__dirname, 'models/group')
  Judge = sequelize.import path.join(__dirname, 'models/judge')
  Membership = sequelize.import path.join(__dirname, 'models/membership')
  Problem = sequelize.import path.join(__dirname, 'models/problem')
  Submission = sequelize.import path.join(__dirname, 'models/submission')
  SubmissionCode = sequelize.import path.join(__dirname, 'models/submission_code')
  User = sequelize.import path.join(__dirname, 'models/user')
  Message = sequelize.import path.join(__dirname, 'models/message')
  Issue = sequelize.import path.join(__dirname, 'models/issue')
  IssueReply = sequelize.import path.join(__dirname, 'models/issue-reply')

  #associations

  #1:n

  User.hasMany(Issue)
  User.hasMany(IssueReply)
  User.hasMany(Contest)
  #User.hasMany(Group, {as:'creator'})
  User.hasMany(Message)
  User.hasMany(Submission)
  User.hasMany(Problem)

  Group.hasMany(Contest)
  Group.hasMany(Problem)
  Group.belongsTo(User, {
    as : 'creator'
  })

  Submission.belongsTo(User)

  Problem.hasMany(Submission)

  Contest.hasMany(Issue)
  Contest.hasMany(Submission)
  Contest.belongsTo(User, {
    as : 'creator'
  })

  Issue.hasMany(IssueReply)

  Judge.hasMany(Submission, {constraints: false})

  # n:m

  #user and group
  User.belongsToMany(Group, {
    through:
      model: Membership
    foreignKey: 'user_id'
  })

  Group.belongsToMany(User, {
    through:
      model: Membership
    foreignKey: 'group_id'
  })

  #problem and contest
  Problem.belongsToMany(Contest, {
    through:
      model: ContestProblemList
    foreignKey: 'problem_id'
  })

  Contest.belongsToMany(Problem, {
    through:
      model: ContestProblemList
    foreignKey: 'contest_id'
  })


  # 1:1

  Submission.hasOne(SubmissionCode)

  #transactions

  return sequelize