// Generated by CoffeeScript 1.10.0
(function() {
  var Sequelize, models, path;

  Sequelize = require('sequelize');

  path = require('path');

  models = require('./models');

  module.exports = function(database, username, password, config) {
    var Contest, ContestProblemList, Evaluation, Feedback, Group, Issue, IssueReply, Judge, Membership, Message, Problem, ProblemTag, Recommendation, Solution, Submission, SubmissionCode, Tag, User, sequelize;
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
    Feedback = sequelize["import"](path.join(__dirname, 'models/feedback'));
    Tag = sequelize["import"](path.join(__dirname, 'models/tag'));
    ProblemTag = sequelize["import"](path.join(__dirname, 'models/problem-tag'));
    Recommendation = sequelize["import"](path.join(__dirname, 'models/recommendation'));
    Solution = sequelize["import"](path.join(__dirname, 'models/solution'));
    Evaluation = sequelize["import"](path.join(__dirname, 'models/evaluation-solution'));
    Feedback.belongsTo(User, {
      as: 'creator'
    });
    User.hasMany(Contest, {
      foreignKey: 'creator_id'
    });
    User.hasMany(Message);
    User.hasMany(Submission, {
      foreignKey: 'creator_id'
    });
    User.hasMany(Problem, {
      foreignKey: 'creator_id'
    });
    User.hasMany(Evaluation);
    Group.hasMany(Contest);
    Group.hasMany(Problem);
    Group.belongsTo(User, {
      as: 'creator'
    });
    Submission.belongsTo(User, {
      as: 'creator'
    });
    Submission.belongsTo(Problem);
    Submission.belongsTo(Contest);
    Problem.hasMany(Submission);
    Problem.belongsTo(User, {
      as: 'creator'
    });
    Problem.belongsTo(Group);
    Contest.hasMany(Issue);
    Contest.hasMany(Submission);
    Contest.belongsTo(User, {
      as: 'creator'
    });
    Contest.belongsTo(Group);
    Issue.hasMany(IssueReply);
    Issue.belongsTo(User, {
      as: 'creator'
    });
    Issue.belongsTo(Contest);
    Issue.belongsTo(Problem);
    IssueReply.belongsTo(Issue);
    IssueReply.belongsTo(User);
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
    Problem.belongsToMany(Tag, {
      through: {
        model: ProblemTag
      }
    });
    Tag.belongsToMany(Problem, {
      through: {
        model: ProblemTag
      }
    });
    Submission.hasOne(SubmissionCode);
    Submission.hasOne(Solution);
    Solution.belongsTo(Submission);
    Solution.hasMany(Evaluation);
    Evaluation.belongsTo(User, {
      as: 'creator'
    });
    Evaluation.belongsTo(Solution);
    Problem.belongsToMany(User, {
      through: {
        model: Recommendation
      },
      foreignKey: 'problem_id'
    });
    User.belongsToMany(Problem, {
      as: 'recommendation',
      through: {
        model: Recommendation
      },
      foreignKey: 'user_id'
    });
    return sequelize;
  };

}).call(this);

//# sourceMappingURL=index.js.map
