

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
                  global.myUtils.ChampionRank1()
                  .then (Champion1) ->
                    global.myUtils.ChampionRank2()
                    .then (Champion2) ->
                      global.myUtils.ChampionRank3()
                      .then (Champion3) ->
                        global.myUtils.ChampionRank4()
                        .then (Champion4) ->
                          global.myUtils.ChampionRank5()
                          .then (Champion5) ->
                            global.myUtils.ChampionRank6()
                            .then (Champion6) ->
                              global.myUtils.ChampionRank7()
                              .then (Champion7) ->
                                global.myUtils.ChampionRank8()
                                .then (Champion8) ->
                                  global.myUtils.ChampionRank9()
                                  .then (Champion9) ->
                                    global.myUtils.ChampionRank10()
                                    .then (Champion10) ->
                                      global.myUtils.ChampionRank11()
                                      .then (Champion11) ->
                                        global.myUtils.ChampionRank12()
                                        .then (Champion12) ->
                                          res.render 'rank/index', {
                                              title: 'rank',
                                              user: req.session.user
                                              Counts:Counts
                                              CountsR:CountsR
                                              Results:Results
                                              ResultsR:ResultsR
                                              Champion1:Champion1
                                              Champion2:Champion2
                                              Champion3:Champion3
                                              Champion4:Champion4
                                              Champion5:Champion5
                                              Champion6:Champion6
                                              Champion7:Champion7
                                              Champion8:Champion8
                                              Champion9:Champion9
                                              Champion10:Champion10
                                              Champion11:Champion11
                                              Champion12:Champion12
                                          }

