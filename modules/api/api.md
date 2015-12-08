现有api接口
====
-------------------

[TOC]

#比赛

##获取比赛信息

- 方法: `GET`
- 路由: `/contests/:contestId`
- 发送参数:
- 返回结果:
    - status | {number}  : 2xx(成功)或者4xx(出错)
    - contest | {object} : 包括了contest的信息,若比赛已经开始则会返回所有关于problem的信息
    - error | {string}  : 如果出错则此处有错误信息

##获取用户在比赛中的所有提交

- 方法: `GET`
- 路由: `/contests/:contestId/submissions`
- 发送参数:
- 返回结果:
    - status | {number}  : 2xx(成功)或者4xx(出错)
    - submissions | {array} : 该用户所有的submission信息
    - error | {string}  : 如果出错则此处有错误信息
    
##用户提交代码

- 方法: `POST`
- 路由: `/contests/:contestId/submissions`
- 发送参数:
    - order | {number} : 题目
    - lang | {string} : 提交代码的语言
    - code | {string} : 提交的代码
- 返回结果:
    - status | {number}  : 2xx(成功)或者4xx(出错)
    - error | {string}  : 如果出错则此处有错误信息

##获取比赛排名

- 方法: `GET`
- 路由: `/contests/:contestId/rank`
- 发送参数:
- 返回结果:
    - status | {number}  : 2xx(成功)或者4xx(出错)
    - rank | {array} : 排名的每一个条目
    - error | {string}  : 如果出错则此处有错误信息
    
    
###获取当前用户信息

- 方法: `GET`
- 路由: `/users/me`
- 发送参数:
- 返回结果:
    - status | {number}  : 2xx(成功)或者4xx(出错)
    - user | {object} : 当前用户对象
    - error | {string}  : 如果出错则此处有错误信息

