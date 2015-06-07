// Generated by CoffeeScript 1.9.3
(function() {
  var AC_SCORE, InvalidAccess, LoginError, PER_PENALTY, RegisterError, UnknownContest, UnknownUser, UpdateError,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  UnknownUser = (function(superClass) {
    extend(UnknownUser, superClass);

    function UnknownUser(message) {
      this.message = message != null ? message : "Unknown user.";
      this.name = 'UnknownUser';
      Error.captureStackTrace(this, UnknownUser);
    }

    return UnknownUser;

  })(Error);

  LoginError = (function(superClass) {
    extend(LoginError, superClass);

    function LoginError(message) {
      this.message = message != null ? message : "Wrong password or username.";
      this.name = 'LoginError';
      Error.captureStackTrace(this, LoginError);
    }

    return LoginError;

  })(Error);

  RegisterError = (function(superClass) {
    extend(RegisterError, superClass);

    function RegisterError(message) {
      this.message = message != null ? message : "Unvalidated register message.";
      this.name = 'LoginError';
      Error.captureStackTrace(this, LoginError);
    }

    return RegisterError;

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

  UpdateError = (function(superClass) {
    extend(UpdateError, superClass);

    function UpdateError(message) {
      this.message = message != null ? message : "Unvalidated update message.";
      this.name = 'UpdateError';
      Error.captureStackTrace(this, UpdateError);
    }

    return UpdateError;

  })(Error);

  UnknownContest = (function(superClass) {
    extend(UnknownContest, superClass);

    function UnknownContest(message) {
      this.message = message != null ? message : "Unknown contest.";
      this.name = 'UnknownContest';
      Error.captureStackTrace(this, UnknownContest);
    }

    return UnknownContest;

  })(Error);

  exports.Error = {
    UnknownUser: UnknownUser,
    LoginError: LoginError,
    RegisterError: RegisterError,
    InvalidAccess: InvalidAccess,
    UpdateError: UpdateError,
    UnknownContest: UnknownContest
  };

  AC_SCORE = 1;

  PER_PENALTY = 20 * 60 * 1000;

  exports.findContest = function(user, contestID, include) {
    var Contest;
    Contest = global.db.models.contest;
    return global.db.Promise.resolve().then(function() {
      if (!user) {
        return [];
      }
      return user.getGroups({
        attributes: ['id']
      });
    }).then(function(groups) {
      var adminGroups, group, normalGroups;
      normalGroups = (function() {
        var j, len, results1;
        results1 = [];
        for (j = 0, len = groups.length; j < len; j++) {
          group = groups[j];
          if (group.membership.access_level !== 'verifying') {
            results1.push(group.id);
          }
        }
        return results1;
      })();
      adminGroups = (function() {
        var j, len, ref, results1;
        results1 = [];
        for (j = 0, len = groups.length; j < len; j++) {
          group = groups[j];
          if ((ref = group.membership.access_level) === 'owner' || ref === 'admin') {
            results1.push(group.id);
          }
        }
        return results1;
      })();
      return Contest.find({
        where: {
          $and: {
            id: contestID,
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

  exports.lettersToNumber = function(word) {
    var i, j, len, res;
    res = 0;
    for (j = 0, len = word.length; j < len; j++) {
      i = word[j];
      res = res * 26 + (i.charCodeAt(0) - 65);
    }
    return res;
  };

  exports.numberToLetters = function(num) {
    var res;
    if (num === 0) {
      return 'A';
    }
    res = "";
    while (num > 0) {
      res = String.fromCharCode(num % 26 + 65) + res;
      num = parseInt(num / 26);
    }
    return res;
  };

  exports.hasResult = function(user, problems, results, contest) {
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
          var j, len, results1;
          results1 = [];
          for (j = 0, len = problems.length; j < len; j++) {
            problem = problems[j];
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
          var j, len, results1;
          results1 = [];
          for (j = 0, len = problems.length; j < len; j++) {
            problem = problems[j];
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

  exports.getRank = function(contest) {
    var User, myUtils;
    myUtils = this;
    User = global.db.models.user;
    return contest.getSubmissions({
      include: [
        {
          model: User,
          as: 'creator'
        }
      ],
      order: [['created_at', 'ASC']]
    }).then(function(submissions) {
      var base, base1, base2, base3, base4, base5, base6, detail, dicProblemIDToOrder, dicProblemOrderToScore, j, k, len, len1, name, p, problem, problemOrderLetter, ref, res, sub, tmp, user;
      dicProblemIDToOrder = {};
      dicProblemOrderToScore = {};
      ref = contest.problems;
      for (j = 0, len = ref.length; j < len; j++) {
        p = ref[j];
        dicProblemIDToOrder[p.id] = myUtils.numberToLetters(p.contest_problem_list.order);
        dicProblemOrderToScore[dicProblemIDToOrder[p.id]] = p.contest_problem_list.score;
      }
      tmp = {};
      for (k = 0, len1 = submissions.length; k < len1; k++) {
        sub = submissions[k];
        if (tmp[name = sub.creator.id] == null) {
          tmp[name] = {};
        }
        if ((base = tmp[sub.creator.id]).user == null) {
          base.user = sub.creator;
        }
        if ((base1 = tmp[sub.creator.id]).detail == null) {
          base1.detail = {};
        }
        problemOrderLetter = dicProblemIDToOrder[sub.problem_id];
        detail = tmp[sub.creator.id].detail;
        if (detail[problemOrderLetter] == null) {
          detail[problemOrderLetter] = {};
        }
        if ((base2 = detail[problemOrderLetter]).score == null) {
          base2.score = 0;
        }
        if ((base3 = detail[problemOrderLetter]).accepted_time == null) {
          base3.accepted_time = new Date();
        }
        if ((base4 = detail[problemOrderLetter]).wrong_count == null) {
          base4.wrong_count = 0;
        }
        if (sub.score >= detail[problemOrderLetter].score) {
          detail[problemOrderLetter].score = sub.score;
          detail[problemOrderLetter].result = sub.result;
          if (sub.created_at < detail[problemOrderLetter].accepted_time) {
            detail[problemOrderLetter].accepted_time = sub.created_at;
          }
        }
        if (sub.score < AC_SCORE) {
          ++detail[problemOrderLetter].wrong_count;
        }
      }
      for (user in tmp) {
        if ((base5 = tmp[user]).score == null) {
          base5.score = 0;
        }
        if ((base6 = tmp[user]).penalty == null) {
          base6.penalty = 0;
        }
        for (p in tmp[user].detail) {
          problem = tmp[user].detail[p];
          problem.score *= dicProblemOrderToScore[p];
          tmp[user].score += problem.score;
          if (problem.score > 0) {
            tmp[user].penalty += (problem.accepted_time - contest.start_time) + problem.wrong_count * PER_PENALTY;
          }
        }
      }
      res = (function() {
        var results1;
        results1 = [];
        for (user in tmp) {
          results1.push(tmp[user]);
        }
        return results1;
      })();
      return res.sort(function(a, b) {
        if (a.score < b.score) {
          return -1;
        }
        if (a.score === b.score && a.penalty < b.penalty) {
          return -1;
        }
        if (a.score === b.score && a.penalty === b.penalty && a.user.id < b.user.id) {
          return -1;
        }
        return 1;
      });
    });
  };

}).call(this);

//# sourceMappingURL=utils.js.map
