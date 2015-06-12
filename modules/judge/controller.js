// Generated by CoffeeScript 1.9.3
(function() {
  var FS, HOME_PAGE, INDEX_PAGE, LOGIN_PAGE, fs, myUtils, path, sequelize;

  myUtils = require('./utils');

  sequelize = require('sequelize');

  fs = sequelize.Promise.promisifyAll(require('fs'), {
    suffix: 'Promised'
  });

  FS = require('fs');

  path = require('path');

  INDEX_PAGE = 'index';

  LOGIN_PAGE = 'user/login';

  HOME_PAGE = '/';

  exports.postTask = function(req, res) {
    var Submission, SubmissionCode, currentSubmission;
    Submission = global.db.models.submission;
    SubmissionCode = global.db.models.submission_code;
    currentSubmission = void 0;
    return myUtils.checkJudge(req.body.judge).then(function() {
      return Submission.find({
        where: {
          result: 'WT'
        },
        include: [
          {
            model: SubmissionCode
          }
        ]
      });
    }).then(function(submission) {
      if (!submission) {
        throw new myUtils.Error.UnknownSubmission();
      }
      submission.result = "JG";
      currentSubmission = submission;
      return submission.save();
    }).then(function(submission) {
      return fs.readFilePromised(path.join(myUtils.getStaticProblem(submission.problem_id), 'manifest.json'));
    }).then(function(manifest_str) {
      currentSubmission.dataValues.manifest = JSON.parse(manifest_str);
      return res.json(currentSubmission);
    })["catch"](myUtils.Error.UnknownSubmission, function() {
      return res.end();
    })["catch"](function(err) {
      console.log(err);
      return res.end();
    });
  };

  exports.postFile = function(req, res) {
    return myUtils.checkJudge(req.body.judge).then(function() {
      var download, filename, problemID;
      problemID = req.body.problem_id;
      filename = req.body.filename;
      download = sequelize.Promise.promisify(res.download, res);
      return download(path.join(myUtils.getStaticProblem(problemID), filename), filename);
    })["catch"](function(err) {
      console.log(err);
      return res.end();
    });
  };

  exports.postReport = function(req, res) {
    var Submission;
    Submission = global.db.models.submission;
    return myUtils.checkJudge(req.body.judge).then(function() {
      return Submission.update({
        result: (req.body.result ? req.body.result : "ERR"),
        score: req.body.score,
        detail: req.body.detail,
        judge_id: req.body.judge_id,
        time_cost: req.body.time_cost,
        memory_cost: req.body.memory_cost
      }, {
        where: {
          id: req.body.submission_id
        }
      });
    }).then(function() {
      return res.end();
    })["catch"](function(err) {
      console.log(err);
      return res.end();
    });
  };

}).call(this);

//# sourceMappingURL=controller.js.map