package  
{
	import com.adobe.crypto.MD5;
	import fl.controls.Button;
	import fl.controls.ComboBox;
	import fl.controls.TextArea;
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
	
	/**
	 * 麦克风录音回放
	 * @author Shirne http://www.shirne.com/
	 */
	public class MicroTest extends Sprite 
	{
		private var layout_padding:Number = 10;
		
		private var record_box:Sprite;
		private var r_play:Button;
		private var r_stop:Button;
		private var r_clear:Button;
		private var r_save:Button;
		private var r_rate:ComboBox;
		
		private var play_box:Sprite;
		private var play:Button;
		private var pause:Button;
		private var stop:Button;
		private var send:Button;
		private var lsend:Button;
		
		private var tf:TextArea;
		
		private var progress:Sprite;
		private var totaltime:TextField;
		private var progheight:int = 12;
		
		private var microphone:Microphone;
		private var soundBytes:ByteArray;
		private var isRecording:Boolean = false;
		
		private var sound:Sound;
		private var channel:SoundChannel;
		private var position:uint = 0;
		private var isPlaying:Boolean = false;
		
		public function MicroTest() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			tf = new TextArea();
			log( 'Microphone is supported ? '+Microphone.isSupported);
			addChild(tf);
			
			microphone = Microphone.getEnhancedMicrophone();
			if (!microphone) microphone = Microphone.getMicrophone();
			microphone.setSilenceLevel(5, 10000);
			microphone.gain = 50;
			microphone.rate = 44;
			var option:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
			option.autoGain = true;
			microphone.enhancedOptions = option;
			log('useEchoSuppression:'+ microphone.useEchoSuppression);
			microphone.addEventListener(StatusEvent.STATUS, mic_status);
			soundBytes = new ByteArray();;
			sound = new Sound();
			
			progress = new Sprite();
			progress.x = layout_padding;
			progress.y = layout_padding;
			addChild(progress);
			totaltime = new TextField();
			totaltime.defaultTextFormat = new TextFormat(null, 10, 0);
			totaltime.autoSize = TextFieldAutoSize.LEFT;
			totaltime.y = -1;
			progress.addChild(totaltime);
			
			record_box = new Sprite;
			record_box.x = layout_padding;
			record_box.y = layout_padding*2 + progheight;
			addChild(record_box);
			
			r_play = createButton('开始录音',startRecord);
			r_play.x = layout_padding;
			record_box.addChild(r_play);
			r_stop = createButton('暂停录音',stopRecord);
			r_stop.x = r_play.x + r_play.width + layout_padding;
			record_box.addChild(r_stop);
			r_clear = createButton('清除录音',clearRecord);
			r_clear.x = r_stop.x + r_stop.width + layout_padding;
			record_box.addChild(r_clear);
			r_save = createButton('保存录音',saveRecord);
			r_save.x = r_clear.x + r_clear.width + layout_padding;
			record_box.addChild(r_save);
			r_rate = new ComboBox();
			r_rate.y = layout_padding;
			r_rate.addItem( { label:'默认采样率', data:44100 } );
			r_rate.addItem( { label:'11k', data:11025 } );
			r_rate.addItem( { label:'16k', data:16000 } );
			r_rate.addItem( { label:'22k', data:22050 } );
			r_rate.addItem( { label:'32k', data:32000 } );
			r_rate.addItem( { label:'44k', data:44100 } );
			r_rate.x = r_save.x + r_save.width + layout_padding;
			record_box.addChild(r_rate);
			
			play_box = new Sprite;
			play_box.x = layout_padding;
			addChild(play_box);
			
			play = createButton('播放',startPlay);
			play.x = layout_padding;
			play_box.addChild(play);
			pause = createButton('暂停',pausePlay);
			pause.x = play.x + play.width + layout_padding;
			play_box.addChild(pause);
			stop = createButton('停止',stopPlay);
			stop.x = pause.x + pause.width + layout_padding;
			play_box.addChild(stop);
			send = createButton('识别',sendData);
			send.x = stop.x + stop.width + layout_padding;
			play_box.addChild(send);
			lsend = createButton('上传识别',uploadData);
			lsend.x = send.x + send.width + layout_padding;
			play_box.addChild(lsend);
			
			
			stage.addEventListener(Event.RESIZE, resizer);
			stage.dispatchEvent(new Event(Event.RESIZE));
		}
		
		private function createButton(text:String,handle:Function):Button
		{
			var b:Button = new Button();
			b.label = text;
			b.addEventListener(MouseEvent.CLICK, handle);
			b.y = layout_padding;
			return b;
		}
		
		private function mic_status(evt:StatusEvent):void {
			log('Microphone is muted?: ' + microphone.muted);
			switch (evt.code) {
				case "Microphone.Unmuted":
					log('Microphone access was allowed.');
					break;
				case "Microphone.Muted":
					log('Microphone access was denied.');
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
		}
		public function stopRecord(e:MouseEvent=null):void {
			//trace(e);
			log('停止录音.');
			isRecording = false;
			if (microphone.hasEventListener(SampleDataEvent.SAMPLE_DATA)) {
				microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, record);
			}
			soundBytes.position = 0;
		}
		public function clearRecord(e:MouseEvent=null):void {
			//trace(e);
			log('清除录音.');
			isRecording = false;
			if (microphone.hasEventListener(SampleDataEvent.SAMPLE_DATA)) {
				microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, record);
			}
			soundBytes.clear();
		}
		public function saveRecord(e:MouseEvent=null):void {
			//trace(e);
			log('保存录音.');
			
			new FileReference().save(generFileData(),"recorder.wav");
		}
		
		private function generFileData():ByteArray {
			var bin:ByteArray = new ByteArray();
			var rate:uint = r_rate.selectedItem.data;//16000;// 44100;
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
		}
		public function stopPlay(e:MouseEvent=null):void {
			//trace(e);
			log('停止播放.');
			sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, writeData);
			channel.stop();
			playOver();
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
		}
		
		public function sendData(e:Event = null):void {
			
			//generFileData();
			doSendData(encodeBytes(soundBytes, r_rate.selectedItem.data));
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
			var url:String = 'http://test.api.hcicloud.com:8880/asr/Recognise';
			
			var myPost:URLRequest = new URLRequest(url);
			myPost.method = URLRequestMethod.POST;
			myPost.contentType = 'application/octet-stream';// 'multipart/form-data';
			//myPost.requestHeaders.push(new URLRequestHeader("Content-Type", "text/xml"));
            myPost.requestHeaders.push(new URLRequestHeader("charset", "utf-8"));
            myPost.requestHeaders.push(new URLRequestHeader("x-app-key", "f85d54fd"));
            myPost.requestHeaders.push(new URLRequestHeader("x-sdk-version", "3.6"));
			
			//
            var date:String = new Date().toLocaleString();
            myPost.requestHeaders.push(new URLRequestHeader("x-request-date", date));
            myPost.requestHeaders.push(new URLRequestHeader("x-task-config", "capkey=asr.cloud.freetalk"));
            myPost.requestHeaders.push(new URLRequestHeader("x-task-config", "audioformat=pcm16k16bit"));
            var str:String = date + "bb72f6aaf265774bb246a542b68756b5";
            myPost.requestHeaders.push(new URLRequestHeader("x-session-key", MD5.hash(str)));
            myPost.requestHeaders.push(new URLRequestHeader("x-udid", "101:123456789"));
			
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
				log(loader.data);
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
			var width:int = stage.stageWidth - layout_padding * 2;
			progress.graphics.clear();
			
			var l:uint = soundBytes.length;
			if (l>0 && position>0) {
				//progress.graphics.lineStyle(0);
				progress.graphics.beginFill(0, .2);
				progress.graphics.drawRect(0, 0, width * position/l, progheight);
				progress.graphics.endFill();
			}
			progress.graphics.lineStyle(1, 0, .5);
			progress.graphics.drawRect(0, 0, width, progheight);
		}
		
		private function setTime():void {
			var time:uint = Math.round(soundBytes.length/44100/4);
			totaltime.text = Math.floor(time / 60) + ':' + time % 60;
			totaltime.x = progress.width-totaltime.width - 5;
		}
		
		private function log(msg:String):void {
			tf.appendText(msg + '\n');
		}
		
		private function resizer(event:Event = null):void {
			drawProgress();
			setTime();
			record_box.graphics.clear();
			record_box.graphics.lineStyle(1, 0, .5);
			record_box.graphics.drawRect(0, 0, stage.stageWidth - layout_padding * 2, r_play.height + layout_padding * 2);
			
			play_box.graphics.clear();
			play_box.graphics.lineStyle(1, 0, .5);
			play_box.graphics.drawRect(0, 0, stage.stageWidth - layout_padding * 2, r_play.height + layout_padding * 2);
			
			play_box.y = record_box.y + r_play.height + layout_padding * 3;
			
			tf.x = layout_padding;
			tf.y = play_box.y + r_play.height + layout_padding * 3;
			tf.width = stage.stageWidth - layout_padding * 2;
			tf.height = stage.stageHeight - tf.y - layout_padding;
		}
		
	}

}