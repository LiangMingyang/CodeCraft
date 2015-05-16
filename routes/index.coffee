express = require('express')
router = express.Router()
middlewares = require('../middlewares')

modules = require('../modules')

router.use middlewares

router.use '/user', modules.user.router

# Get home page
router.get '/',  (req, res) ->
  res.render 'index', {
      title: 'OJ4TH',
      user: {
        userID: req.session.userID,
        nickname: req.session.nickname
      } if req.session.userID
    }

module.exports = router