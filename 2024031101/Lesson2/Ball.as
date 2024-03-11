package  {
	
	import flash.display.MovieClip;
	
	
	public class Ball extends MovieClip {
		public var vx:Number;
		public var vy:Number;
		public var hp:Number;
		public function Ball() {
			// constructor code
			vx=Math.random()*21-10;
			vy=Math.random()*21-10;
			this.x=275;
			this.y=200;
			hp=5;
		}
	}
	
}
