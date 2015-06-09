// Generated by CoffeeScript 1.9.3
(function() {
  var UnknownJudge, UnknownSubmission, UnknownUser, path,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  path = require('path');

  UnknownUser = (function(superClass) {
    extend(UnknownUser, superClass);

    function UnknownUser(message) {
      this.message = message != null ? message : "Please Login";
      this.name = 'UnknownUser';
      Error.captureStackTrace(this, UnknownUser);
    }

    return UnknownUser;

  })(Error);

  UnknownSubmission = (function(superClass) {
    extend(UnknownSubmission, superClass);

    function UnknownSubmission(message) {
      this.message = message != null ? message : "Unknown submission.";
      this.name = 'UnknownSubmission';
      Error.captureStackTrace(this, UnknownSubmission);
    }

    return UnknownSubmission;

  })(Error);

  UnknownJudge = (function(superClass) {
    extend(UnknownJudge, superClass);

    function UnknownJudge(message) {
      this.message = message != null ? message : "Unknown judge.";
      this.name = 'UnknownJudge';
      Error.captureStackTrace(this, UnknownJudge);
    }

    return UnknownJudge;

  })(Error);

  UnknownSubmission = (function(superClass) {
    extend(UnknownSubmission, superClass);

    function UnknownSubmission(message) {
      this.message = message != null ? message : "Unknown submission.";
      this.name = 'UnknownSubmission';
      Error.captureStackTrace(this, UnknownSubmission);
    }

    return UnknownSubmission;

  })(Error);

  exports.Error = {
    UnknownUser: UnknownUser,
    UnknownSubmission: UnknownSubmission,
    UnknownJudge: UnknownJudge
  };

  exports.getStaticProblem = function(problemId) {
    var dirname;
    dirname = global.config.problem_resource_path;
    return path.join(dirname, problemId.toString());
  };

  exports.checkJudge = function(judge) {
    return global.db.Promise.resolve();
  };

}).call(this);

//# sourceMappingURL=utils.js.map
