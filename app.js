var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
//var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var config = require('./config');
var session = require('express-session');
var redisStore = require('connect-redis')(session);
var redis = require('ioredis');

var routes = require('./routes');

var app = express();

// session

app.use(session({
    secret: 'ojth',
    resave: false,
    saveUninitialized: true,
    store: new redisStore(),
    cookie: {maxAge: 1000 * 60 * 60 * 24} //null to create a browser-session
}));

// flash
app.use(require('express-flash')());

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(__dirname + '/public/favicon.ico'));
//app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', routes);
//app.use('/users', users);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// error handlers

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function (err, req, res) {
        res.status(err.status || 500);
        res.render('error', {
            message: err.message,
            error: err
        });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function (err, req, res) {
    res.status(err.status || 500);
    res.render('error', {
        message: err.message,
        error: {}
    });
});

global.db = require('./database')(
    config.database.name,
    config.database.username,
    config.database.password,
    config.database.config
);
global.config = config;
global.db.sync();
global.redis = new redis();
global.myUtils = require('./utils');
global.myErrors = require('./errors');
module.exports = app;
