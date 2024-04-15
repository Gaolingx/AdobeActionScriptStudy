package  {
	
	import flash.display.MovieClip;
	
	
	public class Bossb extends MovieClip {
		
		var nx:Number;
		var ny:Number;
		var vx:Number;
		var vy:Number;
		public var mm:MM=new MM;
		var frame:Number=0;
		public function Bossb(nx:Number,ny:Number,vx:Number,vy:Number) {
			// constructor code
			this.nx=nx;
			this.ny=ny;
			this.vx=vx;
			this.vy=vy;
			this.mask=mm;
			mm.width=6;
			mm.height=6;
		}
		public function moveB():void{
			nx+=vx;
			ny+=vy;
			frame=(frame+1)%2;
			x=nx-frame*6;
			y=ny;
			mm.x=nx;
			mm.y=ny;
			if(nx<-200||nx>1000||ny<-200||ny>1000){
			Boss.bulletArray.splice(Boss.bulletArray.indexOf(this),1);
			this.parent.removeChild(this.mm);
			this.parent.removeChild(this);
			}
			}
	}
	
}
