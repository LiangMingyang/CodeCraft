module.exports = [
  (req, res, next) ->
    console.log 'I am the first middleware of index'
    next()
  ,
  (req, res, next) ->
    console.log 'I am the second middleware of index'
    next()
]