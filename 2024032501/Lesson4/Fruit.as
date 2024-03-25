package  {
	
	import flash.display.MovieClip;
	
	
	public class Fruit extends MovieClip {
		public var vx:Number;
		public var vy:Number;
		public function Fruit() {
			// constructor code
			
			vx=Math.random()*10+10;
			vy=Math.random()*10-25;
			var r=Math.random();
			if(r>0.5){
				this.x=-10;
				this.y=450;
				}
			else{
				this.x=560;
				this.y=450;
				this.vx*=-1;
				}	
		}
		public function moveFruit(){
			this.x+=this.vx;
			this.y+=this.vy;
			this.vy+=1;
			}
	}
	
}
