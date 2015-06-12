// Generated by CoffeeScript 1.9.3
(function() {
  var InvalidAccess, InvalidFile, UnknownProblem, UnknownUser, path,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  path = require('path');

  UnknownProblem = (function(superClass) {
    extend(UnknownProblem, superClass);

    function UnknownProblem(message) {
      this.message = message != null ? message : "Unknown problem";
      this.name = 'UnknownProblem';
      Error.captureStackTrace(this, UnknownProblem);
    }

    return UnknownProblem;

  })(Error);

  InvalidAccess = (function(superClass) {
    extend(InvalidAccess, superClass);

    function InvalidAccess(message) {
      this.message = message != null ? message : "Invalid Access, please return";
      this.name = 'InvalidAccess';
      Error.captureStackTrace(this, InvalidAccess);
    }

    return InvalidAccess;

  })(Error);

  UnknownUser = (function(superClass) {
    extend(UnknownUser, superClass);

    function UnknownUser(message) {
      this.message = message != null ? message : "Unknown user, please login first";
      this.name = 'UnknownUser';
      Error.captureStackTrace(this, UnknownUser);
    }

    return UnknownUser;

  })(Error);

  InvalidFile = (function(superClass) {
    extend(InvalidFile, superClass);

    function InvalidFile(message) {
      this.message = message != null ? message : "File not exist!";
      this.name = 'InvalidFile';
      Error.captureStackTrace(this, InvalidFile);
    }

    return InvalidFile;

  })(Error);

  exports.getStaticProblem = function(problemId) {
    var dirname;
    dirname = global.config.problem_resource_path;
    return path.join(dirname, problemId.toString());
  };

  exports.Error = {
    UnknownUser: UnknownUser,
    InvalidAccess: InvalidAccess,
    UnknownProblem: UnknownProblem,
    InvalidFile: InvalidFile
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
        var i, len, results1;
        results1 = [];
        for (i = 0, len = groups.length; i < len; i++) {
          group = groups[i];
          if (group.membership.access_level !== 'verifying') {
            results1.push(group.id);
          }
        }
        return results1;
      })();
      adminGroups = (function() {
        var i, len, ref, results1;
        results1 = [];
        for (i = 0, len = groups.length; i < len; i++) {
          group = groups[i];
          if ((ref = group.membership.access_level) === 'owner' || ref === 'admin') {
            results1.push(group.id);
          }
        }
        return results1;
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

  exports.findProblem = function(user, problemID, include) {
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
        var i, len, results1;
        results1 = [];
        for (i = 0, len = groups.length; i < len; i++) {
          group = groups[i];
          if (group.membership.access_level !== 'verifying') {
            results1.push(group.id);
          }
        }
        return results1;
      })();
      adminGroups = (function() {
        var i, len, ref, results1;
        results1 = [];
        for (i = 0, len = groups.length; i < len; i++) {
          group = groups[i];
          if ((ref = group.membership.access_level) === 'owner' || ref === 'admin') {
            results1.push(group.id);
          }
        }
        return results1;
      })();
      return Problem.find({
        where: {
          $and: {
            id: problemID,
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
          }
        },
        include: include
      });
    });
  };

  exports.getResultPeopleCount = function(problems, results, contest) {
    var Submission, options, problem;
    if (!problems instanceof Array) {
      problems = [problems];
    }
    Submission = global.db.models.submission;
    options = {
      where: {
        problem_id: (function() {
          var i, len, results1;
          results1 = [];
          for (i = 0, len = problems.length; i < len; i++) {
            problem = problems[i];
            results1.push(problem.id);
          }
          return results1;
        })()
      },
      group: 'problem_id',
      distinct: true,
      attributes: ['problem_id'],
      plain: false
    };
    if (results) {
      options.where.result = results;
    }
    if (contest) {
      options.where.contest_id = contest.id;
    }
    return Submission.aggregate('creator_id', 'count', options);
  };

  exports.hasResult = function(user, problems, results, contest) {
    return global.db.Promise.resolve().then(function() {
      var Submission, options, problem;
      if (!user) {
        return [];
      }
      if (!problems instanceof Array) {
        problems = [problems];
      }
      Submission = global.db.models.submission;
      options = {
        where: {
          problem_id: (function() {
            var i, len, results1;
            results1 = [];
            for (i = 0, len = problems.length; i < len; i++) {
              problem = problems[i];
              results1.push(problem.id);
            }
            return results1;
          })(),
          creator_id: user.id
        },
        group: 'problem_id',
        distinct: true,
        attributes: ['problem_id'],
        plain: false
      };
      if (results) {
        options.where.result = results;
      }
      if (contest) {
        options.where.contest_id = contest.id;
      }
      return Submission.aggregate('creator_id', 'count', options);
    });
  };

  exports.addCountKey = function(counts, currentProblems, key) {
    var i, j, len, len1, p, results1, tmp;
    tmp = {};
    for (i = 0, len = counts.length; i < len; i++) {
      p = counts[i];
      tmp[p.problem_id] = p.count;
    }
    results1 = [];
    for (j = 0, len1 = currentProblems.length; j < len1; j++) {
      p = currentProblems[j];
      p[key] = 0;
      if (tmp[p.id]) {
        results1.push(p[key] = tmp[p.id]);
      } else {
        results1.push(void 0);
      }
    }
    return results1;
  };

  exports.getProblemsStatus = function(currentProblems, currentUser, currentContest) {
    var myUtils;
    myUtils = this;
    return global.db.Promise.all([
      myUtils.getResultPeopleCount(currentProblems, 'AC', currentContest).then(function(counts) {
        return myUtils.addCountKey(counts, currentProblems, 'acceptedPeopleCount');
      }), myUtils.getResultPeopleCount(currentProblems, void 0, currentContest).then(function(counts) {
        return myUtils.addCountKey(counts, currentProblems, 'triedPeopleCount');
      }), myUtils.hasResult(currentUser, currentProblems, 'AC', currentContest).then(function(counts) {
        return myUtils.addCountKey(counts, currentProblems, 'accepted');
      }), myUtils.hasResult(currentUser, currentProblems, void 0, currentContest).then(function(counts) {
        return myUtils.addCountKey(counts, currentProblems, 'tried');
      })
    ]);
  };

}).call(this);

//# sourceMappingURL=utils.js.map
