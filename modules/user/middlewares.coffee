module.exports = [
  (req, res, next) ->
    req.flash("info", "I am the first middleware of user index")
    req.flash("info", "I am the second middleware of user index")
    next()
]