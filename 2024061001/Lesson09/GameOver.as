package  {
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class GameOver extends MovieClip 
	{
		public function GameOver() 
		{
			btnPlay.addEventListener(MouseEvent.CLICK,
								  clickHandler);
		}
		function clickHandler(evt:MouseEvent)
		{
			var main:Main = (Main)(this.parent);
			main.gotoAndStop(1);//跳转到开始画面
		}
	}
}
