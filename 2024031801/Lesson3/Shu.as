package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class Shu extends MovieClip {
		
		public var gameTime:Number=0;
		public function Shu() {
			this.stop();
			this.alpha=0.5;
			this.x=Math.random()*450+50;
			this.y=Math.random()*300+50;
			
			this.addEventListener(Event.ENTER_FRAME,go);
			this.addEventListener(MouseEvent.CLICK,mc);
			// constructor code
		}
		function mc(e:MouseEvent):void{
			this.play();
			this.removeEventListener(MouseEvent.CLICK,mc);
			}
		function go(e:Event):void{
			gameTime++;
			if(gameTime>=100){
				GameDate.src-=3;
				this.parent.removeChild(this);
				this.removeEventListener(Event.ENTER_FRAME,go);
				}
				
			if(this.currentFrame==15){
				GameDate.src+=5;
				this.parent.removeChild(this);
				this.removeEventListener(Event.ENTER_FRAME,go);
				}	
			}
		
	}
	
}
