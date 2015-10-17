module.exports = [
  (req, res, next)->
    if req.url != '/' and '/' == req.url[req.url.length - 1]
      res.redirect req.url.slice(0, -1)
    else
      next()
]