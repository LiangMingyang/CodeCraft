express = require('express')
Sequelize=require('sequelize')
sequelize = new Sequelize('ojtest','root','09220922',{host:'127.0.0.1',port:'3306',dialect:'mysql'})


LOGIN_PAGE = 'user/login'
HOME_PAGE = '/'


exports.getIndex = (req, res) ->
  User = global.db.models.user
  Submission = global.db.models.submission
  Solution = global.db.models.solution
  global.myUtils.getRankCount(undefined ,undefined)
    .then (Counts) ->
      console.log(sequelize.query('select student_id from users where users.student_id=15211001', {type:sequelize.QueryTypes.SELECT}
      ))



   # .then(s) ->
    #  console.log(s)

#global.myUtils.getRankCount(undefined ,undefined)
  #.then (Counts) ->
   # global.myUtils.getSolutionCount(Counts)
    #.then (solutioncounts) ->
     # console.log(solutioncounts[0].id)
      #console.log(solutioncounts[0].submission_id)




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
    global.myUtils.getRankCount(undefined ,undefined)
    .then (Counts) ->
      global.myUtils.getRankName0(Counts)
      .then (usercounts0) ->
        global.myUtils.getRankName1(Counts)
          .then (usercounts1) ->
            global.myUtils.getRankName2(Counts)
              .then (usercounts2) ->
                global.myUtils.getRankName3(Counts)
                  .then (usercounts3) ->
                    global.myUtils.getRankName4(Counts)
                      .then (usercounts4) ->
                        global.myUtils.getRankName5(Counts)
                          .then (usercounts5) ->
                            global.myUtils.getRankName6(Counts)
                            .then (usercounts6) ->
                              global.myUtils.getRankName7(Counts)
                                .then (usercounts7) ->
                                  global.myUtils.getRankName8(Counts)
                                    .then (usercounts8) ->
                                      global.myUtils.getRankName9(Counts)
                                        .then (usercounts9) ->
                                          global.myUtils.getDoRankCount(undefined ,undefined)
                                            .then (DoCounts) ->
                                              global.myUtils.getRankName0(DoCounts)
                                              .then (userdocounts0) ->
                                                global.myUtils.getRankName1(DoCounts)
                                                .then (userdocounts1) ->
                                                  global.myUtils.getRankName2(DoCounts)
                                                  .then (userdocounts2) ->
                                                    global.myUtils.getRankName3(DoCounts)
                                                    .then (userdocounts3) ->
                                                      global.myUtils.getRankName4(DoCounts)
                                                      .then (userdocounts4) ->
                                                        global.myUtils.getRankName5(DoCounts)
                                                        .then (userdocounts5) ->
                                                          global.myUtils.getRankName6(DoCounts)
                                                          .then (userdocounts6) ->
                                                            global.myUtils.getRankName7(DoCounts)
                                                            .then (userdocounts7) ->
                                                              global.myUtils.getRankName8(DoCounts)
                                                              .then (userdocounts8) ->
                                                                global.myUtils.getRankName9(DoCounts)
                                                                .then (userdocounts9) ->
                                                                    res.render 'rank/index', {
                                                                      title: 'rank',
                                                                      user: req.session.user
                                                                      Counts:Counts
                                                                      DoCounts:DoCounts
                                                                      Usercounts0:usercounts0
                                                                      Usercounts1:usercounts1
                                                                      Usercounts2:usercounts2
                                                                      Usercounts3:usercounts3
                                                                      Usercounts4:usercounts4
                                                                      Usercounts5:usercounts5
                                                                      Usercounts6:usercounts6
                                                                      Usercounts7:usercounts7
                                                                      Usercounts8:usercounts8
                                                                      Usercounts9:usercounts9
                                                                      Userdocounts0:userdocounts0
                                                                      Userdocounts1:userdocounts1
                                                                      Userdocounts2:userdocounts2
                                                                      Userdocounts3:userdocounts3
                                                                      Userdocounts4:userdocounts4
                                                                      Userdocounts5:userdocounts5
                                                                      Userdocounts6:userdocounts6
                                                                      Userdocounts7:userdocounts7
                                                                      Userdocounts8:userdocounts8
                                                                      Userdocounts9:userdocounts9
                                                                    }

