package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class EventHaldle 
	{
		//加载完毕回调
		public var onReady:String="RecorderOnReady";
		
		//麦克风允许事件
		public var onMicro:String;
		public var onMicroSupport:String;
		public var onMicroResult:String;
		
		//开始录音事件
		public var onStart:String;
		
		//结束录音事件
		public var onStop:String;
		
		//传回结果事件
		public var onResult:String;
		public var onEmpty:String;
		
		//进度事件
		public var onRecording:String;
		
		//清除
		public var onClear:String;
		
		//播放事件
		public var onPlay:String;
		public var onPausePlay:String;
		public var onStopPlay:String;
		//播放进度
		public var onPlaying:String;
		
		//比特率
		public var rate:int = 16000;
		
		public var reciveURL:String;
		
		public var debug:Boolean = false;
		
		public function EventHaldle() 
		{
			
		}
		
	}

}