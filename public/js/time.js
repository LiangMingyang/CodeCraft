/**
 * Created by zp on 15-11-3.
 */
function change_time_into_date_time(data){
    data = new Date(data);
    var data_year = data.getFullYear();
    var data_month = data.getMonth() - 0 + 1;
    if (data_month < 10){data_month = "0" + data_month;}
    var data_date = data.getDate();
    if (data_date < 10){data_date = "0" + data_date;}
    var data_hour = data.getHours();
    if (data_hour < 10){data_hour = "0" + data_hour;}
    var data_minutes = data.getMinutes();
    if (data_minutes < 10){data_minutes = "0" + data_minutes;}
    var data_seconds = data.getSeconds();
    if (data_seconds < 10){data_seconds = "0" + data_seconds;}
    var str = data_year + "-" + data_month + "-" + data_date + " " + data_hour + ":" + data_minutes + ":" + data_seconds;
    return str;
}

function change_time_into_chinese_string_time(data){
    data = new Date(data);
    data = (data - data % 1000) / 1000;
    var data_seconds = data % 60;
    data = (data - data_seconds) / 60;
    var data_minutes = data % 60;
    data = (data - data_minutes) / 60;
    var data_hour = data % 24;
    data = (data - data_hour) / 24;
    var data_date = data;
    var str = "";
    if (data_date != 0){
        str += data_date + " 天 ";
        str += data_hour + " 小时";
    }else if(data_hour != 0 ){
        str += data_hour + " 小时 ";
        str += data_minutes + " 分钟";
    }else if(data_minutes != 0){
        str += data_minutes + " 分钟 ";
        str += data_seconds + " 秒";
    }else{
        str += data_seconds + " 秒";
    }
    str += "前";
    return str;
}