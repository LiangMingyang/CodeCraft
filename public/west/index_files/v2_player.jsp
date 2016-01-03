
function InStr(strs) 
{ 
var str1 = window.location.href;
var ss = str1.indexOf(strs); 
return(ss); 
}
var str2="www.5etv.cn";
var str3="cwdpa.org.cn";

if ( InStr(str2) >= 0 )
{
document.write("<object id='ffplay'><embed name='ffplay' src='http://www.5etv.cn/video/v2oneplayer43.swf?fid=5959&flvfile=user/5959/2015101810484389293.mp4&imgfile=user/5959/2015101810484389293.jpg&s=www.5etv.cn&showCtrl=yes&start=no&playMode=0&soValue=80' width='210' height='165' allowFullScreen='true' align='middle' type='application/x-shockwave-flash'/></object>");
}
else 
{
     if ( InStr(str3) >= 0 )
	  {
        document.write("<object id='ffplay'><embed name='ffplay' src='http://www.5etv.cn/video/v2oneplayer43.swf?fid=5959&flvfile=user/5959/2015101810484389293.mp4&imgfile=user/5959/2015101810484389293.jpg&s=www.5etv.cn&showCtrl=yes&start=no&playMode=0&soValue=80' width='210' height='165' allowFullScreen='true' align='middle' type='application/x-shockwave-flash'/></object>");
      }
	  else
	  {
	    document.write(" ");
	  }
}
