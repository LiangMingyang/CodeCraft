function renderCode(s)
{
	s = s.split("\r\n").join("\n");

	comment			= {color:"green", bold:false, italic:false, name:"comment"}
	precompiler		= {color:"blue", bold:false, italic:false, name:"pre"}
	operator		= {color:"#FF00FF", bold:true, italic:false, name:"operator"}
	stringLiteral	= {color:"green", bold:false, italic:false, name:"string"}
	charLiteral		= {color:"green", bold:false, italic:false, name:"char"}
	intLiteral		= {color:"#CC3300", bold:false, italic:false, name:"int"}
	floatLiteral	= {color:"#CC3300", bold:false, italic:false, name:"float"}
	boolLiteral		= {color:"#CC3300", bold:false,  italic:false, name:"bool"}
	types			= {color:"blue", bold:true, italic:false, name:"type"}
	flowControl		= {color:"#0000FF", bold:true, italic:false, name:"flow"}
	keyword			= {color:"#0000FF", bold:true, italic:false, name:"keyword"}

	keys = new Array()
	keys.push({style:comment, start:/\s*\/\*[\s\S]*?\*\//mg})
	keys.push({style:comment, start:/\s*\/\//mg, end:/\n/mg, neglect:/\\|\?\?\//mg})
	keys.push({style:precompiler, start:/\s*?^\s*(?:#|\?\?=|%:)/mg, end:/\n/m, neglect:/\\[\s\S]|\?\?\/[\s\S]/m})
	keys.push({style:stringLiteral, start:/\s*(?:\bL)?"/mg, end:/"/m, neglect:/\\[\s\S]|\?\?\/[\s\S]/m})
	keys.push({style:charLiteral, start:/\s*(?:\bL)?'/mg, end:/'/m, neglect:/\\[\s\S]|\?\?\/[\s\S]/m})
	keys.push({style:floatLiteral, start:/\s*(?:(?:\b\d+\.\d*|\.\d+)(?:E[\+\-]?\d+)?|\b\d+E[\+\-]?\d+)[FL]?\b|\s*\b\d+\./mgi})
	keys.push({style:intLiteral, start:/\s*\b(?:0[0-7]*|[1-9]\d*|0x[\dA-F]+)(?:UL?|LU?)?\b/mgi})
	keys.push({style:boolLiteral, start:/\s*\b(?:true|false)\b/mg})
	keys.push({style:types, start:/\s*\b(?:bool|char|double|float|int|long|short|signed|unsigned|void|wchar_t|__int64)\b/mg})
	keys.push({style:flowControl, start:/\s*\b(?:break|case|catch|continue|default|do|else|for|goto|if|return|switch|throw|try|while)\b/mg})
	keys.push({style:keyword, start:/\s*\b(?:asm|auto|class|const_cast|const|delete|dynamic_cast|enum|explicit|export|extern|friend|inline|main|mutable|namespace|new|operator|private|protected|public|register|reinterpret_cast|sizeof|static_cast|static|struct|template|this|typedef|typeid|typename|union|using|virtual|volatile|and_eq|and|bitand|bitor|compl|not_eq|not|or_eq|or|xor_eq|xor|__asm|__fastcall|__based|__cdecl|__pascal|__inline|__multiple_inheritance|__single_inheritance|__virtual_inheritance)\b/mg})
	keys.push({style:operator, start:/\s*[\{\}\[\]\(\)<>%:;\.\?\*\+\-\^&\|~!=,\\]+|\s*\//mg})

	for(var i = 0; i != keys.length; ++i)
	{
		keys[i].before = ""
		if (keys[i].style.bold) keys[i].before += "<b>"
		if (keys[i].style.italic) keys[i].before += "<i>"
		keys[i].before += "<font color=\"" + keys[i].style.color + "\">"
		keys[i].after = "</font>"
		if (keys[i].style.italic) keys[i].after += "</i>"
		if (keys[i].style.bold) keys[i].after += "</b>"
	}

	var keyString = "";
	var match = 0;
	var strResult = "";

	strResult = "";

	var previousMatch = -1;
	for(var i = 0; i != keys.length; ++i)
		keys[i].startPos = -1;

	for(var position = 0; position != s.length; position = keys[match].endPos)
	{
		for (var i = 0; i != keys.length; ++i)
		{
			if(keys[i].startPos < position)
			{
				// update needed
				keys[i].start.lastIndex = position;
				var result = keys[i].start.exec(s);
				if(result != null)
				{
					keys[i].startPos = result.index;
					keys[i].endPos = keys[i].start.lastIndex;
				}
				else
					keys[i].startPos = keys[i].endPos = s.length
			}
		}
		match = 0;
		for(var i = 1; i < keys.length; ++i) // find first matching key
			if(keys[i].startPos < keys[match].startPos)
				match = i;
		if(keys[match].end != undefined)
		{
			// end must be found
			var end = new RegExp(keys[match].end.source + "|" + keys[match].neglect.source, "mg");
			end.lastIndex = keys[match].endPos;
			while(keys[match].endPos != s.length)
			{
				result = end.exec(s);
				if(result != null)
				{
					if(result[0].search(keys[match].end) == 0)
					{
						keys[match].endPos = end.lastIndex;
						break;
					}
				}
				else keys[match].endPos = s.length;
			}
		}
		var before = s.substring(position, keys[match].startPos);
		keyString = s.substring(keys[match].startPos, keys[match].endPos);
		var output = "";
		if((before == "") && (match == previousMatch))
			output += toHTML(keyString);
		else
		{
			if(previousMatch != -1) output += keys[previousMatch].after;
			output += toHTML(before);
			if(keyString != "")
				output += keys[match].before + toHTML(keyString);
		}
		previousMatch = match;
		strResult += output;
	}
	if (keyString != "") strResult += keys[match].after;

	return strResult;
}


function copyCode(obj)
{
	var rng = document.body.createTextRange();
	rng.moveToElementText(obj);
	rng.select();
	rng.execCommand("Copy");
}

function saveCode(obj, filename)
{
	var winname = window.open('', '_blank', 'top=10000');
	winname.document.open('text/html', 'replace');
	winname.document.writeln(obj.value);
	winname.document.execCommand('saveas','', filename);
	winname.close();
}

function toHTML(s)
{
	s = s.split("&").join("&amp;");
	s = s.split("<").join("&lt;");
	return s.split(">").join("&gt;");
}



//copy code and this can support firefox
function newcopyCode(txt)
{
	//support ie
	if( window.clipboardData )
	{
		window.clipboardData.clearData();
		window.clipboardData.setData("Text", txt);
	}else
	//opera
	if( navigator.userAgent.indexOf("Opera") != -1 )
	{
		window.location = txt;
	}else
	//firefox
	if( window.netscape )
	{
		//xpcom
		try
		{
			netscape.security.PrivilegeManager.enablePrivilege( "UniversalXPConnect" );
		}catch( errors )
		{
			alert( "±»ä¯ÀÀÆ÷¾Ü¾ø£¡\nÇëÄãÔÚä¯ÀÀÆ÷µØÖ·À¸ÖÐÊäÈë'about:config'²¢ÇÒ»Ø³µ\nÈ»ºó½«'signed.applets.codebase_principal.support'ÉèÖÃÎªtrue\nÈç¹ûÄãÏëÊ¹ÓÃÕâ¸ö¸´ÖÆ¹¦ÄÜµÄ»°£¬ÄÇÃ´×îºÃÕâÃ´ÉèÖÃ^_^|||");
		}
		var clip = Components.classes['@mozilla.org/widget/clipboard;1'].createInstance( Components.interfaces.nsIClipboard );
		if( !clip ) return ;
		var trans = Components.classes['@mozilla.org/widget/transferable;1'].createInstance( Components.interfaces.nsITransferable );
		if( !trans ) return ;
		trans.addDataFlavor( "text/unicode" );
		var str = new Object();
		var len = new Object();
		var str = Components.classes['@mozilla.org/supports-string;1'].createInstance( Components.interfaces.nsISupportsString );
		var copytext = txt;
		str.data = copytext;
		trans.setTransferData("text/unicode", str, copytext.length * 2);
		var clipid = Components.interfaces.nsIClipboard;
		if( !clip )
			return false;
		clip.setData( trans, null, clipid.kGlobalClipboard );
	}
	//alert("Copy Successful!");
}
