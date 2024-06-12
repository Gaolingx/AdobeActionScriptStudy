package  {
	
	import flash.display.MovieClip;
	import fl.motion.easing.Back;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Main extends MovieClip 
	{
		var count:int;//球的个数
		public function Main() 
		{
			//1、一次性
			//for(var i:int =0 ;i<100 ;i++)//添加100个球对象
//			{
//				var ball:Ball = new Ball();
//				this.addChild(ball);
//				ball.x = stage.stageWidth/2;
//				ball.y = stage.stageHeight/2;
//			}
			//2、分批次按计时器
			var timer:Timer = new Timer(0.3);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER,
				  createBall);
		}
		function createBall(evt:TimerEvent)
		{
			if(count >= 100)
				return;
			var ball:Ball = new Ball();
			this.addChild(ball);
			ball.x = stage.stageWidth/2;
			ball.y = stage.stageHeight/2;
			count++;//计数
		}
	}
}
