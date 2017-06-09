// Generated by CoffeeScript 1.10.0
(function() {
  var InvalidAccess, InvalidFile, LoginError, RegisterError, UnknownContest, UnknownGroup, UnknownJudge, UnknownProblem, UnknownSolution, UnknownSubmission, UnknownUser, UpdateError,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  UnknownUser = (function(superClass) {
    extend(UnknownUser, superClass);

    function UnknownUser(message) {
      this.message = message != null ? message : "请先登录";
      this.name = 'UnknownUser';
      this.status = 401;
      Error.captureStackTrace(this, UnknownUser);
    }

    return UnknownUser;

  })(Error);

  UnknownGroup = (function(superClass) {
    extend(UnknownGroup, superClass);

    function UnknownGroup(message) {
      this.message = message != null ? message : "小组不存在，或者你没有权限";
      this.name = 'UnknownGroup';
      this.status = 403;
      Error.captureStackTrace(this, UnknownGroup);
    }

    return UnknownGroup;

  })(Error);

  LoginError = (function(superClass) {
    extend(LoginError, superClass);

    function LoginError(message) {
      this.message = message != null ? message : "用户名或密码错误";
      this.name = 'LoginError';
      this.status = 401;
      Error.captureStackTrace(this, LoginError);
    }

    return LoginError;

  })(Error);

  RegisterError = (function(superClass) {
    extend(RegisterError, superClass);

    function RegisterError(message) {
      this.message = message != null ? message : "注册信息有误";
      this.name = 'RegisterError';
      this.status = 400;
      Error.captureStackTrace(this, RegisterError);
    }

    return RegisterError;

  })(Error);

  InvalidAccess = (function(superClass) {
    extend(InvalidAccess, superClass);

    function InvalidAccess(message) {
      this.message = message != null ? message : "做不到";
      this.name = 'InvalidAccess';
      this.status = 403;
      Error.captureStackTrace(this, InvalidAccess);
    }

    return InvalidAccess;

  })(Error);

  UpdateError = (function(superClass) {
    extend(UpdateError, superClass);

    function UpdateError(message) {
      this.message = message != null ? message : "更新出错";
      this.name = 'UpdateError';
      this.status = 403;
      Error.captureStackTrace(this, UpdateError);
    }

    return UpdateError;

  })(Error);

  UnknownSubmission = (function(superClass) {
    extend(UnknownSubmission, superClass);

    function UnknownSubmission(message) {
      this.message = message != null ? message : "提交记录不存在，或者你没有权限";
      this.name = 'UnknownSubmission';
      this.status = 403;
      Error.captureStackTrace(this, UnknownSubmission);
    }

    return UnknownSubmission;

  })(Error);

  UnknownProblem = (function(superClass) {
    extend(UnknownProblem, superClass);

    function UnknownProblem(message) {
      this.message = message != null ? message : "题目不存在，或者你没有权限";
      this.name = 'UnknownProblem';
      this.status = 403;
      Error.captureStackTrace(this, UnknownProblem);
    }

    return UnknownProblem;

  })(Error);

  InvalidFile = (function(superClass) {
    extend(InvalidFile, superClass);

    function InvalidFile(message) {
      this.message = message != null ? message : "文件不存在，或者你没有权限";
      this.name = 'InvalidFile';
      this.status = 403;
      Error.captureStackTrace(this, InvalidFile);
    }

    return InvalidFile;

  })(Error);

  UnknownJudge = (function(superClass) {
    extend(UnknownJudge, superClass);

    function UnknownJudge(message) {
      this.message = message != null ? message : "评测机不合法";
      this.name = 'UnknownJudge';
      this.status = 403;
      Error.captureStackTrace(this, UnknownJudge);
    }

    return UnknownJudge;

  })(Error);

  UnknownContest = (function(superClass) {
    extend(UnknownContest, superClass);

    function UnknownContest(message) {
      this.message = message != null ? message : "比赛不存在，或者你没有权限";
      this.name = 'UnknownContest';
      this.status = 403;
      Error.captureStackTrace(this, UnknownContest);
    }

    return UnknownContest;

  })(Error);

  UnknownSolution = (function(superClass) {
    extend(UnknownSolution, superClass);

    function UnknownSolution(message) {
      this.message = message != null ? message : "题解不存在，或者你没有权限";
      this.name = 'UnknownContest';
      this.status = 403;
      Error.captureStackTrace(this, UnknownContest);
    }

    return UnknownSolution;

  })(Error);

  module.exports = {
    UnknownUser: UnknownUser,
    UnknownGroup: UnknownGroup,
    UnknownContest: UnknownContest,
    UnknownSubmission: UnknownSubmission,
    UnknownProblem: UnknownProblem,
    UnknownJudge: UnknownJudge,
    LoginError: LoginError,
    RegisterError: RegisterError,
    InvalidAccess: InvalidAccess,
    UpdateError: UpdateError,
    InvalidFile: InvalidFile,
    UnknownSolution: UnknownSolution
  };

}).call(this);

//# sourceMappingURL=index.js.map
