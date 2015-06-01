// Generated by CoffeeScript 1.9.2
(function() {
  var CONTEST_PAGE, HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, myUtils, passwordHash;

  passwordHash = require('password-hash');

  myUtils = require('./utils');

  HOME_PAGE = '/';

  CONTEST_PAGE = '..';

  INDEX_PAGE = 'index';

  LOGIN_PAGE = '/user/login';

  exports.getIndex = function(req, res) {
    var Contest, Problem, User, currentContest;
    Contest = global.db.models.contest;
    User = global.db.models.user;
    Problem = global.db.models.problem;
    currentContest = void 0;
    return myUtils.findContest(req, req.params.contestID).then(function(contest) {
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      currentContest = contest;
      return currentContest.getProblems();
    }).then(function(problems) {
      return res.render('contest/detail', {
        user: req.session.user,
        contest: currentContest,
        problems: problems
      });
    })["catch"](myUtils.Error.UnknownContest, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getSubmission = function(req, res) {
    var Contest, Group, User, currentContest;
    Group = global.db.models.group;
    Contest = global.db.models.contest;
    User = global.db.models.user;
    currentContest = void 0;
    return myUtils.findContest(req, req.params.contestID).then(function(contest) {
      if (!contest) {
        throw new myUtils.Error.UnknownContest();
      }
      currentContest = contest;
      return currentContest.getSubmissions();
    }).then(function(submissions) {
      return res.render('contest/submission', {
        user: req.session.user,
        contest: currentContest,
        submissions: submissions
      });
    })["catch"](myUtils.Error.UnknownContest, function(err) {
      req.flash('info', err.message);
      return res.redirect(CONTEST_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getClarification = function(req, res) {
    return res.render('contest/detail', {
      title: 'Clarification'
    });
  };

  exports.getQuestion = function(req, res) {
    return res.render('contest/detail', {
      title: 'Question'
    });
  };

  exports.getRank = function(req, res) {
    return res.render('contest/detail', {
      title: 'Rank'
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
