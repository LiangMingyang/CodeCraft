// Generated by CoffeeScript 1.9.3
(function() {
  exports.getContest = function(req, res) {
    var Group, Problem;
    Group = global.db.models.group;
    Problem = global.db.models.problem;
    return global.db.Promise.resolve().then(function() {
      return global.myUtils.findContest(req.session.user, req.params.contestId, [
        {
          model: Group
        }, {
          model: Problem
        }
      ]);
    }).then(function(contest) {
      if (!contest) {
        throw new global.myErrors.UnknownContest();
      }
      return res.json(contest.get({
        plain: true
      }));
    })["catch"](function(err) {
      res.status(err.status || 400);
      return res.json({
        error: err.message
      });
    });
  };

  exports.getRank = function(req, res) {
    var Problem;
    Problem = global.db.models.problem;
    return global.db.Promise.resolve().then(function() {
      return global.myUtils.findContest(req.session.user, req.params.contestId, [
        {
          model: Problem,
          attributes: ['id']
        }
      ]);
    }).then(function(contest) {
      if (!contest) {
        throw new global.myErrors.UnknownContest();
      }
      if (contest.start_time > (new Date())) {
        throw new global.myErrors.UnknownContest();
      }
      contest.problems.sort(function(a, b) {
        return a.contest_problem_list.order - b.contest_problem_list.order;
      });
      return global.myUtils.getRank(contest);
    }).then(function(rank) {
      return res.json(rank);
    })["catch"](function(err) {
      res.status(err.status || 400);
      return res.json({
        error: err.message
      });
    });
  };

  exports.getSubmissions = function(req, res) {
    var Submission;
    Submission = global.db.models.submission;
    return global.db.Promise.resolve().then(function() {
      if (!req.session.user) {
        return [];
      }
      return Submission.findAll({
        where: {
          creator_id: req.session.user.id,
          contest_id: req.params.contestId
        },
        order: [['created_at', 'DESC'], ['id', 'DESC']]
      });
    }).then(function(submissions) {
      var submission;
      return res.json((function() {
        var i, len, results;
        results = [];
        for (i = 0, len = submissions.length; i < len; i++) {
          submission = submissions[i];
          results.push(submission.get({
            plain: true
          }));
        }
        return results;
      })());
    })["catch"](function(err) {
      res.status(err.status);
      return res.json({
        error: err.message
      });
    });
  };

  exports.postSubmissions = function(req, res) {
    var Problem, User, currentContest, currentProblem, currentSubmission, currentUser;
    User = global.db.models.user;
    Problem = global.db.models.problem;
    currentUser = void 0;
    currentProblem = void 0;
    currentContest = void 0;
    currentSubmission = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      if (!user) {
        throw new global.myErrors.UnknownUser();
      }
      return global.myUtils.findContest(user, req.params.contestId, [
        {
          model: Problem
        }
      ]);
    }).then(function(contest) {
      var form, form_code, problem;
      if (!contest) {
        throw new global.myErrors.UnknownContest();
      }
      if ((new Date()) < contest.start_time || contest.end_time < (new Date())) {
        throw new global.myErrors.InvalidAccess();
      }
      contest.problems.sort(function(a, b) {
        return a.contest_problem_list.order - b.contest_problem_list.order;
      });
      currentContest = contest;
      problem = currentContest.problems[req.body.order];
      if (!problem) {
        throw new global.myErrors.UnknownProblem();
      }
      currentProblem = problem;
      form = {
        lang: req.body.lang,
        code_length: req.body.code.length
      };
      form_code = {
        content: req.body.code
      };
      return global.myUtils.createSubmissionTransaction(form, form_code, currentProblem, currentUser);
    }).then(function(submission) {
      if (submission) {
        currentSubmission = submission.get({
          plain: true
        });
      }
      console.log(currentContest);
      return currentContest.addSubmission(submission);
    }).then(function() {
      return res.json(currentSubmission);
    })["catch"](function(err) {
      res.status(err.status || 400);
      return res.json({
        error: err.message
      });
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
