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

# Get home page
router.get '/', (req, res)->
  res.redirect '/bcpc/index.html'

router.get '/index', (req, res) ->
  res.render 'index', {
    title: 'OJ4TH',
    user: req.session.user
  }

module.exports = router