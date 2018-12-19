express = require('express')
router = express.Router(mergeParams: true);
middlewares = require('../middlewares')

modules = require('../modules')

router.use middlewares

router.use '/user', modules.user.router

router.use '/group', modules.group.router

router.use '/problem', modules.problem.router

router.use '/contest', modules.contest.router

router.use '/message', modules.message.router

router.use '/submission', modules.submission.router

router.use '/feedback', modules.feedback.router

router.use '/api', modules.api.router

router.use '/rank', modules.rank.router

# Get home page
router.get '/', (req, res)->
  res.redirect '/index'

router.get '/index', (req, res) ->
  User = global.db.models.user
  Github = []
  recommendation = undefined
  currentUser = undefined
  ProblemTag = undefined
  SolutionTag = undefined
  solutionTags = []
  Tags = []
  problemTags = []
  i1 = undefined
  i2 = undefined
  j = undefined
  J = undefined
  tmp = undefined
  SI = undefined
  PI = undefined
  sp = undefined
  SP = undefined
  sequelize = global.db

#  s = global.db.models.login_note
  global.db.Promise.resolve()
  .then ()->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    return [] if not currentUser
    currentUser.getRecommendation()
  .then (recommendation_problems)->
    recommendation = (problem.get(plain: true) for problem in recommendation_problems)
    recommendation.sort (a,b)->
      b.recommendation.score - a.recommendation.score

    sequelize.query('select problems.id,solution_tags.tag_id,sum(weight) as weight, tags.content from  problems, submissions, solutions, solution_tags, tags where problems.id = submissions.problem_id = "1" and submissions.id =  solutions.submission_id and  solutions.id =  solution_tags.solution_id and  solution_tags.tag_id =  tags.id group by  problems.id, solution_tags.tag_id order by  problems.id,sum(weight) DESC, solution_tags.tag_id')
  .spread (results, metadata) ->
    SolutionTag = results
    sequelize.query('select  problems.id,problem_tags.tag_id,sum(weight) as weight, tags.content from  problems, problem_tags, tags where  problems.id =  problem_tags.problem_id and  problem_tags.tag_id =  tags.id group by  problems.id , problem_tags.tag_id order by  problems.id , problem_tags.tag_id')
  .spread (results, metadata) ->
    ProblemTag = results
  .then ->
    if recommendation
      j = 0
      for Recommendation in recommendation
        i1 = 0
        i2 = 0
        SI = 3
        PI = 3
        solutionTags = []
        problemTags = []
        if SolutionTag
          for solutionTag in SolutionTag
            if solutionTag.id == Recommendation.id && SI
              solutionTags[i1] = solutionTag
              i1++
              SI--
        if ProblemTag
          for problemTag in ProblemTag
            if problemTag.id == Recommendation.id && PI
              problemTags[i2] = problemTag
              i2++
              PI--
#        console.log problemTags
#        console.log solutionTags
        if JSON.stringify(solutionTags)!="[]" && JSON.stringify(problemTags)!="[]"
          stmp = solutionTags.length
          ptmp = problemTags.length
          if !stmp
            sp = "["+JSON.stringify(solutionTags)
          else
            sp = "["+JSON.stringify(solutionTags[stmp-1])
            stmp = stmp-1
            loop
              if stmp
                sp = sp + ","+JSON.stringify(solutionTags[stmp-1])
                stmp = stmp-1
              else
                break
          if !ptmp
            sp = sp + "," + JSON.stringify(problemTags)
          else
            loop
              if ptmp
                sp = sp + ","+ JSON.stringify(problemTags[ptmp-1])
                ptmp = ptmp-1
              else
                break
          sp = sp + "]"
          SP = JSON.parse(sp)
          SP.sort (a,b) ->
            b.weight - a.weight
          tmp = SP.length
          J = 0
          loop
            if tmp >= 3
              Tags[j] = SP[J].content + "-"+SP[J+1].content + "-"+SP[J+2].content
              j++
              J = J+3
              tmp = tmp-3
            else if 2 <= tmp < 3
              Tags[j] = SP[J].content + "-"+SP[J+1].content
              j++
              J = J+3
              tmp = tmp-3
            else if tmp ==1
              Tags[j] = SP[J].content
              j++
              J = J+3
              tmp = tmp-3
            else
              break

        else if JSON.stringify(solutionTags)!="[]"
          tmp = solutionTags.length
          J = 0
          loop
            if tmp >= 3
              Tags[j] = solutionTags[J].content + "-"+solutionTags[J+1].content + "-"+solutionTags[J+2].content
              j++
              J = J+3
              tmp = tmp-3
            else if 2 <= tmp < 3
              Tags[j] = solutionTags[J].content + "-"+solutionTags[J+1].content
              j++
              J = J+3
              tmp = tmp-3
            else if tmp ==1
              Tags[j] = solutionTags[J].content
              j++
              J = J+3
              tmp = tmp-3
            else
              break
        else if JSON.stringify(problemTags)!="[]"
          tmp = problemTags.length
          J = 0
          loop
            if tmp >= 3
              Tags[j] = problemTags[J].content + "-"+problemTags[J+1].content + "-"+problemTags[J+2].content
              j++
              J = J+3
              tmp = tmp-3
            else if 2 <= tmp < 3
              Tags[j] = problemTags[J].content + "-"+problemTags[J+1].content
              j++
              J = J+3
              tmp = tmp-3
            else if tmp ==1
              Tags[j] = problemTags[J].content
              j++
              J = J+3
              tmp = tmp-3
            else
              break
        else
          Tags[j] = "[]"
          j++
#      console.log Tags[0]

  .then ()->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    return [] if not currentUser
    global.myUtils.UserAccpectedProblem(currentUser.id)
  .then (results)->
    problem = results
    res.render 'index', {
      title: 'OJ4TH',
      user: req.session.user
      recommendation: recommendation
      problems: problem
      tags:Tags
      Github:Github
    }

router.get '/notice', (req, res) ->
  res.render 'notice', {
    title: '招聘启事'
    user: req.session.user
  }
router.get '/notice', (req, res)->
  res.render 'notice', {
    title: '招聘启事'
    user: req.session.user
  }

router.get '/bcpc-rating', (req, res) ->
  teamName = [
    "TDL"
  , "LovelyDonuts"
  , "ACMakeMeHappier"
  , "null"
  , "sto orz"
  , "QAQ"
  , "ResuscitatedHope"
  , "Veleno"
  , "deticxe"
  , "GG"
  , "firebug"
  , "The South China Sea"
  ];
  res.render 'acm-rating/rating', { title: '北航ACM集训队Rating计算', teamName: teamName, user: req.session.user }
module.exports = router