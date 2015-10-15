module.exports = [
  (req, res, next) ->
    now = new Date()
    now = now.getTime()
    req.session.last_vis ?= now
    fail = false
    if req.session.last_url is req.url and now-req.session.last_vis < 1000
      fail = true
    req.session.last_vis = now
    req.session.last_url = req.url
    if fail
      res.end("骚年,别着急,等会儿再刷新")
    else
      next()
]