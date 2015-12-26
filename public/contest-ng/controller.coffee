

angular.module('contest', [
  #'angularUtils.directives.dirPagination'
#,
  'contest-factory'
,
  'contest-router'
])

.filter('marked', ['$sce', ($sce)->
    (text)->
      text = "" if not text
      $sce.trustAsHtml(markdown.toHTML(text))
  ])

.filter('penalty', [()->
  (date)->
    return "" if not date
    penalty = new Date(date)
    peanlty = penalty.getTime()
    seconds = (peanlty - peanlty%1000)/1000
    minutes = (seconds - seconds%60)/60
    hours = (minutes - minutes%60)/60
    minutes %= 60
    minutes = '0'+minutes if minutes < 10
    seconds %= 60
    seconds = '0'+seconds if seconds < 10
    return "#{hours}:#{minutes}:#{seconds}"
])

.filter('wrongCount', [()->
  (wrong_count)->
    return "" if not wrong_count or wrong_count is 0
    return "(+#{wrong_count})"
])

.filter('result', [()->
  (result)->
    dic = {
      AC : "Accepted",
      WA : "Wrong Answer",
      CE : "Compile Error",
      RE : "Runtime Error",
      REG : "Runtime Error (SIGSEGV)",
      REP : "Runtime Error (SIGFPE)",
      WT : "Waiting",
      JG : "Running",
      TLE : "Time Limit Exceed",
      MLE : "Memory Limit Exceed",
      PE : "Presentation Error",
      ERR : "Judge Error",
      IFNR : "Input File Not Ready",
      OFNR : "Output File Not Ready",
      EFNR : "Error File Not Ready",
      OE : "Other Error"
    }
    return dic[result] || "Other Error"
])

.controller('contest.mainCtrl', ($scope, $routeParams, $http, $timeout, Submission, Contest, Me, Rank, ServerTime,Issue)->
#data

  $scope.order = Contest.order
  $scope.form ?= {lang:'c++'}

  $scope.Me = Me

  $scope.ServerTime = ServerTime
  $scope.contestId = $routeParams.contestId

  Contest.setContestId($routeParams.contestId)
  $scope.Contest = Contest

  Submission.setContestId($routeParams.contestId)
  $scope.Submission = Submission

  Rank.setContestId($routeParams.contestId)
  $scope.Rank = Rank

  Issue.setContestId($routeParams.contestId)
  $scope.Issue = Issue


  #Function

  $scope.setProblem = (order)->
    Contest.order = order
    $scope.order = order
    $timeout(->
      MathJax.Hub.Queue(["Typeset",MathJax.Hub])
    ,500)
  #MathJax.Hub.Typeset()

  $scope.isProblem = (order)->
    $scope.order is order

  $scope.numberToLetters = (num)->
    return 'A' if num is 0
    res = ""
    while(num>0)
      res = String.fromCharCode(num%26 + 65) + res
      num = parseInt(num/26)
    return res

  $scope.submit = ()->
    $scope.form.order = $scope.order
    if not $scope.form.code or $scope.form.code.length < 10
      alert("代码太短了，拒绝提交")
      return
    Submission.submit($scope.form)

  $scope.accepted = (order)->
    try
      res = (sub for sub in Submission.data when $scope.Contest.idToOrder[sub.problem_id] is order and sub.result is 'AC')
      return res.length isnt 0
    catch err
      return false
  $scope.tried = (order)->
    try
      res = (sub for sub in Submission.data when $scope.Contest.idToOrder[sub.problem_id] is order)
      return res.length isnt 0
    catch err
      return false

  #change submission color by ZP
  $scope.change_submission_color = (submission, index)->
    color = undefined
    number = undefined
    if submission == "WT" or submission == "JG"
      color = "green"
    else if submission == "AC"
      color = "blue"
    else
      color = "red"
    if index % 2 == 0
      number = "even"
    else
      number = "odd"
    return color + "-" + number + "-" + "tr"

  #change submission result color by ZP
  $scope.change_submission_result_color = (result)->
    switch result
      when "WT","JG" then "green-td"
      when "AC" then "blue-td"
      else "red-td"

  #return if the result is running or judging
  $scope.check_submission_is_running = (result)->
    return result == "WT" or result == "JG"

  $scope.active = ()->
    Rank.active()
    Contest.active()
    Issue.active()

  #private functions

  #by ZP
  $scope.question_form = {}
  question_list = {}
  $scope.submit_question_form = (order)->
    $scope.question_form.order = $scope.order
    Issue.create($scope.question_form)
  $scope.is_question = 0
  $scope.question_title = "提问"
  $scope.show_question_area = ()->
    if($scope.is_question == 0)
      $scope.question_title = "收起"
      $scope.is_question = 1
    else
      $scope.is_question = 0
      $scope.question_title = "提问"
  $scope.change_question_list = (index)->
    question_list[index] = !!!question_list[index]
  $scope.query_question_list = (index)->
    !!question_list[index]
  $scope.question_page = 0;
  $scope.table_tr_title = {title:"提问标题",nickname:"提问者",time:"提问时间",problem:"提问题目"}
  $scope.change_table_tr_title_to_issue = ()->
    $scope.table_tr_title.title = "公告标题"
    $scope.table_tr_title.nickname = "发布者"
    $scope.table_tr_title.time = "发布公告时间"
    $scope.table_tr_title.problem = "公告对应题目"
  $scope.change_table_tr_title_to_question = ()->
    $scope.table_tr_title.title = "提问标题"
    $scope.table_tr_title.nickname = "提问者"
    $scope.table_tr_title.time = "提问时间"
    $scope.table_tr_title.problem = "提问题目"
  $scope.set_question_page = (question_page)->
    $scope.question_page = question_page
    $scope.change_table_tr_title_to_issue() if question_page == 2
    $scope.change_table_tr_title_to_question() if question_page == 0 || question_page == 1

#end
)
