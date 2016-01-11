OJ4TH 表站
==============

#介绍

本项目为北航在线编程教学平台，本网站没有管理功能只有正常使用功能，一般与管理站点配合使用。

#安装说明

##安装操作系统和所需软件

本平台建议安装在 Linux 操作系统上，推荐Ubuntu，同时需要安装以下软件：

 - MySql v5.5 或以上
 - Node.js v5.4 或以上
 - Redis v3.0 或以上
 - Git v2.7或以上

以上请去官网下载或者直接apt-get。

或者执行如下shell指令：

```
apt-get update
apt-get upgrade -y
apt-get install build-essential -y
apt-get install git -y
apt-get install curl -y
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
apt-get update
apt-get install -y nodejs -y
apt-get install redis-server
apt-get install mysql-server
```

##创建数据库

创建数据库，建议使用`utf-8`编码，建议执行如下SQL指令：

```SQL
CREATE SCHEMA `OJ4TH` DEFAULT CHARACTER SET utf8;
```

在`config.js`中进行数据库条目修改，填写数据库名称，地址，用户名，密码。

##安装依赖库

在项目目录下执行如下指令：

```
npm install
npm install bower -g
bower install
```

##启动

确保数据库服务器，redis服务器正常运行情况下使用npm start来启动服务器，默认端口为3000。

在浏览器中直接访问http://localhost:3000即可。

可以使用Nginx进行反向代理。

**注意**：启动会自动创建数据库内容，或者您可以手动运行`dbsync.js`

```
node dbsync.js
```

也可以导入现有的数据库

