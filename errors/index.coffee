class UnknownUser extends Error
  constructor: (@message = "请先登录") ->
    @name = 'UnknownUser'
    @status = 401
    Error.captureStackTrace(this, UnknownUser)

class UnknownGroup extends Error
  constructor: (@message = "小组不存在，或者你没有权限") ->
    @name = 'UnknownGroup'
    @status = 403
    Error.captureStackTrace(this, UnknownGroup)

class LoginError extends Error
  constructor: (@message = "用户名或密码错误") ->
    @name = 'LoginError'
    @status = 401
    Error.captureStackTrace(this, LoginError)

class RegisterError extends Error
  constructor: (@message = "注册信息有误") ->
    @name = 'RegisterError'
    @status = 400
    Error.captureStackTrace(this, RegisterError)

class InvalidAccess extends Error
  constructor: (@message = "做不到") ->
    @name = 'InvalidAccess'
    @status = 403
    Error.captureStackTrace(this, InvalidAccess)

class UpdateError extends Error
  constructor: (@message = "更新出错") ->
    @name = 'UpdateError'
    @status = 403
    Error.captureStackTrace(this, UpdateError)

class UnknownSubmission extends Error
  constructor: (@message = "提交记录不存在，或者你没有权限") ->
    @name = 'UnknownSubmission'
    @status = 403
    Error.captureStackTrace(this, UnknownSubmission)

class UnknownProblem extends Error
  constructor: (@message = "题目不存在，或者你没有权限") ->
    @name = 'UnknownProblem'
    @status = 403
    Error.captureStackTrace(this, UnknownProblem)

class InvalidFile extends Error
  constructor: (@message = "文件不存在，或者你没有权限") ->
    @name = 'InvalidFile'
    @status = 403
    Error.captureStackTrace(this, InvalidFile)

class UnknownJudge extends Error
  constructor: (@message = "评测机不合法") ->
    @name = 'UnknownJudge'
    @status = 403
    Error.captureStackTrace(this, UnknownJudge)

class UnknownContest extends Error
  constructor: (@message = "比赛不存在，或者你没有权限") ->
    @name = 'UnknownContest'
    @status = 403
    Error.captureStackTrace(this, UnknownContest)

module.exports = {
  UnknownUser : UnknownUser
  UnknownGroup : UnknownGroup
  UnknownContest : UnknownContest
  UnknownSubmission : UnknownSubmission
  UnknownProblem : UnknownProblem
  UnknownJudge : UnknownJudge
  LoginError  : LoginError
  RegisterError : RegisterError
  InvalidAccess : InvalidAccess
  UpdateError : UpdateError
  InvalidFile : InvalidFile
}