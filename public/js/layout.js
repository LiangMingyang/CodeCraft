/**
 * Created by zp on 15-10-15.
 */
function change_time_into_string_time(data){
    data = new Date(data);
    var seconds = data.getSeconds();
    if(seconds < 10){seconds = "0" + seconds;}
    var minutes = data.getMinutes();
    if(minutes < 10){minutes = "0" + minutes;}
    var hours = data.getTime();
    hours = (hours - hours % 3600000) / 3600000;
    var sss = hours + ":" + minutes + ":" + seconds;
    return sss;
}

function change_number_into_order(num){
    var order_sss = "";
    if(num==0)
        order_sss = "A";
    while(num>0){
        order_sss = String.fromCharCode(num%26+65) + order_sss;
        num = parseInt(num/26);
    }
    return order_sss;
}

function rank_onLoad(rank_js_array,length_of_problem) {
    if (rank_js_array != "") {
        var oddEvenTable = "odd";
        var colorOfTable = "red";
        var my_tr = "";
        var time_of_penalty;
        var order_of_problem;
        for (var i = 0; i < rank_js_array.length; i++) {
            if(i % 2 == 1) {
                oddEvenTable = "odd";
            }else{
                oddEvenTable = "even";
            }
            colorOfTable = "white";
            time_of_penalty = change_time_into_string_time(rank_js_array[i].penalty);
            order_of_problem = "";
            my_tr += "<tr id='tr" + i + "' class='text-center " + oddEvenTable + colorOfTable +
                "tr'><td>" + (i + 1) + "</td><td><a href='/user/" + rank_js_array[i].user.id + "/index'>" + rank_js_array[i].user.nickname + "</a></td><td>" +
                rank_js_array[i].score + "</td><td>" + time_of_penalty + "</td>";
            for(var j = 0;j < length_of_problem;j++){
                if(i % 2 == 1) {
                    oddEvenTable = "odd";
                }else{
                    oddEvenTable = "even";
                }
                order_of_problem = change_number_into_order(j);
                if(!rank_js_array[i].detail[order_of_problem]){
                    colorOfTable = "white";
                }else if(rank_js_array[i].detail[order_of_problem].result == "AC"){
                    colorOfTable = "green";
                }else if(rank_js_array[i].detail[order_of_problem].score > 0){
                    colorOfTable = "blue";
                }else{
                    colorOfTable = "red";
                }
                if(rank_js_array[i].detail[order_of_problem] && rank_js_array[i].detail[order_of_problem].score > 0 && rank_js_array[i].detail[order_of_problem] && rank_js_array[i].detail[order_of_problem].wrong_count != 0){
                    time_of_penalty = change_time_into_string_time(rank_js_array[i].detail[order_of_problem].accepted_time) + "(-" + rank_js_array[i].detail[order_of_problem].wrong_count + ")";
                }else if(rank_js_array[i].detail[order_of_problem] && rank_js_array[i].detail[order_of_problem].result == "AC" && rank_js_array[i].detail[order_of_problem]){
                    time_of_penalty = change_time_into_string_time(rank_js_array[i].detail[order_of_problem].accepted_time);
                }else if(rank_js_array[i].detail[order_of_problem] && rank_js_array[i].detail[order_of_problem].wrong_count != 0){
                    time_of_penalty = "(-" + rank_js_array[i].detail[order_of_problem].wrong_count + ")";
                }else{
                    time_of_penalty = "";
                }
                if(rank_js_array[i].detail[order_of_problem] && rank_js_array[i].detail[order_of_problem].first_blood)
                    oddEvenTable = "yixie";
                my_tr += "<td id='td-" + i + "-" + j + "' class='" + oddEvenTable + colorOfTable + "td'>" + time_of_penalty + "</td>";
            }
            my_tr += "</tr>";
        }
        $("#table_of_rank").append(my_tr);
    }
}