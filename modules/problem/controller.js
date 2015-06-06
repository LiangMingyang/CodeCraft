// Generated by CoffeeScript 1.9.3
(function() {
  var HOME_PAGE, INDEX_PAGE, myUtils, passwordHash;

  passwordHash = require('password-hash');

  myUtils = require('./utils');

  HOME_PAGE = '/';

  INDEX_PAGE = '.';

  exports.getIndex = function(req, res) {
    var Group, User, currentProblems, currentUser;
    Group = global.db.models.group;
    User = global.db.models.user;
    currentProblems = void 0;
    currentUser = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      return myUtils.findProblems(user, [
        {
          model: Group
        }
      ]);
    }).then(function(problems) {
      currentProblems = problems;
      return myUtils.getResultPeopleCount(problems, 'AC');
    }).then(function(counts) {
      var i, j, len, len1, p, tmp;
      tmp = {};
      for (i = 0, len = counts.length; i < len; i++) {
        p = counts[i];
        tmp[p.problem_id] = p.count;
      }
      for (j = 0, len1 = currentProblems.length; j < len1; j++) {
        p = currentProblems[j];
        p.acceptedPeopleCount = 0;
        if (tmp[p.id]) {
          p.acceptedPeopleCount = tmp[p.id];
        }
      }
      return myUtils.getResultPeopleCount(currentProblems);
    }).then(function(counts) {
      var i, j, len, len1, p, tmp;
      tmp = {};
      for (i = 0, len = counts.length; i < len; i++) {
        p = counts[i];
        tmp[p.problem_id] = p.count;
      }
      for (j = 0, len1 = currentProblems.length; j < len1; j++) {
        p = currentProblems[j];
        p.triedPeopleCount = 0;
        if (tmp[p.id]) {
          p.triedPeopleCount = tmp[p.id];
        }
      }
      return myUtils.getResultCount(currentUser, currentProblems, 'AC');
    }).then(function(counts) {
      var i, j, len, len1, p, tmp;
      tmp = {};
      for (i = 0, len = counts.length; i < len; i++) {
        p = counts[i];
        tmp[p.problem_id] = p.count;
      }
      for (j = 0, len1 = currentProblems.length; j < len1; j++) {
        p = currentProblems[j];
        p.accepted = 0;
        if (tmp[p.id]) {
          p.accepted = tmp[p.id];
        }
      }
      return currentProblems;
    }).then(function(problems) {
      return res.render('problem/index', {
        user: req.session.user,
        problems: problems
      });
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', 'Unknown error!');
      return res.redirect(HOME_PAGE);
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
