// Generated by CoffeeScript 1.12.6
(function() {
  var HOME_PAGE, INDEX_PAGE, LOGIN_PAGE;

  INDEX_PAGE = 'index';

  LOGIN_PAGE = 'user/login';

  HOME_PAGE = '/';

  exports.getIndex = function(req, res) {
    var Submission, User, currentUser;
    User = global.db.models.user;
    Submission = global.db.models.submission;
    currentUser = void 0;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      currentUser = user;
      if (!currentUser) {
        return [];
      }
    }).then(function() {
      return global.myUtils.getRankCount().then(function(Counts) {
        return global.myUtils.getRankCountR().then(function(CountsR) {
          return global.myUtils.getSolutionCountR().then(function(ResultsR) {
            return global.myUtils.AllPeople().then(function(Presults) {
              return res.render('rank/index', {
                title: 'rank',
                user: req.session.user,
                Counts: Counts,
                CountsR: CountsR,
                ResultsR: ResultsR,
                Presults: Presults
              });
            });
          });
        });
      });
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
