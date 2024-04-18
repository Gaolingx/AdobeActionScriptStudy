package  {
	
	import flash.display.MovieClip;
	
	
	public class coin extends MovieClip {
		public var type:Number;
		public function coin() {
			type=Math.floor(Math.random()*3)+1;
			gotoAndStop(type);
			this.x=Math.random()*500+20;
			this.y=-20;
			// constructor code
		}
		public function moveCoin():void{
			this.y+=5;
			}
	}
	
}
