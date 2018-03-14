#获取某一题目的所有标签
exports.getTags = (req, res)->
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findAllProblem_tag(req.params.problemID)
    .then (problem_tags)->
      res.json(problem_tags)
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)

#为某一题目打标签
exports.postTags = (req, res)->
  currentTag = undefined
  i = undefined
  #console.log req.body.content

  global.db.Promise.resolve()
  .then ->
    i = req.body.content.length
    loop
      if i
        global.myUtils.createProblem_tagS(req.body.content[i-1], req.body.problemID[i-1], req.body.weight[i-1])
        i--
      else
        break

#  global.db.Promise.resolve()
#  .then ->
#    i = req.body.content.length
#    loop
#      if i
#
#    global.myUtils.findProblem_tag(req.body.problemID, req.body.content)
#  .then (ifRelationExit) ->
##    if ifRelationExit
##      res.json("关系已存在！")
#    if !ifRelationExit
#      global.myUtils.findTag(req.body.content)
#      .then (ifTagExit) ->
#        if !ifTagExit
#          global.myUtils.createTag(req.body.content)
#        global.myUtils.createProblem_tag(req.body.content, req.body.problemID, req.body.weight)
#        .then (problem_tag)->
#          res.json(problem_tag.get(plasin:true))
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

