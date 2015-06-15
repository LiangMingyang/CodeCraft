// Generated by CoffeeScript 1.9.3
(function() {
  module.exports = function(db) {
    var Contest, ContestProblemList, Group, Issue, IssueReply, Judge, Membership, Message, Problem, Submission, SubmissionCode, User, testContest, testGroup, testProblem, testUser;
    Contest = db.models.contest;
    ContestProblemList = db.models.contest_problem_list;
    Group = db.models.group;
    Judge = db.models.judge;
    Membership = db.models.membership;
    Problem = db.models.problem;
    Submission = db.models.submission;
    SubmissionCode = db.models.submission_code;
    User = db.models.user;
    Message = db.models.message;
    Issue = db.models.issue;
    IssueReply = db.models.issue_reply;
    testUser = void 0;
    testGroup = void 0;
    testContest = void 0;
    testProblem = void 0;
    return db.Promise.resolve().then(function() {
      var i, j;
      for (i = j = 0; j <= 100; i = ++j) {
        User.create({
          username: "test" + i + "@test.com",
          password: 'sha1$32f5d6c9$1$c84e8c6ed82e32549513da9444d940599ad30b96',
          nickname: "test" + i
        });
      }
      return User.create({
        username: "test@test.com",
        password: 'sha1$32f5d6c9$1$c84e8c6ed82e32549513da9444d940599ad30b96',
        nickname: 'test'
      });
    }).then(function(user) {
      var i, j;
      testUser = user;
      for (i = j = 0; j <= 100; i = ++j) {
        Group.create({
          name: "test_group_private" + i,
          description: 'This group is created for testing private.',
          access_level: 'private'
        }).then(function(group) {
          return group.setCreator(testUser);
        }).then(function(group) {
          return group.addUser(testUser, {
            access_level: 'owner'
          });
        });
      }
      Group.create({
        name: 'test_group_verifying',
        description: 'This group is created for testing verifying.',
        access_level: 'verifying'
      }).then(function(group) {
        return group.setCreator(testUser);
      }).then(function(group) {
        return group.addUser(testUser, {
          access_level: 'owner'
        });
      });
      return Group.create({
        name: 'test_group',
        description: 'This group is created for testing.',
        access_level: 'protect'
      }).then(function(group) {
        testGroup = group;
        return group.setCreator(testUser);
      }).then(function(group) {
        return group.addUser(testUser, {
          access_level: 'owner'
        });
      });
    }).then(function() {
      return Problem.create({
        title: 'test_problem_public',
        access_level: 'public'
      }).then(function(problem) {
        testProblem = problem;
        testUser.addProblem(problem);
        return testGroup.addProblem(problem);
      });
    }).then(function() {
      return Problem.create({
        title: 'test_problem',
        access_level: 'private'
      }).then(function(problem) {
        testUser.addProblem(problem);
        return testGroup.addProblem(problem);
      });
    }).then(function() {
      var i, j, results;
      results = [];
      for (i = j = 0; j <= 100; i = ++j) {
        results.push(Problem.create({
          title: "test_problem_protect" + i,
          access_level: 'protect'
        }).then(function(problem) {
          testUser.addProblem(problem);
          return testGroup.addProblem(problem);
        }));
      }
      return results;
    }).then(function() {
      var i, j;
      for (i = j = 0; j <= 100; i = ++j) {
        Contest.create({
          title: "test_contest_private" + i,
          access_level: 'private',
          description: '用来测试的比赛，权限是private',
          start_time: new Date("2015-05-20 10:00"),
          end_time: new Date("2015-05-21 10:00")
        }).then(function(contest) {
          testUser.addContest(contest);
          return testGroup.addContest(contest);
        });
      }
      return db.Promise.all([
        Contest.create({
          title: 'test_contest_private',
          access_level: 'private',
          description: '用来测试的比赛，权限是private',
          start_time: new Date("2015-05-20 10:00"),
          end_time: new Date("2015-05-21 10:00")
        }).then(function(contest) {
          testUser.addContest(contest);
          return testGroup.addContest(contest);
        }), Contest.create({
          title: 'test_contest_public',
          access_level: 'public',
          description: '用来测试的比赛，权限是public',
          start_time: new Date("2016-05-20 10:00"),
          end_time: new Date("2016-09-21 10:00")
        }).then(function(contest) {
          testUser.addContest(contest);
          return testGroup.addContest(contest);
        }), Contest.create({
          title: 'test_contest',
          access_level: 'protect',
          description: '用来测试的比赛，权限是protect',
          start_time: new Date("2015-05-21 10:00"),
          end_time: new Date("2015-06-21 10:00")
        }).then(function(contest) {
          testUser.addContest(contest);
          testGroup.addContest(contest);
          return contest.addProblem(testProblem, {
            order: 0,
            score: 1
          });
        })
      ]);
    }).then(function() {
      return db.Promise.all([
        Judge.create({
          name: "Judge1",
          secret_key: "沛神太帅了"
        }), Judge.create({
          name: "Judge2",
          secret_key: "梁明阳专用judge"
        })
      ]);
    }).then(function() {
      var i, j;
      for (i = j = 0; j <= 100; i = ++j) {
        Submission.create({
          result: 'AC'
        }).then(function(submission) {
          submission.setCreator(testUser);
          testUser.addSubmission(submission);
          return testProblem.addSubmission(submission);
        });
      }
      return void 0;
    }).then(function() {
      return console.log("init ok!");
    });
  };

}).call(this);

//# sourceMappingURL=init.js.map
