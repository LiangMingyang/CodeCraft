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

  #associations

  Contest.hasOne User, {as:'creator'}
  Contest.hasOne Group
  

  #transactions

  return sequelize