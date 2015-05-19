express = require('express')
router = express.Router()
middlewares = require('../middlewares')

modules = require('../modules')

router.use middlewares

router.use '/user', modules.user.router

router.use '/group', modules.group.router

# Get home page
router.get '/', (req, res) ->
  res.render 'index', {
    title: 'OJ4TH',
    user: req.session.user
  }

module.exports = router