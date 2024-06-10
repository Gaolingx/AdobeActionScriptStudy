package  
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class GameStart extends MovieClip 
	{
		public function GameStart() 
		{
			playbtn.addEventListener(MouseEvent.CLICK,
								 clickHandler);
			var main:Main = (Main)(this.parent);
			main.stop();//跳转到开始画面
			//this.stop();
		}
		function clickHandler(evt:MouseEvent)
		{
			var main:Main = (Main)(this.parent);
			main.gotoAndStop(2);//跳转到开始画面
		}
	}
}
