#INIT_RATING = 1000
#INIT_VOL = 400
#qnorm = (p) ->
#  p = parseFloat(p)
#  split = 0.42
#  a0 = 2.50662823884
#  a1 = -18.61500062529
#  a2 = 41.39119773534
#  a3 = -25.44106049637
#  b1 = -8.47351093090
#  b2 = 23.08336743743
#  b3 = -21.06224101826
#  b4 = 3.13082909833
#  c0 = -2.78718931138
#  c1 = -2.29796479134
#  c2 = 4.85014127135
#  c3 = 2.32121276858
#  d1 = 3.54388924762
#  d2 = 1.63706781897
#  q = p - 0.5
#  if Math.abs(q) <= split
#    r = q * q
#    ppnd = q * (((a3 * r + a2) * r + a1) * r + a0) / ((((b4 * r + b3) * r + b2) * r + b1) * r + 1)
#  else
#    r = p
#    if q > 0
#      r = 1 - p
#    if r > 0
#      r = Math.sqrt(-Math.log(r))
#      ppnd = (((c3 * r + c2) * r + c1) * r + c0) / ((d2 * r + d1) * r + 1)
#      if q < 0
#        ppnd = -ppnd
#    else
#      ppnd = 0
#  ppnd
#
#erf = (x) ->
#  a1 = 0.254829592
#  a2 = -0.284496736
#  a3 = 1.421413741
#  a4 = -1.453152027
#  a5 = 1.061405429
#  p = 0.3275911
#  # Save the sign of x
#  sign = 1
#  if x < 0
#    sign = -1
#  x = Math.abs(x)
#  # A&S formula 7.1.26
#  t = 1.0 / (1.0 + p * x)
#  y = 1.0 - (((((a5 * t + a4) * t + a3) * t + a2) * t + a1) * t * Math.exp(-x * x))
#  sign * y
#
#calcERank = (x, form)->
#  res = 0
#  for ele in form
#    res += calcWP(x, ele)
#  res + 0.5
#
#
#calcWP = (x, y) ->
#  (erf((y.rating-x.rating)/Math.sqrt(2*(y.vol*y.vol+x.vol*x.vol)))+1)*0.5
#
#
#calcEperf = (ERank, form) ->
#  -qnorm((ERank-0.5)/form.length)
#
#calcAperf = (ARank, form) ->
#  -qnorm((ARank-0.5)/form.length)
#
#calcPerAs = (oldRating, Aperf, Eperf, CF)->
#  oldRating+CF*(Aperf-Eperf)
#
#calcWeight = (n)->
#  1/(0.82-0.42/n)-1
#
#calcCap = (n)->
#  150+1500/(n+1)
#
##ARank 要计算的是排名为多少的队伍
##form 积分表格，抽象为rating,vol，下标从0开始
##n 第几场比赛了
#
##Return {object}
## newRating
## newVol
#
#update = (ARank, form, n)->
##Error
#  if ARank<=0 or ARank>form.length
#    return -1;
#  if form.length <= 1
#    return -1
#  #calc CF
#  sum_rating = 0
#  for ele in form
#    sum_rating += ele.rating
#  aveRating = sum_rating / form.length
#  sum1 = 0
#  for ele in form
#    sum1 += ele.vol*ele.vol
#  CF = sum1/form.length
#  sum2 = 0
#  for ele in form
#    sum2 += (ele.rating-aveRating)*(ele.rating-aveRating)
#  CF += sum2/(form.length-1)
#  CF = Math.sqrt(CF)
#
#  Erank = calcERank(form[ARank-1], form)
#  Eperf = calcEperf(Erank, form)
#  Aperf = calcAperf(ARank, form)
#  PerfAs = calcPerAs(form[ARank-1].rating, Aperf, Eperf,CF)
#  weight = calcWeight(n)
#
#  CAP = calcCap(n)
#
#  oldRating = form[ARank-1].rating
#  newRating = (oldRating+weight*PerfAs)/(1+weight)
#
#  if Math.abs(newRating-oldRating) > CAP
#    k = -1
#    k = 1 if newRating > oldRating
#    newRating = oldRating+k*CAP
#
#  if ARank is 1 and parseInt(newRating) <= parseInt(oldRating)
#    newRating = oldRating+1
#
#  if newRating < 0
#    newRating=0
#
#  oldVol = form[ARank-1].vol
#  newVol = Math.sqrt( (newRating-oldRating)*(newRating-oldRating)/weight+oldVol*oldVol/(weight+1) )
#
#  return {
#    newRating : newRating
#    newVol : newVol
#  }
#
#
#calc = (results, num = 50)->
#  rating = (INIT_RATING for i in [0...num])
#  vol = (INIT_VOL for i in [0...num])
#  cnt = (0 for i in [0...num])
#  for j in [0...results.length]
#    contest = results[j]
#    form = []
#    for id in contest
#      if id >= num
#        console.log "There is an invalid id in contest[#{j}]. "
#        alert "There is an invalid id in contest[#{j}]. "
#        return []
#      form.push(
#        rating : rating[id]
#        vol : vol[id]
#        id : id
#      )
#    for i in [0...form.length]
#      ++cnt[form[i].id]
#      ARank = i+1
#      res = update(ARank, form, cnt[form[i].id])
#      ele = form[i]
#      rating[ele.id] = res.newRating
#      vol[ele.id] = res.newVol
#  return rating
#
#@build = (contests, teamName)->
#  rating =  calc(contests, teamName.length)
#  res = []
#  for r,i in rating
#    ele = {
#      rating : r
#      teamName : teamName[i]
#    }
#    res.push(ele)
#  res.sort(
#    (a,b)->
#      if a.rating < b.rating
#        return 1
#      return -1
#  )
#  return res
INIT_RATING = 1000
INIT_VOL = 400
qnorm = (p) ->
  p = parseFloat(p)
  split = 0.42
  a0 = 2.50662823884
  a1 = -18.61500062529
  a2 = 41.39119773534
  a3 = -25.44106049637
  b1 = -8.47351093090
  b2 = 23.08336743743
  b3 = -21.06224101826
  b4 = 3.13082909833
  c0 = -2.78718931138
  c1 = -2.29796479134
  c2 = 4.85014127135
  c3 = 2.32121276858
  d1 = 3.54388924762
  d2 = 1.63706781897
  q = p - 0.5
  if Math.abs(q) <= split
    r = q * q
    ppnd = q * (((a3 * r + a2) * r + a1) * r + a0) / ((((b4 * r + b3) * r + b2) * r + b1) * r + 1)
  else
    r = p
    if q > 0
      r = 1 - p
    if r > 0
      r = Math.sqrt(-Math.log(r))
      ppnd = (((c3 * r + c2) * r + c1) * r + c0) / ((d2 * r + d1) * r + 1)
      if q < 0
        ppnd = -ppnd
    else
      ppnd = 0
  ppnd

erf = (x) ->
  a1 = 0.254829592
  a2 = -0.284496736
  a3 = 1.421413741
  a4 = -1.453152027
  a5 = 1.061405429
  p = 0.3275911
  # Save the sign of x
  sign = 1
  if x < 0
    sign = -1
  x = Math.abs(x)
  # A&S formula 7.1.26
  t = 1.0 / (1.0 + p * x)
  y = 1.0 - (((((a5 * t + a4) * t + a3) * t + a2) * t + a1) * t * Math.exp(-x * x))
  sign * y

calcERank = (x, form)->
  res = 0
  for ele in form
    res += calcWP(x, ele)
  res + 0.5


calcWP = (x, y) ->
  (erf((y.rating-x.rating)/Math.sqrt(2*(y.vol*y.vol+x.vol*x.vol)))+1)*0.5


calcEperf = (ERank, form) ->
  -qnorm((ERank-0.5)/form.length)

calcAperf = (ARank, form) ->
  -qnorm((ARank-0.5)/form.length)

calcPerAs = (oldRating, Aperf, Eperf, CF)->
  oldRating+CF*(Aperf-Eperf)

calcWeight = (n)->
  1/(0.82-0.42/n)-1

calcCap = (n)->
  150+1500/(n+1)

#ARank 要计算的是排名为多少的队伍
#form 积分表格，抽象为rating,vol，下标从0开始
#n 第几场比赛了

#Return {object}
# newRating
# newVol

update = (order, form, n)->
  ARank = form[order].rank
#Error
  if ARank<=0 or ARank>form.length
    return -1;
  if form.length <= 1
    return -1
  #calc CF
  sum_rating = 0
  for ele in form
    sum_rating += ele.rating
  aveRating = sum_rating / form.length
  sum1 = 0
  for ele in form
    sum1 += ele.vol*ele.vol
  CF = sum1/form.length
  sum2 = 0
  for ele in form
    sum2 += (ele.rating-aveRating)*(ele.rating-aveRating)
  CF += sum2/(form.length-1)
  CF = Math.sqrt(CF)

  Erank = calcERank(form[order], form)
  Eperf = calcEperf(Erank, form)
  Aperf = calcAperf(ARank, form)
  PerfAs = calcPerAs(form[order].rating, Aperf, Eperf,CF)
  weight = calcWeight(n)

  CAP = calcCap(n)

  oldRating = form[order].rating
  newRating = (oldRating+weight*PerfAs)/(1+weight)

  if Math.abs(newRating-oldRating) > CAP
    k = -1
    k = 1 if newRating > oldRating
    newRating = oldRating+k*CAP

  if ARank is 1 and parseInt(newRating) <= parseInt(oldRating)
    newRating = oldRating+1

  if newRating < 0
    newRating=0

  oldVol = form[ARank-1].vol
  newVol = Math.sqrt( (newRating-oldRating)*(newRating-oldRating)/weight+oldVol*oldVol/(weight+1) )

  return {
    newRating : newRating
    newVol : newVol
  }


calc = (results, num = 50)->
  rating = (INIT_RATING for i in [0...num]) #每个队的Rating
  vol = (INIT_VOL for i in [0...num]) #每个队的波动值
  cnt = (0 for i in [0...num]) #积分积了几次
  for j in [0...results.length]
    ranks = results[j]
    #console.log ranks
    form = []
    for rank,id in ranks
      if id >= num
        console.log "There is an invalid id in contest[#{j}]. "
        alert "There is an invalid id in contest[#{j}]. "
        return []
      if rank is -1 #-1意味着没有参战
        continue
      form.push(
        rating : rating[id]
        vol : vol[id]
        id : id
        rank : rank
      )
    for i in [0...form.length]
      ++cnt[form[i].id]
      res = update(i, form, cnt[form[i].id])
      ele = form[i]
      rating[ele.id] = res.newRating
      vol[ele.id] = res.newVol
      @series[ele.id].data.push res.newRating
  return rating

@build = (ranks, teamName)->
  @series = []
  for ele in teamName
    @series.push(
      name:ele
      data:[]
    )
  rating =  calc(ranks, teamName.length)
  res = []
  for r,i in rating
    ele = {
      rating : r
      teamName : teamName[i]
    }
    res.push(ele)
  res.sort(
    (a,b)->
      if a.rating < b.rating
        return 1
      return -1
  )
  return res

#module.exports = @build