package  {
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Ball extends MovieClip 
	{
		var xp:Number;//在x方向上的速度
		var yp:Number;//在y方向上的速度
		public function Ball() 
		{
			//随机了一组速度
			xp = Math.random()*5;
			yp = Math.random()*5;			
			var sign:Number = Math.random();
			if(sign > 0.5)
				xp = xp*-1;
			sign = Math.random();
			if(sign >0.5)
				yp = yp*-1;
			//添加帧监听
			this.addEventListener(Event.ENTER_FRAME,
								  MoveBall);
		}
		function MoveBall(evt:Event)
		{
			//直线运动
			this.x += xp;
			this.y += yp;
			//反弹
			if(this.x >= stage.stageWidth - this.width/2 ||
			   this.x <= this.width/2)
			   xp = xp * -1;//速度取反
			
			if(this.y >= stage.stageHeight - this.height/2 ||
			   this.y <= this.height /2)
			   yp = yp * -1;
			
		}
	}
	
}
