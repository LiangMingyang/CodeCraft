

INDEX_PAGE = 'index'

LOGIN_PAGE = 'user/login'
HOME_PAGE = '/'


exports.getIndex = (req, res) ->
  User = global.db.models.user
  Submission = global.db.models.submission
  currentUser = undefined

  global.db.Promise.resolve()
  .then ()->
    User.find req.session.user.id if req.session.user
  .then (user)->
    currentUser = user
    return [] if not currentUser
  .then ()->
    global.myUtils.getSolutionCount()
    .then (Results)->
      global.myUtils.getRankCount()
        .then (Counts) ->
          global.myUtils.getRankCountR()
            .then (CountsR) ->
              global.myUtils.getSolutionCountR()
                .then (ResultsR) ->
                  global.myUtils.AllPeople()
                    .then (Presults)->
                      res.render 'rank/index', {
                          title: 'rank',
                          user: req.session.user
                          Counts:Counts
                          CountsR:CountsR
                          Results:Results
                          ResultsR:ResultsR
                          Presults:Presults
                      }

