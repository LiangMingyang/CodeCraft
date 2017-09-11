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
    global.myUtils.ChampionRank1()
    .then (Champion1) ->
      global.myUtils.ChampionRank2()
      .then (Champion2) ->
        global.myUtils.ChampionRank3()
        .then (Champion3) ->
          global.myUtils.ChampionRank4()
          .then (Champion4) ->
            global.myUtils.ChampionRank5()
            .then (Champion5) ->
              global.myUtils.ChampionRank6()
              .then (Champion6) ->
                global.myUtils.ChampionRank7()
                .then (Champion7) ->
                  global.myUtils.ChampionRank8()
                  .then (Champion8) ->
                    global.myUtils.ChampionRank9()
                    .then (Champion9) ->
                      global.myUtils.ChampionRank10()
                      .then (Champion10) ->
                        global.myUtils.ChampionRank11()
                        .then (Champion11) ->
                          global.myUtils.ChampionRank12()
                          .then (Champion12) ->
                            res.render 'index', {
                              title: 'OJ4TH',
                              user: req.session.user
                              recommendation: recommendation
                              Champion1:Champion1
                              Champion2:Champion2
                              Champion3:Champion3
                              Champion4:Champion4
                              Champion5:Champion5
                              Champion6:Champion6
                              Champion7:Champion7
                              Champion8:Champion8
                              Champion9:Champion9
                              Champion10:Champion10
                              Champion11:Champion11
                              Champion12:Champion12
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