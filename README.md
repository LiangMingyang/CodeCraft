# OJ4TH

##介绍

本项目为北航在线编程教学平台

##搭建步骤

###Ubuntu

- 安装mysql-server: apt-get install mysql-server
- 安装nodejs环境: 详细步骤参考[官网](https://nodejs.org/)
- 安装redis环境: apt-get install redis-server
- 安装必要的库，在项目目录下执行: npm install
- 使用mysql -u root -p 登录mysql，创建数据库，建议使用`utf-8`编码，如创建名为`OJ4TH`的数据库: CREATE SCHEMA `OJ4TH` DEFAULT CHARACTER SET utf8 ;
- 修改项目中config.js中的database项，填入数据库的用户名密码及其他配置项
- 确保数据库服务器，redis服务器正常运行情况下使用npm start来启动服务器，默认端口为3000

###windows

- 安装mysql-server: 去[官网](http://www.mysql.com/)下载并安装
- 安装nodejs环境: 详细步骤参考[官网](https://nodejs.org/)
- 安装redis环境: 去[官网](http://redis.io/)下载并安装
- 安装必要的库，在项目目录下执行: npm install
- 使用[workbench](http://dev.mysql.com/downloads/workbench/)创建数据库，建议使用`utf-8`编码
- 修改项目中config.js中的database项，填入数据库的用户名密码及其他配置项
- 确保数据库服务器，redis服务器正常运行情况下使用npm start来启动服务器，默认端口为3000



