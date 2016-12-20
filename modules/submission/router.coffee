express = require('express');
router = express.Router(mergeParams: true);
middlewares = require('./middlewares')
controller = require('./controller')
# modules = require('./modules')

router.use(middlewares)

router
.get '/', (req, res) ->
  res.redirect 'submission/index'

.get '/index', controller.getIndex
.post '/index', controller.postIndex

.get '/:submissionID([0-9]+)', controller.getSubmission

.get '/:submissionID([0-9]+)/solution-editor', controller.getSolutionEditor

.post '/getSubmissionApi', controller.postSubmissionApi

module.exports = router
