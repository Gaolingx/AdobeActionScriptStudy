package  
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SampleDataEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedMode;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Main extends Sprite 
	{
		private var layout_padding:Number = 10;
		
		private var logField:TextField;
		
		private var microphone:Microphone;
		private var soundBytes:ByteArray;
		private var isRecording:Boolean = false;
		
		private var sound:Sound;
		private var channel:SoundChannel;
		private var position:uint = 0;
		private var isPlaying:Boolean = false;
		
		//参数
		private var argument:EventHaldle = new EventHaldle();
		
		public function Main() 
		{
			super();
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//tf = new TextArea();
			logField = new TextField();
			logField.multiline = true;
			logField.x = layout_padding;
			logField.y = layout_padding;
			log( 'Microphone is supported ? '+Microphone.isSupported);
			addChild(logField);
			
			microphone = Microphone.getEnhancedMicrophone();
			if (!microphone) microphone = Microphone.getMicrophone();
			if(microphone){
				microphone.setSilenceLevel(5, 10000);
				microphone.gain = 50;
				microphone.rate = 44;
				var option:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
				option.autoGain = true;
				microphone.enhancedOptions = option;
				log('useEchoSuppression:'+ microphone.useEchoSuppression);
				microphone.addEventListener(StatusEvent.STATUS, mic_status);
			}
			soundBytes = new ByteArray();;
			sound = new Sound();
			
			initArgument();
			
			//注册事件
			if (ExternalInterface.available) {
				var id:String = ExternalInterface.objectID;
				//log('objectID:'+id);
				ExternalInterface.addCallback("Rcallback", callBack);
				ExternalInterface.addCallback("Rmicrosupport", checkMicroSupport);
				ExternalInterface.addCallback("Rmicro", checkMicro);
				ExternalInterface.addCallback("Rstart", startRecord);
				ExternalInterface.addCallback("Rstop", stopRecord);
				ExternalInterface.addCallback("Rsend", sendData);
				ExternalInterface.addCallback("Rplay", startPlay);
				ExternalInterface.addCallback("RstopPlay", stopPlay);
				ExternalInterface.addCallback("Rclear", clearRecord);
				//ExternalInterface.addCallback("play", startPlay);
			}
			
			
			stage.addEventListener(Event.RESIZE, resizer);
			stage.dispatchEvent(new Event(Event.RESIZE));
			if (ExternalInterface.available) {
				ExternalInterface.call(argument.onReady);
			}
		}
		
		private function initArgument():void {
			var args:Object = stage.loaderInfo.parameters;
			if (args.onReady) {
				argument.onReady = args.onReady;
			}
			if (args.reciveURL) {
				argument.reciveURL = args.reciveURL;
			}
		}
		
		private function callBack(arg:String,func:String):void {
			switch(arg.toLowerCase()) {
				case "onready":
					argument.onReady = func;
					break;
				case "onmicro":
					argument.onMicro = func;
					break;
				case "onmicrosupport":
					argument.onMicroSupport = func;
					break;
				case "onmicroresult":
					argument.onMicroResult = func;
					break;
				case "onstop":
					argument.onStop = func;
					break;
				case "onstart":
					argument.onStart = func;
					break;
				case "onresult":
					argument.onResult = func;
					break;
				case "onrecording":
					argument.onRecording = func;
					break;
				case "onclear":
					argument.onClear = func;
					break;
				case "onplay":
					argument.onPlay = func;
					break;
				case "onpauseplay":
					argument.onPausePlay = func;
					break;
				case "onstopplay":
					argument.onStopPlay = func;
					break;
				case "onplaying":
					argument.onPlaying = func;
					break;
				case "rate":
					argument.rate = parseInt(func);
					break;
				case "debug":
					argument.debug = func=="1";
					break;
				case "reciveurl":
					argument.reciveURL = func;
					break;
			}
		}
		
		private function checkMicroSupport():void {
			ExternalInterface.call(argument.onMicroSupport,microphone && Microphone.isSupported);
		}
		
		private function checkMicro():void {
			log('检测麦克风====');
			startRecord();
			setTimeout(checkMicroResult, 400);
			
		}
		private function checkMicroResult():void {
			var volume:int = microphone.activityLevel;
			log('音量:'+volume);
			stopRecord();
			clearRecord();
			log('检测结束=====');
			ExternalInterface.call(argument.onMicro, volume >= 0);
			if (volume < 0) {
				log('建议您在此处点击右键=>设置 中启用勾选记住，并启用音频设备！',true);
			}
		}
		
		private function mic_status(evt:StatusEvent):void {
			log('Microphone is muted?: ' + microphone.muted);
			switch (evt.code) {
				case "Microphone.Unmuted":
					log('Microphone access was allowed.');
					ExternalInterface.call(argument.onMicroResult,true);
					break;
				case "Microphone.Muted":
					log('Microphone access was denied.');
					ExternalInterface.call(argument.onMicroResult,false);
					break;
			}
		}
		
		private function record(e:SampleDataEvent):void {
			//trace(e.data.length);
			while(e.data.bytesAvailable)
				soundBytes.writeFloat(e.data.readFloat());
			setTime();
			//trace(soundBytes.length)
		}
		
		public function startRecord(e:MouseEvent=null):void {
			//trace(e);
			if (soundBytes.length > 0) {
				log('继续录音.');
			}else{
				log('开始录音.');
			}
			isRecording = true;
			microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, record);
			ExternalInterface.call(argument.onStart);
		}
		public function stopRecord(e:MouseEvent=null):void {
			//trace(e);
			log('停止录音.');
			isRecording = false;
			if (microphone.hasEventListener(SampleDataEvent.SAMPLE_DATA)) {
				microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, record);
			}
			soundBytes.position = 0;
			ExternalInterface.call(argument.onStop);
		}
		public function clearRecord(e:MouseEvent=null):void {
			//trace(e);
			log('清除录音.');
			isRecording = false;
			if (microphone.hasEventListener(SampleDataEvent.SAMPLE_DATA)) {
				microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, record);
			}
			soundBytes.clear();
			ExternalInterface.call(argument.onClear);
		}
		public function saveRecord(e:MouseEvent=null):void {
			//trace(e);
			log('保存录音.');
			
			new FileReference().save(generFileData(),"recorder.wav");
		}
		
		private function generFileData():ByteArray {
			var bin:ByteArray = new ByteArray();
			var rate:uint = argument.rate;//16000;// 44100;
			var bits:uint = 16;
			var channels:uint = 1;
			var data:ByteArray = encodeBytes(soundBytes,rate);
			
			bin.endian = Endian.LITTLE_ENDIAN;
			bin.writeUTFBytes( 'RIFF' );
			bin.writeInt( uint( data.length + 44 ) );
			bin.writeUTFBytes( 'WAVE' );
			bin.writeUTFBytes( 'fmt ' );
			bin.writeInt( uint( 16 ) );
			bin.writeShort( uint( 1 ) );
			bin.writeShort( channels );
			bin.writeInt( rate );
			bin.writeInt( uint( rate * channels * ( bits / 8 ) ) );
			bin.writeShort( uint( channels * bits / 8 ) );
			bin.writeShort( bits );
			bin.writeUTFBytes( 'data' );
			bin.writeInt( data.length );
			bin.writeBytes( data );
			bin.position = 0;
			return bin;
		}
		
		//11025, 22050, 44100
		private function encodeBytes( bytes:ByteArray, rate:uint=44100 , volume:int=1):ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			buffer.endian = Endian.LITTLE_ENDIAN;
			var isplay:Boolean = isPlaying;
			if (isplay) {
				pausePlay();
			}
			position = bytes.position;
			
			bytes.position = 0;
			
			//wav采样 
			var fullrate:uint = 44100;
			var readed:uint = 0;
			var sipled:uint = 0;
			while ( bytes.bytesAvailable ) {
				
				readed += 4;
				
				if(sipled/readed < rate/fullrate){
					buffer.writeShort( bytes.readFloat() * (0x7fff * volume) );
					sipled += 4;
				}else {
					bytes.readFloat();
				}
				
				if (readed >= fullrate) {
					sipled = 0;
					readed = 0;
				}
			}
			bytes.position = position;
			if (isplay) {
				startPlay();
			}
			return buffer;
		}
		
		//播放数据写入
		private function writeData(e:SampleDataEvent):void {
			drawProgress();
			for (var i:int = 0; i < 8192 && soundBytes.bytesAvailable > 0; i++) 
			{
				var sample:Number = soundBytes.readFloat(); 
				e.data.writeFloat(sample); 
				e.data.writeFloat(sample); 
			}
			position = soundBytes.position;
			//trace('playing:',sample);
		}
		
		public function startPlay(e:MouseEvent=null):void {
			trace(e);
			if (soundBytes.length > 0) {
				if (isRecording) {
					stopRecord();
				}
				if (soundBytes.position > 0) {
					log('继续播放.');
				}else{
					log('开始播放.');
				}
				if (channel) {
					if (channel.hasEventListener(Event.SOUND_COMPLETE))
						channel.removeEventListener(Event.SOUND_COMPLETE, playOver);
					channel.stop();
				}
				isPlaying = true;
				sound.addEventListener(SampleDataEvent.SAMPLE_DATA, writeData);
				//sound.addEventListener(ProgressEvent.PROGRESS, drawProgress);
				channel = sound.play();
				channel.addEventListener(Event.SOUND_COMPLETE, playOver);
				ExternalInterface.call(argument.onPlay);
			}else {
				log('请先录音.');
			}
		}
		public function pausePlay(e:MouseEvent=null):void {
			//trace(e);
			log('暂停播放.');
			isPlaying = false;
			sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, writeData);
			channel.stop();
			ExternalInterface.call(argument.onPausePlay);
		}
		public function stopPlay(e:MouseEvent=null):void {
			//trace(e);
			log('停止播放.');
			sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, writeData);
			channel.stop();
			playOver();
			ExternalInterface.call(argument.onStopPlay);
		}
		
		public function playOver(e:Event=null):void {
			//trace(e);
			log('播放完成.');
			isPlaying = false;
			if (channel.hasEventListener(Event.SOUND_COMPLETE))
				channel.removeEventListener(Event.SOUND_COMPLETE, playOver);
			soundBytes.position = 0;
			position = 0;
			drawProgress();
			ExternalInterface.call(argument.onStopPlay);
		}
		
		public function sendData(e:Event = null):void {
			log('当前录音字节数:'+soundBytes.length);
			if (soundBytes.length < 11000) {
				ExternalInterface.call(argument.onEmpty);
				return;
			}
			//generFileData();
			doSendData(encodeBytes(soundBytes, argument.rate));
		}
		
		public function uploadData(e:Event = null):void {
			var f:FileReference = new FileReference();
			f.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void {
				log(e.text);
			});
			f.addEventListener(Event.SELECT, function(e:Event):void
			{
				log('选择文件:'+f.name);
				f.load();
			});
			f.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				doSendData(f.data);
			});
			f.browse([new FileFilter("Audios", "*.wav;*.pcm")]);
		}
		
		//发送数据
		public function doSendData(data:ByteArray):void {
			//var str:ByteArray = new ByteArray();
			var url:String = argument.reciveURL;//'http://test.api.hcicloud.com:8880/asr/Recognise';
			
			var myPost:URLRequest = new URLRequest(url);
			myPost.method = URLRequestMethod.POST;
			myPost.contentType = 'application/octet-stream';// 'multipart/form-data';
			myPost.requestHeaders.push(new URLRequestHeader("Content-Type", "text/xml"));
            myPost.requestHeaders.push(new URLRequestHeader("charset", "utf-8"));
            /*myPost.requestHeaders.push(new URLRequestHeader("x-app-key", "f85d54fd"));
            myPost.requestHeaders.push(new URLRequestHeader("x-sdk-version", "3.6"));
			
			//
            var date:String = new Date().toLocaleString();
            myPost.requestHeaders.push(new URLRequestHeader("x-request-date", date));
            myPost.requestHeaders.push(new URLRequestHeader("x-task-config", "capkey=asr.cloud.freetalk"));
            myPost.requestHeaders.push(new URLRequestHeader("x-task-config", "audioformat=pcm16k16bit"));
            var str:String = date + "bb72f6aaf265774bb246a542b68756b5";
            myPost.requestHeaders.push(new URLRequestHeader("x-session-key", MD5.hash(str)));
            myPost.requestHeaders.push(new URLRequestHeader("x-udid", "101:123456789"));*/
			
			//直接提交二进制数据,转换String会出错
			data.position = 0;
			myPost.data = data;///data.readMultiByte(data.length, 'iso-8859-1');
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(e:SecurityErrorEvent):void {
				log(e.text);
			});
			loader.addEventListener(ProgressEvent.PROGRESS, function(e:ProgressEvent):void {
				log(String(e.bytesLoaded/e.bytesTotal));
			});
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				log(loader.data.replace(/^\s+|\s+$/g,''));
				var xml:XML = XML(loader.data);
				log('解析字数:' + xml.ResultCount);
				var rst:String = String(xml.Result.Text) || String(xml.Result.ResultText)
				ExternalInterface.call(argument.onResult,rst,String(xml));
			});
			//loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(e:HTTPStatusEvent):void {
			//	log(e.text);
			//});
			loader.load(myPost);
            //pcm16k16bit   16k 16bit 录音数据（默认）
			//ulaw16k8bit 16k 8bit u-law 数据
			//alaw16k8bit 16k 8bit a-law 数
			//speex speex 压缩格
		}
		
		private function drawProgress():void {
			var l:uint = soundBytes.length;
			ExternalInterface.call(argument.onPlaying,position/l);
		}
		
		private function setTime():void {
			var time:uint = Math.round(soundBytes.length / 44100 / 4);
			if (argument.onRecording) {
				//log('录音时间:'+time+',音量:'+microphone.activityLevel);
				ExternalInterface.call(argument.onRecording,time,microphone.activityLevel);
			}
		}
		
		private function log(msg:String,m:Boolean=false):void {
			//tf.appendText(msg + '\n');
			if (this.argument.debug || m){
				logField.appendText(msg + '\n');
			}
		}
		
		private function resizer(event:Event = null):void {
			//drawProgress();
			//setTime();
			
			logField.width = stage.stageWidth - layout_padding * 2;
			logField.height = stage.stageHeight - layout_padding * 2;
		}
		
	}

}