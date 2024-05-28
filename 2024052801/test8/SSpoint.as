package
{
	import flash.geom.Point;
	
	

	public class SSpoint
	{
		var curPoint:Point;
		var perPoint:Point;
		var length:Number;
		var centerX:Number;
		var centerY:Number;
		var rotation:Number;
		public function SSpoint(c:Point,p:Point)
		{
			this.curPoint=c;
			this.perPoint=p;
			length=Point.distance(c,p);
			centerX=(c.x+p.x)/2;
			centerY=(c.y+p.y)/2;
			rotation=Math.atan2((c.y-p.y),(c.x-p.x));
		}
	}
}