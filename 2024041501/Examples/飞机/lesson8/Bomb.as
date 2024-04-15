package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Bomb extends MovieClip {
		var time:Number;
		var t:Number=0;
		public function Bomb(x1:Number,y1:Number) {
			// constructor code
			this.x=x1;
			this.y=y1;
			time=Math.random()*30+30;
			this.addEventListener(Event.ENTER_FRAME,moveBomb);
			}
		public function moveBomb(e:Event):void{
			y+=5;
			t++;
			if(t>time){
				var fire:Fire=new Fire;
				fire.x=this.x;
				fire.y=this.y;
				this.parent.addChild(fire);
				Boss.bombArray.splice(Boss.bombArray.indexOf(this),1);
				this.parent.removeChild(this);
				this.removeEventListener(Event.ENTER_FRAME,moveBomb);
				}
			}	
	}
	
}
