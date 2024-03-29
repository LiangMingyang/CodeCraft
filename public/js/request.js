/**
 * Created by zp on 15-7-14.
 */

var request = {};
var request_time = 1000;
request.DEBUG = false;
request.exec_request = function (request_block) {
    var ajxa_block = {
        url: request_block.url,
        type: request_block.method == undefined ? "POST" : request_block.method,
        success: function (data) {
            if (request.DEBUG) {//如果是调试状态的话
                console.log("收到返回数据-----------");
                console.log("原请求:" + ajxa_block.url);
                console.log("返回数据:");
                console.log(data);
                console.log("end-------------------");
            }
            if (request_block.callback)request_block.callback(data);
        },
        error: function (data) {
            console.log("数据获取失败");
            if (request_block.callback)request_block.callback(data);
        }
    };
    if (request_block.data)ajxa_block.data = request_block.data;
    if (request.DEBUG) {//如果是调试状态的话
        console.log("新发送的请求-----------");
        console.log("请求:" + ajxa_block.url);
        console.log("方式:" + ajxa_block.type);
        console.log("数据:");
        console.log(ajxa_block.data);
        console.log("end-------------------");
    }
    $.ajax(ajxa_block);
};