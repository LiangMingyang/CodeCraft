// Generated by CoffeeScript 1.9.3
(function() {
  var CACHE_TIME, PER_PENALTY, crypto, path;

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

  exports.findGroupsID = function(user) {
    var Membership;
    Membership = global.db.models.membership;
    return global.db.Promise.resolve().then(function() {
      if (!user) {
        return [];
      }
      return Membership.findAll({
        where: {
          user_id: user.id,
          access_level: ['member', 'admin', 'owner']
        },
        attributes: ['group_id']
      });
    }).then(function(memberships) {
      var membership;
      return (function() {
        var j, len, results1;
        results1 = [];
        for (j = 0, len = memberships.length; j < len; j++) {
          membership = memberships[j];
          results1.push(membership.group_id);
        }
        return results1;
      })();
    });
  };

  exports.findGroups = function(user, include) {
    var Group, myUtils;
    Group = global.db.models.group;
    myUtils = this;
    return myUtils.findGroupsID(user).then(function(normalGroups) {
      return Group.findAll({
        where: {
          $or: [
            {
              $and: [
                {
                  access_level: ['protect']
                }, {
                  id: normalGroups
                }
              ]
            }, {
              access_level: ['public']
            }
          ]
        },
        include: include
      });
    });
  };

  exports.findGroup = function(user, groupID, include) {
    var Group, myUtils;
    Group = global.db.models.group;
    myUtils = this;
    return myUtils.findGroupsID(user).then(function(normalGroups) {
      return Group.find({
        where: {
          $and: [
            {
              id: groupID
            }, {
              $or: [
                {
                  $and: [
                    {
                      access_level: ['protect']
                    }, {
                      id: normalGroups
                    }
                  ]
                }, {
                  access_level: ['public']
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
    if (!(groups instanceof Array)) {
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
        })(),
        access_level: ['member', 'admin', 'owner']
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

  exports.findProblemsID = function(normalGroups) {
    var Problem;
    if (normalGroups == null) {
      normalGroups = [];
    }
    Problem = global.db.models.problem;
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
      attributes: ['id']
    }).then(function(problems) {
      var problem;
      return (function() {
        var j, len, results1;
        results1 = [];
        for (j = 0, len = problems.length; j < len; j++) {
          problem = problems[j];
          results1.push(problem.id);
        }
        return results1;
      })();
    });
  };

  exports.findProblems = function(user, include) {
    var Problem, myUtils;
    Problem = global.db.models.problem;
    myUtils = this;
    return myUtils.findGroupsID(user).then(function(normalGroups) {
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
        include: include
      });
    });
  };

  exports.findAndCountProblems = function(user, offset, include) {
    var Problem, myUtils;
    Problem = global.db.models.problem;
    myUtils = this;
    return myUtils.findGroupsID(user).then(function(normalGroups) {
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
    var Membership, Problem, currentProblem;
    Problem = global.db.models.problem;
    Membership = global.db.models.membership;
    currentProblem = void 0;
    return global.db.Promise.resolve().then(function() {
      return Problem.find({
        where: {
          id: problemID
        },
        include: include
      });
    }).then(function(problem) {
      currentProblem = problem;
      if (!problem) {
        return true;
      }
      if (problem.access_level === 'public') {
        return true;
      }
      if (!user) {
        return false;
      }
      return Membership.find({
        where: {
          group_id: currentProblem.group_id,
          user_id: user.id,
          access_level: ['member', 'admin', 'owner']
        }
      });
    }).then(function(flag) {
      if (flag) {
        return currentProblem;
      }
    });
  };

  exports.getResultPeopleCount = function(problems_id, results, contest) {
    var Submission, options;
    Submission = global.db.models.submission;
    options = {
      where: {
        problem_id: problems_id
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

  exports.getResultCount = function(problems_id, results, contest) {
    var Submission, options;
    Submission = global.db.models.submission;
    options = {
      where: {
        problem_id: problems_id
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
    return Submission.aggregate('id', 'count', options);
  };

  exports.hasResult = function(user, problems_id, results, contest) {
    return global.db.Promise.resolve().then(function() {
      var Submission, options;
      if (!user) {
        return [];
      }
      Submission = global.db.models.submission;
      options = {
        where: {
          problem_id: problems_id,
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
    var myUtils, problem, problems_id;
    myUtils = this;
    if (!(currentProblems instanceof Array)) {
      currentProblems = [currentProblems];
    }
    problems_id = (function() {
      var j, len, results1;
      results1 = [];
      for (j = 0, len = currentProblems.length; j < len; j++) {
        problem = currentProblems[j];
        results1.push(problem.id);
      }
      return results1;
    })();
    return global.db.Promise.all([
      myUtils.getResultPeopleCount(problems_id, 'AC', currentContest).then(function(counts) {
        return myUtils.addProblemsCountKey(counts, currentProblems, 'acceptedPeopleCount');
      }), myUtils.getResultPeopleCount(problems_id, void 0, currentContest).then(function(counts) {
        return myUtils.addProblemsCountKey(counts, currentProblems, 'triedPeopleCount');
      }), myUtils.hasResult(currentUser, problems_id, 'AC', currentContest).then(function(counts) {
        return myUtils.addProblemsCountKey(counts, currentProblems, 'accepted');
      }), myUtils.hasResult(currentUser, problems_id, void 0, currentContest).then(function(counts) {
        return myUtils.addProblemsCountKey(counts, currentProblems, 'tried');
      }), myUtils.getResultCount(problems_id, void 0, currentContest).then(function(counts) {
        return myUtils.addProblemsCountKey(counts, currentProblems, 'submissionCount');
      })
    ]);
  };

  exports.getStaticProblem = function(problemId) {
    var dirname;
    dirname = global.config.problem_resource_path;
    return path.join(dirname, problemId.toString());
  };

  exports.findContestsID = function(normalGroups) {
    var Contest;
    if (normalGroups == null) {
      normalGroups = [];
    }
    Contest = global.db.models.contest;
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
      attributes: ['id']
    }).then(function(contests) {
      var contest;
      return (function() {
        var j, len, results1;
        results1 = [];
        for (j = 0, len = contests.length; j < len; j++) {
          contest = contests[j];
          results1.push(contest.id);
        }
        return results1;
      })();
    });
  };

  exports.findContests = function(user, include) {
    var Contest, myUtils;
    Contest = global.db.models.contest;
    myUtils = this;
    return myUtils.findGroupsID(user).then(function(normalGroups) {
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
        order: [['start_time', 'DESC'], ['id', 'DESC']]
      });
    });
  };

  exports.findAndCountContests = function(user, offset, include) {
    var Contest, myUtils;
    Contest = global.db.models.contest;
    myUtils = this;
    return myUtils.findGroupsID(user).then(function(normalGroups) {
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
    var Contest, Membership, currentContest;
    Contest = global.db.models.contest;
    Membership = global.db.models.membership;
    currentContest = void 0;
    return global.db.Promise.resolve().then(function() {
      return Contest.find({
        where: {
          id: contestID
        },
        include: include
      });
    }).then(function(contest) {
      currentContest = contest;
      if (!contest) {
        return true;
      }
      if (contest.access_level === 'public') {
        return true;
      }
      if (!user) {
        return false;
      }
      return Membership.find({
        where: {
          group_id: contest.group_id,
          user_id: user.id,
          access_level: ['member', 'admin', 'owner']
        }
      });
    }).then(function(flag) {
      if (flag) {
        return currentContest;
      }
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
    var dicProblemIDToOrder, dicProblemOrderToScore, i, j, len, myUtils, p, ref;
    myUtils = this;
    dicProblemIDToOrder = {};
    dicProblemOrderToScore = {};
    ref = contest.problems;
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      p = ref[i];
      dicProblemIDToOrder[p.id] = myUtils.numberToLetters(i);
      dicProblemOrderToScore[dicProblemIDToOrder[p.id]] = p.contest_problem_list.score;
    }
    myUtils.buildRank(contest, dicProblemIDToOrder, dicProblemOrderToScore);
    return global.redis.get("rank_" + contest.id).then(function(cache) {
      var rank;
      rank = "[]";
      if (cache !== null) {
        rank = cache;
      }
      return rank;
    });
  };

  PER_PENALTY = global.config.judge.penalty;

  CACHE_TIME = global.config.judge.cache;

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
            as: 'creator',
            attributes: ['id', 'nickname', 'student_id']
          }
        ],
        order: [['created_at', 'ASC'], ['id', 'DESC']]
      });
    }).then(function(submissions) {
      var base, base1, base2, base3, base4, base5, detail, firstB, j, len, name, p, problem, problemOrderLetter, res, sub, tmp, user;
      if (!getLock) {
        return;
      }
      tmp = {};
      firstB = {};
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
        if ((base3 = detail[problemOrderLetter]).wrong_count == null) {
          base3.wrong_count = 0;
        }
        if (sub.result === 'AC') {
          if (firstB[problemOrderLetter] == null) {
            firstB[problemOrderLetter] = sub.created_at - contest.start_time;
          }
          if (sub.created_at - contest.start_time < firstB[problemOrderLetter]) {
            firstB[problemOrderLetter] = sub.created_at - contest.start_time;
          }
        }
        if (sub.score > detail[problemOrderLetter].score) {
          detail[problemOrderLetter].score = sub.score;
          if (detail[problemOrderLetter].result !== 'AC') {
            detail[problemOrderLetter].result = sub.result;
          }
          detail[problemOrderLetter].accepted_time = sub.created_at - contest.start_time;
        }
        if (detail[problemOrderLetter].result !== 'AC') {
          ++detail[problemOrderLetter].wrong_count;
        }
      }
      for (user in tmp) {
        if ((base4 = tmp[user]).score == null) {
          base4.score = 0;
        }
        if ((base5 = tmp[user]).penalty == null) {
          base5.penalty = 0;
        }
        for (p in tmp[user].detail) {
          problem = tmp[user].detail[p];
          problem.score *= dicProblemOrderToScore[p];
          tmp[user].score += problem.score;
          if (problem.result === 'AC' && problem.accepted_time === firstB[p]) {
            problem.first_blood = true;
          }
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
        if (a.score === b.score && a.penalty > b.penalty) {
          return 1;
        }
        if (a.score === b.score && a.penalty === b.penalty && a.user.id > b.user.id) {
          return 1;
        }
        return -1;
      });
      return global.redis.set("rank_" + contest.id, JSON.stringify(res));
    });
  };

  exports.createSubmissionTransaction = function(form, form_code, problem, user) {
    var Submission, Submission_Code, current_submission;
    if (form_code.content.length > global.config.judge.max_code_length) {
      throw new global.myErrors.UnknownProblem("Your code is too long.");
    }
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
        return global.db.Promise.all([
          current_submission.setSubmission_code(code, {
            transaction: t
          }), user.addSubmission(current_submission, {
            transaction: t
          }), problem.addSubmission(current_submission, {
            transaction: t
          })
        ]);
      });
    }).then(function() {
      return current_submission;
    });
  };

  exports.findSubmissions = function(user, opt, include) {
    var Submission, myUtils, normalGroups, normalProblems;
    Submission = global.db.models.submission;
    normalGroups = void 0;
    normalProblems = void 0;
    myUtils = this;
    return global.db.Promise.resolve().then(function() {
      return myUtils.findGroupsID(user);
    }).then(function(groups) {
      normalGroups = groups;
      return myUtils.findProblemsID(normalGroups);
    }).then(function(problems) {
      normalProblems = problems;
      return myUtils.findContestsID(normalGroups);
    }).then(function(normalContests) {
      var where;
      where = {
        $and: [
          {
            $or: [
              {
                problem_id: normalProblems
              }, {
                contest_id: normalContests
              }
            ]
          }
        ]
      };
      if (opt.problem_id !== void 0) {
        where.$and.push({
          problem_id: opt.problem_id
        });
      }
      if (opt.contest_id !== void 0) {
        where.$and.push({
          contest_id: opt.contest_id
        });
        if (opt.contest_id !== null) {
          if (user) {
            where.$and.push({
              creator_id: user.id
            });
          } else {
            where.$and.push({
              creator_id: null
            });
          }
        }
      }
      if (opt.language !== void 0) {
        where.$and.push({
          lang: opt.language
        });
      }
      if (opt.result !== void 0) {
        where.$and.push({
          result: opt.result
        });
      }
      if (opt.nickname !== void 0) {
        (function(include) {
          var j, len, model;
          if (include == null) {
            include = {};
          }
          for (j = 0, len = include.length; j < len; j++) {
            model = include[j];
            if (model.as === 'creator') {
              if (model.where == null) {
                model.where = {};
              }
              model.where.nickname = opt.nickname;
              return;
            }
          }
          return include.push({
            model: User,
            as: 'creator',
            where: {
              nickname: opt.nickname
            }
          });
        })(include);
      }
      if (opt.offset == null) {
        opt.offset = 0;
      }
      return Submission.findAll({
        where: where,
        include: include,
        order: [['created_at', 'DESC'], ['id', 'DESC']],
        offset: opt.offset,
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

  exports.findSubmissionsInIDs = function(user, submission_id, include) {
    var Submission, myUtils, normalGroups, normalProblems;
    Submission = global.db.models.submission;
    normalGroups = void 0;
    normalProblems = void 0;
    myUtils = this;
    return global.db.Promise.resolve().then(function() {
      return myUtils.findGroupsID(user);
    }).then(function(groups) {
      normalGroups = groups;
      return myUtils.findProblemsID(normalGroups);
    }).then(function(problems) {
      normalProblems = problems;
      return myUtils.findContestsID(normalGroups);
    }).then(function(normalContests) {
      return Submission.findAll({
        where: {
          id: submission_id,
          $or: [
            {
              problem_id: normalProblems
            }, {
              contest_id: normalContests
            }
          ]
        },
        include: include
      });
    }).then(function(submissions) {
      var sub;
      return (function() {
        var j, len, results1;
        results1 = [];
        for (j = 0, len = submissions.length; j < len; j++) {
          sub = submissions[j];
          results1.push(sub.get({
            plain: true
          }));
        }
        return results1;
      })();
    });
  };

}).call(this);

//# sourceMappingURL=index.js.map
