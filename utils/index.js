// Generated by CoffeeScript 1.9.3
(function() {
  var AC_SCORE, CACHE_TIME, PER_PENALTY, crypto, path;

  path = require('path');

  crypto = require('crypto');

  exports.login = function(req, res, user) {
    return req.session.user = {
      id: user.id,
      nickname: user.nickname,
      username: user.username
    };
  };

  exports.logout = function(req) {
    return delete req.session.user;
  };

  exports.findGroups = function(user, include) {
    var Group;
    Group = global.db.models.group;
    return global.db.Promise.resolve().then(function() {
      if (!user) {
        return [];
      }
      return user.getGroups({
        attributes: ['id']
      });
    }).then(function(groups) {
      var group, normalGroups;
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
      return Group.findAll({
        where: {
          $or: [
            {
              access_level: ['public', 'protect']
            }, {
              id: normalGroups
            }
          ]
        },
        include: include
      });
    });
  };

  exports.findGroup = function(user, groupID, include) {
    var Group, currentUser;
    Group = global.db.models.group;
    currentUser = void 0;
    return global.db.Promise.resolve().then(function() {
      if (!user) {
        return [];
      }
      currentUser = user;
      return user.getGroups({
        attributes: ['id']
      });
    }).then(function(groups) {
      var group, normalGroups;
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
      return Group.find({
        where: {
          $and: [
            {
              id: groupID
            }, {
              $or: [
                {
                  access_level: ['public', 'protect']
                }, {
                  id: normalGroups
                }
              ]
            }
          ]
        },
        include: include
      });
    });
  };

  exports.getGroupPeopleCount = function(groups) {
    var Membership, group, options;
    if (!groups instanceof Array) {
      groups = [groups];
    }
    Membership = global.db.models.membership;
    options = {
      where: {
        group_id: (function() {
          var j, len, results1;
          results1 = [];
          for (j = 0, len = groups.length; j < len; j++) {
            group = groups[j];
            results1.push(group.id);
          }
          return results1;
        })()
      },
      group: 'group_id',
      distinct: true,
      attributes: ['group_id'],
      plain: false
    };
    return Membership.aggregate('user_id', 'count', options);
  };

  exports.addGroupsCountKey = function(counts, currentGroups, key) {
    var j, k, len, len1, p, results1, tmp;
    tmp = {};
    for (j = 0, len = counts.length; j < len; j++) {
      p = counts[j];
      tmp[p.group_id] = p.count;
    }
    results1 = [];
    for (k = 0, len1 = currentGroups.length; k < len1; k++) {
      p = currentGroups[k];
      p[key] = 0;
      if (tmp[p.id]) {
        results1.push(p[key] = tmp[p.id]);
      } else {
        results1.push(void 0);
      }
    }
    return results1;
  };

  exports.findProblems = function(user, offset, include) {
    var Problem;
    Problem = global.db.models.problem;
    return global.db.Promise.resolve().then(function() {
      if (!user) {
        return [];
      }
      return user.getGroups();
    }).then(function(groups) {
      var group, normalGroups;
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
      return Problem.findAll({
        where: {
          $or: [
            {
              access_level: 'public'
            }, {
              access_level: 'protect',
              group_id: normalGroups
            }
          ]
        },
        include: include,
        offset: offset,
        limit: global.config.pageLimit.problem
      });
    });
  };

  exports.findAndCountProblems = function(user, offset, include) {
    var Problem;
    Problem = global.db.models.problem;
    return global.db.Promise.resolve().then(function() {
      if (!user) {
        return [];
      }
      return user.getGroups();
    }).then(function(groups) {
      var group, normalGroups;
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
      return Problem.findAndCountAll({
        where: {
          $or: [
            {
              access_level: 'public'
            }, {
              access_level: 'protect',
              group_id: normalGroups
            }
          ]
        },
        include: include,
        offset: offset,
        limit: global.config.pageLimit.problem
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
      var group, normalGroups;
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
      return Problem.find({
        where: {
          $and: {
            id: problemID,
            $or: [
              {
                access_level: 'public'
              }, {
                access_level: 'protect',
                group_id: normalGroups
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
    });
  };

  exports.addProblemsCountKey = function(counts, currentProblems, key) {
    var j, k, len, len1, p, results1, tmp;
    tmp = {};
    for (j = 0, len = counts.length; j < len; j++) {
      p = counts[j];
      tmp[p.problem_id] = p.count;
    }
    results1 = [];
    for (k = 0, len1 = currentProblems.length; k < len1; k++) {
      p = currentProblems[k];
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
        return myUtils.addProblemsCountKey(counts, currentProblems, 'acceptedPeopleCount');
      }), myUtils.getResultPeopleCount(currentProblems, void 0, currentContest).then(function(counts) {
        return myUtils.addProblemsCountKey(counts, currentProblems, 'triedPeopleCount');
      }), myUtils.hasResult(currentUser, currentProblems, 'AC', currentContest).then(function(counts) {
        return myUtils.addProblemsCountKey(counts, currentProblems, 'accepted');
      }), myUtils.hasResult(currentUser, currentProblems, void 0, currentContest).then(function(counts) {
        return myUtils.addProblemsCountKey(counts, currentProblems, 'tried');
      })
    ]);
  };

  exports.getStaticProblem = function(problemId) {
    var dirname;
    dirname = global.config.problem_resource_path;
    return path.join(dirname, problemId.toString());
  };

  exports.findContests = function(user, offset, include) {
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
      var group, normalGroups;
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
      return Contest.findAll({
        where: {
          $or: [
            {
              access_level: 'public'
            }, {
              access_level: 'protect',
              group_id: normalGroups
            }
          ]
        },
        include: include,
        order: [['start_time', 'DESC'], ['id', 'DESC']],
        offset: offset,
        limit: global.config.pageLimit.contest
      });
    });
  };

  exports.findAndCountContests = function(user, offset, include) {
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
      var group, normalGroups;
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
      return Contest.findAndCountAll({
        where: {
          $or: [
            {
              access_level: 'public'
            }, {
              access_level: 'protect',
              group_id: normalGroups
            }
          ]
        },
        include: include,
        order: [['start_time', 'DESC'], ['id', 'DESC']],
        offset: offset,
        limit: global.config.pageLimit.contest
      });
    });
  };

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
      var group, normalGroups;
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
      return Contest.find({
        where: {
          $and: {
            id: contestID,
            $or: [
              {
                access_level: 'public'
              }, {
                access_level: 'protect',
                group_id: normalGroups
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

  exports.getRank = function(contest) {
    var dicProblemIDToOrder, dicProblemOrderToScore, j, len, myUtils, p, ref;
    myUtils = this;
    dicProblemIDToOrder = {};
    dicProblemOrderToScore = {};
    ref = contest.problems;
    for (j = 0, len = ref.length; j < len; j++) {
      p = ref[j];
      dicProblemIDToOrder[p.id] = myUtils.numberToLetters(p.contest_problem_list.order);
      dicProblemOrderToScore[dicProblemIDToOrder[p.id]] = p.contest_problem_list.score;
    }
    myUtils.buildRank(contest, dicProblemIDToOrder, dicProblemOrderToScore);
    return global.redis.get("rank_" + contest.id).then(function(cache) {
      var rank;
      rank = [];
      if (cache !== null) {
        rank = JSON.parse(cache);
      }
      return rank;
    });
  };

  AC_SCORE = 1;

  PER_PENALTY = 20 * 60 * 1000;

  CACHE_TIME = 1000;

  exports.buildRank = function(contest, dicProblemIDToOrder, dicProblemOrderToScore) {
    var User, getLock;
    User = global.db.models.user;
    getLock = void 0;
    return global.redis.set("rank_lock_" + contest.id, new Date(), "NX", "PX", CACHE_TIME).then(function(lock) {
      getLock = lock !== null;
      if (!getLock) {
        return [];
      }
      return contest.getSubmissions({
        include: [
          {
            model: User,
            as: 'creator'
          }
        ],
        order: [['created_at', 'ASC'], ['id', 'DESC']]
      });
    }).then(function(submissions) {
      var base, base1, base2, base3, base4, base5, base6, detail, j, len, name, p, problem, problemOrderLetter, res, sub, tmp, user;
      if (!getLock) {
        return;
      }
      tmp = {};
      for (j = 0, len = submissions.length; j < len; j++) {
        sub = submissions[j];
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
            detail[problemOrderLetter].accepted_time = sub.created_at - contest.start_time;
          }
        }
        if (detail[problemOrderLetter].score < AC_SCORE) {
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
            tmp[user].penalty += problem.accepted_time + problem.wrong_count * PER_PENALTY;
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
      res.sort(function(a, b) {
        if (a.score < b.score) {
          return 1;
        }
        if (a.score === b.score && a.penalty < b.penalty) {
          return 1;
        }
        if (a.score === b.score && a.penalty === b.penalty && a.user.id < b.user.id) {
          return 1;
        }
        return -1;
      });
      return global.redis.set("rank_" + contest.id, JSON.stringify(res));
    });
  };

  exports.createSubmissionWithCode = function(form, form_code) {
    var Submission, Submission_Code, current_submission;
    Submission = global.db.models.submission;
    Submission_Code = global.db.models.submission_code;
    current_submission = void 0;
    return global.db.transaction(function(t) {
      return Submission.create(form, {
        transaction: t
      }).then(function(submission) {
        current_submission = submission;
        return Submission_Code.create(form_code, {
          transaction: t
        });
      }).then(function(code) {
        return current_submission.setSubmission_code(code, {
          transaction: t
        });
      });
    }).then(function() {
      return current_submission;
    });
  };

  exports.findSubmissions = function(user, offset, include) {
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
        var j, len, results1;
        results1 = [];
        for (j = 0, len = problems.length; j < len; j++) {
          problem = problems[j];
          results1.push(problem.id);
        }
        return results1;
      })();
      return Submission.findAll({
        where: {
          problem_id: normalProblems,
          contest_id: null
        },
        include: include,
        order: [['created_at', 'DESC'], ['id', 'DESC']],
        offset: offset,
        limit: global.config.pageLimit.submission
      });
    });
  };

  exports.findSubmission = function(user, submissionID, include) {
    var Submission;
    Submission = global.db.models.submission;
    return Submission.find({
      where: {
        id: submissionID,
        creator_id: (user ? user.id : null)
      },
      include: include
    });
  };

  exports.checkJudge = function(opt) {
    var Judge;
    Judge = global.db.models.judge;
    return global.db.Promise.resolve().then(function() {
      return Judge.find(opt.id);
    }).then(function(judge) {
      if (!judge) {
        throw new global.myErrors.UnknownJudge();
      }
      if (opt.token !== crypto.createHash('sha1').update(judge.secret_key + '$' + opt.post_time).digest('hex')) {
        throw new global.myErrors.UnknownJudge("Wrong secret_key!");
      }
    });
  };

}).call(this);

//# sourceMappingURL=index.js.map
