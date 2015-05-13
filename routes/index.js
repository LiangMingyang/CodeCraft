var express = require('express');
var router = express.Router();
var middlewares = require('../middlewares');

var modules = require('../modules');

router.use(middlewares);

router.use('/user', modules.user.router);

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

module.exports = router;
