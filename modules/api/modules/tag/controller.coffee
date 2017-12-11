#获取某一题目的所有标签
exports.getTags = (req, res)->
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findAllProblem_tag(req.params.problemID)
    .then (problem_tags)->
      #throw new global.myErrors.UnknownUser() if not problem and not req.session.user
      #throw new global.myErrors.UnknownContest() if not problem
      res.json(problem_tags)
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)

#为某一题目打标签
exports.postTags = (req, res)->
  currentTag = undefined
  global.db.Promise.resolve()
  .then ->
    #User.find req.session.user.id if req.session.user
  #.then (user)->
    #currentUser = user
    #throw new global.myErrors.UnknownUser() if not user
    global.myUtils.findProblem_tag(req.params.problemID, req.body.content)
  .then (ifRelationExit) ->
    if ifRelationExit
      res.json("关系已存在！")
    else
      global.myUtils.findTag(req.body.content)
      .then (ifTagExit) ->
        if !ifTagExit
          global.myUtils.createTag(req.body.content)
        global.myUtils.createProblem_tag(req.body.content, req.params.problemID, req.body.weight)
        .then (problem_tag)->
          res.json(problem_tag.get(plasin:true))
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)

#创建新的标签
exports.postcreateTags = (req, res)->
  currentTag = undefined
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findTag(req.body.content)
  .then (ifRelationExit) ->
    if ifRelationExit
      res.json("该标签已存在！")
    else
      global.myUtils.createTag(req.body.content)
      .then (tag)->
        res.json(tag.get(plasin:true))
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)

