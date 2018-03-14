#获取某一题解的所有标签
exports.getTags = (req, res)->
  global.db.Promise.resolve()
  .then ->
    global.myUtils.findAllSolution_tag(req.params.solutionID)
    .then (solution_tags)->
      res.json(solution_tags)
  .catch (err)->
    res.status(err.status || 400)
    res.json(error:err.message)

#为某一题解打标签
exports.postTags = (req, res)->
  currentTag = undefined
  i = undefined
  console.log req.body.content.length

  global.db.Promise.resolve()
  .then ->
    i = req.body.content.length
    loop
      if i
        global.myUtils.createSolution_tagS(req.body.content[i-1], req.body.solutionID[i-1], req.body.weight[i-1])
        i--
      else
        break
#  .then (solution_tag)->
#    res.json(solution_tag.get(plasin:true))
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

