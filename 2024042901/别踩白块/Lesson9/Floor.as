package  {
	
	import flash.display.MovieClip;
	
	
	public class Floor extends MovieClip {
		
		public var layerID:Number;
		public function Floor(layerID:Number) {
			// constructor code
			this.layerID=layerID;
			var r:Number=Math.floor(Math.random()*6);
			for(var i:Number=0;i<6;i++){
				if(r==i){
					var b:Black=new Black;
					b.y=0;
					b.x=i*50;
					this.addChild(b);
					}
				else{
					var w:White=new White;
					w.y=0;
					w.x=i*50;
					this.addChild(w);
					
					}
				}
			
		}
	}
	
}
