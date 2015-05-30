// Generated by CoffeeScript 1.9.2
(function() {
  var Sequelize, models, path;

  Sequelize = require('sequelize');

  path = require('path');

  models = require('./models');

  module.exports = function(database, username, password, config) {
    var Contest, ContestProblemList, Group, Issue, IssueReply, Judge, Membership, Message, Problem, Submission, SubmissionCode, User, sequelize;
    sequelize = new Sequelize(database, username, password, config);
    Contest = sequelize["import"](path.join(__dirname, 'models/contest'));
    ContestProblemList = sequelize["import"](path.join(__dirname, 'models/contest-problem-list'));
    Group = sequelize["import"](path.join(__dirname, 'models/group'));
    Judge = sequelize["import"](path.join(__dirname, 'models/judge'));
    Membership = sequelize["import"](path.join(__dirname, 'models/membership'));
    Problem = sequelize["import"](path.join(__dirname, 'models/problem'));
    Submission = sequelize["import"](path.join(__dirname, 'models/submission'));
    SubmissionCode = sequelize["import"](path.join(__dirname, 'models/submission_code'));
    User = sequelize["import"](path.join(__dirname, 'models/user'));
    Message = sequelize["import"](path.join(__dirname, 'models/message'));
    Issue = sequelize["import"](path.join(__dirname, 'models/issue'));
    IssueReply = sequelize["import"](path.join(__dirname, 'models/issue-reply'));
    User.hasMany(Issue);
    User.hasMany(IssueReply);
    User.hasMany(Contest);
    User.hasMany(Message);
    User.hasMany(Submission);
    User.hasMany(Problem);
    Group.hasMany(Contest);
    Group.hasMany(Problem);
    Group.belongsTo(User, {
      as: 'creator'
    });
    Submission.belongsTo(User);
    Problem.hasMany(Submission);
    Contest.hasMany(Issue);
    Contest.hasMany(Submission);
    Contest.belongsTo(User, {
      as: 'creator'
    });
    Issue.hasMany(IssueReply);
    Judge.hasMany(Submission, {
      constraints: false
    });
    User.belongsToMany(Group, {
      through: {
        model: Membership
      },
      foreignKey: 'user_id'
    });
    Group.belongsToMany(User, {
      through: {
        model: Membership
      },
      foreignKey: 'group_id'
    });
    Problem.belongsToMany(Contest, {
      through: {
        model: ContestProblemList
      },
      foreignKey: 'problem_id'
    });
    Contest.belongsToMany(Problem, {
      through: {
        model: ContestProblemList
      },
      foreignKey: 'contest_id'
    });
    Submission.hasOne(SubmissionCode);
    return sequelize;
  };

}).call(this);

//# sourceMappingURL=index.js.map
