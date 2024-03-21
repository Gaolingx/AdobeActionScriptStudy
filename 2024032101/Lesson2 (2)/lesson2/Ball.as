package  {
	
	import flash.display.MovieClip;
	
	
	public class Ball extends MovieClip {
		public var vx:Number;
		public var vy:Number;
		public var hp:Number;
		public function Ball() {
			vx=Math.random()*21-10;
			vy=Math.random()*21-10;
			hp=5;
			// constructor code
		}
	}
	
}
