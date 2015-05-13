module.exports = [
  (req, res, next) ->
    console.log "I am the first middleware of user index"
    next()
]