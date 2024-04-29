package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class Black extends MovieClip {
		
		
		public function Black() {
			this.addEventListener(MouseEvent.CLICK,mc);
			// constructor code
		}
		public function mc(e:MouseEvent):void{
			
			if(GameData.currentLayer==(this.parent as Floor).layerID){
				GameData.gameTime+=500;
				GameData.lastLayerID++;
				var f:Floor=new Floor(GameData.lastLayerID);
				f.y=-200;
				this.parent.parent.addChild(f);
				GameData.floorArray.push(f);
				for(var i:Number=GameData.floorArray.length-1;i>0;i--){
					GameData.floorArray[i].x=GameData.floorArray[i-1].x;
					GameData.floorArray[i].y=GameData.floorArray[i-1].y;
					
					}
				this.parent.parent.removeChild(this.parent);
				GameData.floorArray.splice(0,1);
				GameData.currentLayer++;
				}
			}
	}
	
}
