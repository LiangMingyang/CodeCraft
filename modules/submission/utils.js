// Generated by CoffeeScript 1.9.3
(function() {
  var UnknownSubmission, UnknownUser, path,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  path = require('path');

  UnknownUser = (function(superClass) {
    extend(UnknownUser, superClass);

    function UnknownUser(message) {
      this.message = message != null ? message : "Please Login";
      this.name = 'UnknownUser';
      Error.captureStackTrace(this, UnknownUser);
    }

    return UnknownUser;

  })(Error);

  UnknownSubmission = (function(superClass) {
    extend(UnknownSubmission, superClass);

    function UnknownSubmission(message) {
      this.message = message != null ? message : "Unknown submission.";
      this.name = 'UnknownSubmission';
      Error.captureStackTrace(this, UnknownSubmission);
    }

    return UnknownSubmission;

  })(Error);

  exports.Error = {
    UnknownUser: UnknownUser,
    UnknownSubmission: UnknownSubmission
  };

  exports.findProblems = function(user, include) {
    var Problem;
    Problem = global.db.models.problem;
    return global.db.Promise.resolve().then(function() {
      if (!user) {
        return [];
      }
      return user.getGroups();
    }).then(function(groups) {
      var adminGroups, group, normalGroups;
      normalGroups = (function() {
        var i, len, results;
        results = [];
        for (i = 0, len = groups.length; i < len; i++) {
          group = groups[i];
          if (group.membership.access_level !== 'verifying') {
            results.push(group.id);
          }
        }
        return results;
      })();
      adminGroups = (function() {
        var i, len, ref, results;
        results = [];
        for (i = 0, len = groups.length; i < len; i++) {
          group = groups[i];
          if ((ref = group.membership.access_level) === 'owner' || ref === 'admin') {
            results.push(group.id);
          }
        }
        return results;
      })();
      return Problem.findAll({
        where: {
          $or: [
            user ? {
              creator_id: user.id
            } : void 0, {
              access_level: 'public'
            }, {
              access_level: 'protect',
              group_id: normalGroups
            }, {
              access_level: 'private',
              group_id: adminGroups
            }
          ]
        },
        include: include
      });
    });
  };

  exports.findSubmissions = function(user, include) {
    var Submission, myUtils, normalProblems;
    Submission = global.db.models.submission;
    normalProblems = void 0;
    myUtils = this;
    return global.db.Promise.resolve().then(function() {
      return myUtils.findProblems(user);
    }).then(function(problems) {
      var problem;
      if (!problems) {
        return [];
      }
      normalProblems = (function() {
        var i, len, results;
        results = [];
        for (i = 0, len = problems.length; i < len; i++) {
          problem = problems[i];
          results.push(problem.id);
        }
        return results;
      })();
      return Submission.findAll({
        where: {
          problem_id: normalProblems,
          contest_id: null
        },
        include: include,
        order: [['created_at', 'DESC']]
      });
    });
  };

  exports.findSubmission = function(user, submissionID, include) {
    var Contest, Problem, Submission, adminContestIDs, adminGroupIDs, adminProblemIDs;
    Submission = global.db.models.submission;
    Contest = global.db.models.contest;
    Problem = global.db.models.problem;
    adminContestIDs = void 0;
    adminProblemIDs = void 0;
    adminGroupIDs = void 0;
    return global.db.Promise.resolve().then(function() {
      if (user) {
        return user.getGroups();
      }
    }).then(function(groups) {
      var group;
      if (!groups) {
        return [];
      }
      adminGroupIDs = (function() {
        var i, len, ref, results;
        results = [];
        for (i = 0, len = groups.length; i < len; i++) {
          group = groups[i];
          if ((ref = group.membership.access_level) === 'owner' || ref === 'admin') {
            results.push(group.id);
          }
        }
        return results;
      })();
      return Contest.findAll({
        where: {
          group_id: adminGroupIDs
        }
      });
    }).then(function(contests) {
      var contest;
      if (!contests) {
        return [];
      }
      adminContestIDs = (function() {
        var i, len, results;
        results = [];
        for (i = 0, len = contests.length; i < len; i++) {
          contest = contests[i];
          results.push(contest.id);
        }
        return results;
      })();
      return Problem.findAll({
        where: {
          group_id: adminGroupIDs
        }
      });
    }).then(function(problems) {
      var problem;
      if (!problems) {
        return void 0;
      }
      adminProblemIDs = (function() {
        var i, len, results;
        results = [];
        for (i = 0, len = problems.length; i < len; i++) {
          problem = problems[i];
          results.push(problem.id);
        }
        return results;
      })();
      return Submission.find({
        where: {
          id: submissionID,
          $or: [
            {
              creator_id: (user ? user.id : null)
            }, {
              problem_id: adminProblemIDs
            }, {
              contest_id: adminGroupIDs
            }
          ]
        },
        include: include
      });
    });
  };

}).call(this);

//# sourceMappingURL=utils.js.map
