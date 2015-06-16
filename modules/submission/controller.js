// Generated by CoffeeScript 1.9.3
(function() {
  var HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, myUtils;

  myUtils = require('./utils');

  INDEX_PAGE = 'index';

  LOGIN_PAGE = 'user/login';

  HOME_PAGE = '/';

  exports.getIndex = function(req, res) {
    var User;
    User = global.db.models.user;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      return myUtils.findSubmissions(user, req.query.offset, [
        {
          model: User,
          as: 'creator'
        }
      ]);
    }).then(function(submissions) {
      return res.render('submission/index', {
        user: req.session.user,
        submissions: submissions
      });
    })["catch"](myUtils.Error.UnknownUser, function(err) {
      req.flash('info', err.message);
      return res.redirect(LOGIN_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

  exports.getSubmission = function(req, res) {
    var SubmissionCode, User;
    User = global.db.models.user;
    SubmissionCode = global.db.models.submission_code;
    return global.db.Promise.resolve().then(function() {
      if (req.session.user) {
        return User.find(req.session.user.id);
      }
    }).then(function(user) {
      return myUtils.findSubmission(user, req.params.submissionID, [
        {
          model: SubmissionCode
        }
      ]);
    }).then(function(submission) {
      if (!submission) {
        throw new myUtils.Error.UnknownSubmission();
      }
      return res.render('submission/code', {
        user: req.session.user,
        submission: submission
      });
    })["catch"](myUtils.Error.UnknownSubmission, function(err) {
      req.flash('info', err.message);
      return res.redirect(INDEX_PAGE);
    })["catch"](myUtils.Error.UnknownUser, function(err) {
      console.log(err);
      req.flash('info', "Please Login First!");
      return res.redirect(LOGIN_PAGE);
    })["catch"](function(err) {
      console.log(err);
      req.flash('info', "Unknown Error!");
      return res.redirect(HOME_PAGE);
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map
