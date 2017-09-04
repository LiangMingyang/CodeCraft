

INDEX_PAGE = 'index'

LOGIN_PAGE = 'user/login'
HOME_PAGE = '/'


exports.getIndex = (req, res) ->
  User = global.db.models.user
  Submission = global.db.models.submission
  currentUser = undefined
  global.myUtils.getDoRankCountR()
    .then (results)->
      console.log(results[0].creator.dataValues.nickname)
      console.log(results[1].creator.dataValues.nickname)
      console.log(results[2].creator.dataValues.nickname)
      console.log(results[3].creator.dataValues.nickname)
      console.log(results[4].creator.dataValues.nickname)
      console.log(results[5].creator.dataValues.nickname)
      console.log(results[6].creator.dataValues.nickname)
      console.log(results[7].creator.dataValues.nickname)
      console.log(results[8].creator.dataValues.nickname)
      console.log(results[9].creator.dataValues.nickname)

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
          global.myUtils.getDoRankCount()
            .then (DoCounts) ->
              global.myUtils.getRankCountR()
                .then (CountsR) ->
                  global.myUtils.getDoRankCountR()
                    .then (DoCountsR) ->
                      global.myUtils.getSolutionCountR()
                      .then (ResultsR) ->
                        res.render 'rank/index', {
                            title: 'rank',
                            user: req.session.user
                            Counts:Counts
                            CountsR:CountsR
                            DoCounts:DoCounts
                            DoCountsR:DoCountsR
                            Results:Results
                            ResultsR:ResultsR
                        }

