Sequelize = require('sequelize')
path = require('path')

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

  User.hasMany(Contest)
  User.hasMany(Group)
  User.hasMany(Message)
  User.hasMany(Membership)
  User.hasMany(Submission)
  User.hasMany(Problem)
  Group.hasMany(Membership)
  Group.hasMany(Contest)
  Group.hasMany(Problem)
  Problem.hasMany(Submission)
  Problem.hasMany(ContestProblemList)
  Contest.hasMany(ContestProblemList)
  Contest.hasMany(Issue)
  Issue.hasMany(IssueReply)
  Submission.hasOne(SubmissionCode)
  Judge.hasMany(Submission, {constraints: false})


  #transactions

  return sequelize