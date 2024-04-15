package  {
	
	import flash.display.MovieClip;
	
	
	public class bullet extends MovieClip {
		
		public var vx:Number;
		public var vy:Number;
		public function bullet(vx:Number,vy:Number) {
			// constructor code
			this.vx=vx;
			this.vy=vy;
		}
		public function moveB():void{
				this.x+=vx;
				this.y+=vy;
			}
		
	}
	
}
