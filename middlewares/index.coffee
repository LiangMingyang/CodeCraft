module.exports = [
  (req, res, next)->
    if req.url != '/' and '/' == req.url[req.url.length - 1]
      res.redirect req.url.slice(0, -1)
    else
      next()
#,
#  (req, res, next) ->
#    now = new Date()
#    now = now.getTime()
#    req.session.last_vis ?= now
#    fail = false
#    if req.session.last_url is req.url and now-req.session.last_vis < 1000
#      fail = true
#    req.session.last_vis = now
#    req.session.last_url = req.url
#    if fail
#      res.end("ɧ��,���ż�,�Ȼ����ˢ��")
#    else
#      next()
]