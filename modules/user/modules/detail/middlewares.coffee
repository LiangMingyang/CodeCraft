module.exports = [
  (req, res, next) ->
    console.log "I am the first middleware of userDetail"
    next()
]