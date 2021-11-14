#Persistent
OnClipboardChange("ClipChanged")
return
#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
Thread, Interrupt ,0

~LButton Up::
Send ^{c}
ClipChanged() {
    youdao:
    Edit1 := Clipboard
    LV_Modify(3,"COL2","正在翻译...")
    LV_Modify(3,"COL2","")
    SetTimer,youdao,Off
    Url=http://fanyi.youdao.com/translate?smartresult=dict&smartresult=rule&smartresult=ugc&sessionFrom=null
    postdata=type=AUTO&i=%Edit1%&doctype=json&xmlVersion=1.4&keyfrom=fanyi.web&ue=UTF-8&typoResult=true&flag=false
    youdaoreText:= byteToStr(WinHttp(Url,"POST",postdata),"utf-8")
     
    NeedleRegEx=O)tgt":"(.*?)"
    FoundPos:=RegExMatch(youdaoreText,NeedleRegEx,OutMatch)
    youdaoValue:=(ErrorLevel) ? :OutMatch.Value(1)
    NeedleRegEx=O)entries":["","(.*?)"
    FoundPos:=RegExMatch(youdaoreText,NeedleRegEx,OutMatch)
    youdaoValue.=(! ErrorLevel and OutMatch.Value(1)="") ? :
    LV_Modify(3,"COL2",youdaoValue)
    LV_ModifyCol(2,"AutoHdr")
    #Persistent
    ToolTip, %youdaoValue%
    SetTimer, RemoveToolTip, -5000
    return

    RemoveToolTip:
    ToolTip
    return
    return 
}

WinHttp(Httpurl,Httpmode="GET",Httppostdata=""){
StringUpper Httpmode,Httpmode
;~ XMLHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
XMLHTTP := ComObjCreate("Microsoft.XMLHTTP")
XMLHTTP.open(Httpmode,Httpurl,false)
XMLHTTP.setRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20100101 Firefox/11.0")
if Httpmode=POST
{
XMLHTTP.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
XMLHTTP.send(Httppostdata)
}else
XMLHTTP.send()
;~ return XMLHTTP.responseText
return XMLHTTP.ResponseBody
}
 
;将原始数据流以指定的编码的形式读出
byteToStr(body, charset){
Stream := ComObjCreate("Adodb.Stream")
Stream.Type := 1
Stream.Mode := 3
Stream.Open()
Stream.Write(body)
Stream.Position := 0
Stream.Type := 2
Stream.Charset := charset
str := Stream.ReadText()
Stream.Close()
return str
}
