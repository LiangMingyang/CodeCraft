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
  recommendation = undefined
  currentUser = undefined

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