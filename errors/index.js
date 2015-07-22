// Generated by CoffeeScript 1.9.3
(function() {
  var InvalidAccess, InvalidFile, LoginError, RegisterError, UnknownJudge, UnknownProblem, UnknownSubmission, UnknownUser, UpdateError,
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

  UnknownSubmission = (function(superClass) {
    extend(UnknownSubmission, superClass);

    function UnknownSubmission(message) {
      this.message = message != null ? message : "Unknown submission.";
      this.name = 'UnknownSubmission';
      Error.captureStackTrace(this, UnknownSubmission);
    }

    return UnknownSubmission;

  })(Error);

  UnknownProblem = (function(superClass) {
    extend(UnknownProblem, superClass);

    function UnknownProblem(message) {
      this.message = message != null ? message : "Unknown problem";
      this.name = 'UnknownProblem';
      Error.captureStackTrace(this, UnknownProblem);
    }

    return UnknownProblem;

  })(Error);

  InvalidFile = (function(superClass) {
    extend(InvalidFile, superClass);

    function InvalidFile(message) {
      this.message = message != null ? message : "File not exist!";
      this.name = 'InvalidFile';
      Error.captureStackTrace(this, InvalidFile);
    }

    return InvalidFile;

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

  module.exports = {
    UnknownUser: UnknownUser,
    LoginError: LoginError,
    RegisterError: RegisterError,
    InvalidAccess: InvalidAccess,
    UpdateError: UpdateError,
    UnknownSubmission: UnknownSubmission,
    UnknownProblem: UnknownProblem,
    InvalidFile: InvalidFile,
    UnknownJudge: UnknownJudge
  };

}).call(this);

//# sourceMappingURL=index.js.map
