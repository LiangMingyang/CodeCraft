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


exports.Error = {
  UnknownUser : UnknownUser
  LoginError  : LoginError
  RegisterError : RegisterError
  InvalidAccess : InvalidAccess
  UpdateError : UpdateError
}


exports.findContests = (req) ->
  Contest = global.db.models.contest
  User = global.db.models.user
  currentUser = undefined
  global.db.Promise.resolve()
  .then ->
    User.find req.session.user.id if req.session.user
  .then (user)->
    return [] if not user
    currentUser = user
    user.getGroups()
  .then (groups)->
    normalGroups = (group.id for group in groups when group.membership.access_level isnt 'verifying')
    adminGroups = (group.id for group in groups when group.membership.access_level in ['owner','admin'])
    Contest.findAll({
      where :
        $or:[
          creator_id : currentUser.id  if currentUser #������û��Ǵ����߿��Կ�����
        ,
          access_level : 'public'    #public����Ŀ˭�����Կ�
        ,
          access_level : 'protect'   #������Ȩ����protect����ô������û���С���Ա�Ϳ��Կ���
          group_id : normalGroups
        ,
          access_level : 'private'  #����������Ȩ����private����ô������û���С�����Ա��ӵ���߾Ͷ����Կ���
          group_id : adminGroups
        ]
    })



