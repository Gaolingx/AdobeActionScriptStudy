package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;

	
	
	public class Plane extends MovieClip {
		
		var frame:Number=0;
		public var frameArray:Array=new Array;
		public var type:Number=0;
		public var mm:MM=new MM;
		
		public var nx:Number;
		public var ny:Number;
		public function Plane(nx:Number,ny:Number) {
			// constructor code
			mm.width=32;
			mm.height=32;
			this.mask=mm;
			this.nx=nx;
			this.ny=ny;
			this.x=nx;
			this.y=ny;
			mm.x=nx;
			mm.y=ny;
			frameArray.push(3);
			this.addEventListener(Event.ENTER_FRAME,changePlane);
			
		}
		public function turnLeftFrame():void{
				frameArray.splice(0,frameArray.length);
				frameArray.push(3);
				frameArray.push(2);
				frameArray.push(1);
				frameArray.push(0);
				//frameArray.push(7);
			}
		public function turnRightFrame():void{
				frameArray.splice(0,frameArray.length);
				frameArray.push(3);
				frameArray.push(4);
				frameArray.push(5);
				frameArray.push(6);
				//frameArray.push(7);
			}
		function changePlane(e:Event):void{
				y=ny-this.type*32;
				frame=(frame+1)%frameArray.length;
				x=nx-frameArray[frame]*32;
			}
		
	}
	
}
