package  {
	
	import flash.display.MovieClip;
	
	
	public class Dplane extends MovieClip {
		public var mm:MM=new MM;
		public static var mybullet:Array=new Array;
		public var nx:Number;
		public var ny:Number;
		var vx:Number;
		var vy:Number;
		var frame1:Number;
		public var tt:Number=0;
		var nn:Plane;
		var rand1:Number;
		public function Dplane(nx:Number,ny:Number,vx:Number,vy:Number,frame:Number) {
			// constructor code
			this.nx=nx;
			this.ny=ny;
			this.vx=vx;
			this.vy=vy;
			this.x=nx;
			this.y=ny;
			this.frame1=frame;
			this.mask=mm;
			mm.width=32;
			mm.height=32;
			mm.x=nx;
			mm.y=ny;
			rand1=Math.floor((Math.random()*40+30));
		}
		public function Dmove():void{
				nx+=vx;
				ny+=vy;
				x=nx-frame1*32;
				y=ny;
				mm.x=nx;
				mm.y=ny;
				tt++;
				if(tt%rand1==0){
					nn=this.parent.getChildByName("npc")as Plane;
					var mb:bullet=new bullet(0,0);
					mb.x=nx+16;
					mb.y=ny+16;
					var detal:Number
					=Math.atan2(mb.y-(nn.ny+16),mb.x-(nn.nx+16));
					mb.vx=-8*Math.cos(detal);
					mb.vy=-8*Math.sin(detal);
					mb.rotation=detal*180/Math.PI-90;
					this.parent.addChild(mb);
					mybullet.push(mb);
					}
				if(tt%30==0){
					nn=this.parent.getChildByName("npc")as Plane;
					if(nx>nn.nx){
						vx=-3;
						}
					else{
						vx=3;
						}
					if(ny>nn.ny){
						vy=-3;
						}
					else{
						vy=3;
						}	
						if(vx>0&&vy<0){
							frame1=1;
							}
						if(vx>0&&vy>0){
							frame1=3;
							}
						if(vx<0&&vy<0){
							frame1=7;
							}
						if(vx<0&&vy>0){
							frame1=5;
							}
					}
			}
	}
	
}
