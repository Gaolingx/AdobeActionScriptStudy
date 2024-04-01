package  {
	
	import flash.display.MovieClip;
	
	
	public class Image extends MovieClip {
		
		public var numArray:Array;
		public var n1:Num1;
		public var n2:Num2;
		public var n3:Num3;
		public function Image() {
			numArray=new Array;
			
			n1=new Num1;
			n1.x=210;
			n1.y=250;
			n1.scaleX=0.4;
			n1.scaleY=0.4;
			this.addChild(n1);
			numArray.push(n1);
			
			n2=new Num2;
			n2.x=390;
			n2.y=150;
			n2.scaleX=0.4;
			n2.scaleY=0.4;
			this.addChild(n2);
			numArray.push(n2);
			
			n3=new Num3;
			n3.x=50;
			n3.y=310;
			n3.scaleX=0.4;
			n3.scaleY=0.4;
			this.addChild(n3);
			numArray.push(n3);
			// constructor code
		}
	}
	
}
