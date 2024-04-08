package  {
	
	import flash.display.MovieClip;
	
	
	public class Node extends MovieClip {
		public var mm:MM;
		public var ii:Item;
		public var v:Number=0;
		public function Node() {
			// constructor code
			mm=new MM;
			ii=new Item;
			ii.mask=mm;
			mm.width=ii.width;
			mm.height=ii.height/16;
			this.addChild(ii);
			this.addChild(mm);
		}
		public function setValue(v:Number):void{
			
			this.v=v;
			this.ii.y=0-v*this.ii.height/16;
			
			}
	}
	
}
