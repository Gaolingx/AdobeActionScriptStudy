package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class White extends MovieClip {
		
		
		public function White() {
			stop();
			this.addEventListener(MouseEvent.CLICK,mc);
			// constructor code
		}
		public function mc(e:MouseEvent):void{
			if(GameData.currentLayer==(this.parent as Floor).layerID)
			{
				gotoAndStop(2);
				GameData.currentLayer=-1;
				GameData.msc.stop();
			}
			
			
			}
	}
	
}
