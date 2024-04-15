package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Boss extends MovieClip {
		var nx:Number;
		var ny:Number;
		public var mm:MM=new MM;
		public static var bulletArray:Array=new Array;
		public static var bombArray:Array=new Array;
		var vx:Number;
		var vy:Number;
		var direction1:Number;
		var frame:Number;
		var hp:Number;
		var moveState:Number;
		var attackState:Number;
		var tt:Number=0;
		var mt:Number=0;
		var bb:Bossb;
		var bomb:Bomb;
		var bvx:Number;
		var bvy:Number;
		public function Boss(nx:Number,ny:Number) {
			// constructor code
			
			mm.width=70;
			mm.height=70;
			this.mask=mm;
			this.nx=nx;
			this.ny=ny;
			x=this.nx;
			y=this.ny;
			direction1=0;
			frame=0;
			moveState=0;
			vx=5;
			vy=0;
			attackState=0;
			this.addEventListener(Event.ENTER_FRAME,BossGo);
		}
		function BossGo(e:Event):void{
			tt++;
			if(tt%2==0)
			frame=(frame+1)%4;
			x=nx-70*frame;
			y=ny-70*direction1;
			mm.x=nx;
			mm.y=ny;
			switch(moveState){
				case 0:
					mt++;
					nx+=vx;
					ny+=vy;
					if(nx<50||nx>470)vx*=-1;
					if(vx>0)direction1=2;
					else direction1=1;
					if(tt%15==0){
						attack(0);
						}
					if(mt%100==0){
						moveState=1;
						direction1=0;
						vx=0;
						vy=8;
						}
				break;
				case 1:
				nx+=vx;
				ny+=vy;
				if(tt%20==0){
					attack(1);
					}
				if(ny>550){
						moveState=2;
						direction1=3;
						vx=0;
						vy=-8;
						nx=Math.random()*300+100;
				}
				break;
				case 2:
				nx+=vx;
				ny+=vy;
				if(tt%20==0){
					attack(1);
					}
				if(ny<=50){
					moveState=0;
					vx=5;
					vy=0;
					ny=50;
					direction1=2;
					for(var j:Number=0;j<15;j++){
							bomb=new Bomb(nx+35+j*12-84,ny+10+Math.random()*40);
							bombArray.push(bomb);
							this.parent.addChild(bomb);
						}
					}
				break;
				}
			}
			
	 function attack(attackState):void{
		 	switch(attackState){
				case 0:
				for(var i:Number=0;i<5;i++){
						bb=new Bossb(nx+35,ny+50,-6+i*3,7);
						this.parent.addChild(bb);
						this.parent.addChild(bb.mm);
						bulletArray.push(bb);
					}
				break;
				case 1:
				for(var j:Number=0;j<18;j++){
					bvx=8*Math.cos(Math.PI/9*j);
					bvy=8*Math.sin(Math.PI/9*j);
					bb=new Bossb(nx+35,ny+35,bvx,bvy);
						this.parent.addChild(bb);
						this.parent.addChild(bb.mm);
						bulletArray.push(bb);
					}
				break;
				}
		 }
	}
	
}
