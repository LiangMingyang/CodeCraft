class UnknownUser extends Error
  constructor: (@message = "Unknown user.") ->
    @name = 'UnknownUser'
    Error.captureStackTrace(this, UnknownUser)

class LoginError extends Error
  constructor: (@message = "Wrong password or username.") ->
    @name = 'LoginError'
    Error.captureStackTrace(this, LoginError)

class RegisterError extends Error
  constructor: (@message = "Unvalidated register message.") ->
    @name = 'LoginError'
    Error.captureStackTrace(this, LoginError)

class InvalidAccess extends Error
  constructor: (@message = "Invalid Access, please return") ->
    @name = 'InvalidAccess'
    Error.captureStackTrace(this, InvalidAccess)

class UpdateError extends Error
  constructor: (@message = "Unvalidated update message.") ->
    @name = 'UpdateError'
    Error.captureStackTrace(this, UpdateError)

class UnknownContest extends Error
  constructor: (@message = "Unknown contest.") ->
    @name = 'UnknownContest'
    Error.captureStackTrace(this, UnknownContest)


exports.Error = {
  UnknownUser : UnknownUser
  LoginError  : LoginError
  RegisterError : RegisterError
  InvalidAccess : InvalidAccess
  UpdateError : UpdateError
  UnknownContest : UnknownContest
}

exports.findContest = (user, contestID, include)->
  Contest = global.db.models.contest
  global.db.Promise.resolve()
  .then ->
    return [] if not user
    user.getGroups(
      attributes : ['id']
    )
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    adminGroups = (group.id for group in groups when group.membership.access_level in ['owner','admin'])
    Contest.find({
      where :
        $and:
          id : contestID
          $or:[
            creator_id : user.id  if user #如果该用户是创建者可以看到的
          ,
            access_level : 'public'    #public的题目谁都可以看
          ,
            access_level : 'protect'   #如果这个权限是protect，那么如果该用户是小组成员就可以看到
            group_id : normalGroups
          ,
            access_level : 'private'  #如果这个赛事权限是private，那么如果该用户是小组管理员或拥有者就都可以看到
            group_id : adminGroups
          ]
      include : include
    })

exports.lettersToNumber = (word)->
  res = 0
  for i in word
    res = res * 26 + (i.charCodeAt(0) - 65)
  return res

exports.numberToLetters = (num)->
  return 'A' if num is 0
  res = undefined
  while(num>0)
    res = String.fromCharCode(num%26 + 65) + res
    num = parseInt(num/26)
  return res
