package  {
	
	import flash.display.MovieClip;
	
	
	public class LayerManager extends MovieClip {
		
		
		public function LayerManager() {
			// constructor code
		}
		public function moveLayer(x1:Number,y1:Number):void{
			this.x+=x1;
			this.y+=y1;
			}
	}
	
}
