<?php

$post = file_get_contents('php://input');
$errno = '';
$errstr = '';
$date=date("Y-m-d H:i:s");

$headers=array(
	'Accept'=>'text/xml',
	'charset'=>"utf-8",
	"x-app-key"=> "f85d54fd",
	"x-sdk-version"=> "3.6",
	"x-request-date"=>$date,
	"x-task-config"=> "capkey=asr.cloud.freetalk,capkey=audioformat=pcm16k16bit",
	"x-session-key"=>md5($date . "bb72f6aaf265774bb246a542b68756b5"),
	"x-udid"=> "101:123456789"
);

$length = strlen($post);
//创建socket连接
$fp = fsockopen("test.api.hcicloud.com",8880,$errno,$errstr,10) or exit($errstr."--->".$errno);
//构造post请求的头
$header  = "POST /asr/Recognise HTTP/1.1\r\n";
$header .= "Host: ".$_SERVER['HTTP_HOST']."\r\n";
$header .= "Connection: keep-alive\r\n";
$header .= "Referer: http://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI']."\r\n";
$header .= "Content-Type: application/octet-stream\r\n";
$header .= "Content-Length: ".$length."\r\n";
foreach($headers as $key=>$value){
	$header .= $key.": ".$value."\r\n";
	if($key=='x-task-config'){
		$header .= $key.": capkey=audioformat=pcm16k16bit\r\n";
	}
}


$header .= "\r\n";

//添加post的字符串
$header .= $post."\r\n";


//发送post的数据
fputs($fp,$header);
$inheader = 1;
while (!feof($fp)) {
	$line = fgets($fp,1024); //去除请求包的头只显示页面的返回数据
	if ($inheader && ($line == "\n" || $line == "\r\n")) {
		$inheader = 0;
	}
	if ($inheader == 0) {
		echo $line;
	}
}

fclose($fp);

