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
      var base, offset;
      currentUser = user;
      if ((base = req.query).page == null) {
        base.page = 1;
      }
      offset = (req.query.page - 1) * global.config.pageLimit.problem;
      return myUtils.findProblems(user, offset, [
        {
          model: Group
        }
      ]);
    }).then(function(problems) {
      currentProblems = problems;
      return myUtils.getProblemsStatus(currentProblems, currentUser);
    }).then(function() {
      return res.render('problem/index', {
        user: req.session.user,
        problems: currentProblems
      });
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', 'Unknown error!');
      return res.redirect(HOME_PAGE);
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
