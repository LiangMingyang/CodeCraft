module.exports = [
  (req, res, next)->
    if req.url != '/' and '/' == req.url[req.url.length - 1]
      res.redirect req.url.slice(0, -1)
    else
      next()
,
  (req, res, next) ->
    #console.log 'I am the second middleware of index'
    next()
]