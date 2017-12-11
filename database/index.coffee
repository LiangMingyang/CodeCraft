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
  Feedback = sequelize.import path.join(__dirname, 'models/feedback')
  Tag = sequelize.import path.join(__dirname, 'models/tag')
  ProblemTag = sequelize.import path.join(__dirname, 'models/problem-tag')
  Recommendation = sequelize.import path.join(__dirname, 'models/recommendation')
  Solution = sequelize.import path.join(__dirname, 'models/solution')
  Evaluation = sequelize.import path.join(__dirname, 'models/evaluation-solution')

  #associations

  #1:n

  Feedback.belongsTo(User, {
    as : 'creator'
  })

  User.hasMany(Contest, {
    foreignKey: 'creator_id'
  })
  #User.hasMany(Group, {as:'creator'})
  User.hasMany(Message)
  User.hasMany(Submission, {
    foreignKey: 'creator_id'
  })
  User.hasMany(Problem, {
    foreignKey: 'creator_id'
  })
  User.hasMany(Evaluation, {
    foreignKey: 'creator_id'
  })

  Group.hasMany(Contest)
  Group.hasMany(Problem)
  Group.belongsTo(User, {
    as : 'creator'
  })

  Submission.belongsTo(User, {
    as : 'creator'
  })
  Submission.belongsTo(Problem)
  Submission.belongsTo(Contest)

  Problem.hasMany(Submission)
  Problem.belongsTo(User, {
    as : 'creator'
  })
  Problem.belongsTo(Group)

  Contest.hasMany(Issue)
  Contest.hasMany(Submission)
  Contest.belongsTo(User, {
    as : 'creator'
  })
  Contest.belongsTo(Group)

  Issue.hasMany(IssueReply)
  Issue.belongsTo(User, {
    as : 'creator'
  })
  Issue.belongsTo(Contest)
  Issue.belongsTo(Problem)

  IssueReply.belongsTo(Issue)
  IssueReply.belongsTo(User)

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

  #tag and problem
  Problem.belongsToMany(Tag,
    through:
      model: ProblemTag
    foreignKey: 'problem_id'
  )
  Tag.belongsToMany(Problem,
    through:
      model: ProblemTag
    foreignKey: 'tag_id'
  )

  # 1:1

  Submission.hasOne(SubmissionCode)
  Submission.hasOne(Solution)
  Solution.belongsTo(Submission)
  Solution.hasMany(Evaluation)
  # user and recommendation and problem
  Evaluation.belongsTo(User,
    as: 'creator'
  )
  Evaluation.belongsTo(Solution)

  Problem.belongsToMany(User, {
    through:
      model: Recommendation
    foreignKey: 'problem_id'
  })

  User.belongsToMany(Problem, {
    as: 'recommendation'
    through:
      model: Recommendation
    foreignKey: 'user_id'
  })

  #transactions

  return sequelize