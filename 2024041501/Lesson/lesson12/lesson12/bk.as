package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class bk extends MovieClip {
		
		public var mm:MM=new MM;
		public var values:Number;
		public var rows:Number;
		public var col:Number;
		public var nx:Number;
		public var ny:Number;
		public function bk(values:Number,rows:Number,col:Number,nx:Number,ny:Number) {
			// constructor code
			mm.width=100;
			mm.height=75;
			this.mask=mm;
			this.values=values;
			this.rows=rows;
			this.col=col;
			this.nx=nx;
			this.ny=ny;
			this.alpha=0.5;
			mm.x=nx;
			mm.y=ny;
			x=nx-(values%4)*100;
			y=ny-Math.floor(values/4)*75;
			this.addEventListener(Event.ENTER_FRAME,cc);
		}
		public function cc(e:Event):void{
			x=nx-(values%4)*100;
			y=ny-Math.floor(values/4)*75;
			}
	}
	
}
