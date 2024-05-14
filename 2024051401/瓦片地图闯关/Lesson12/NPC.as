package  {
	
	import flash.display.MovieClip;
	
	
	public class NPC extends GameSprite {
		var workL:Array=[0,1,2];
		var workR:Array=[3,4,5];
		var npcdirection=1;
		var count:Number=0;
		public function NPC(u:String,spriteWidth:Number,spriteHight:Number,imageWidth:Number,imageHight:Number) {
			// constructor code
			super(u,spriteWidth,spriteHight,imageWidth,imageHight);
			this.setframeArray(workR);
			
			
		}
		public function moveNpc():void{
			count++;
			if(npcdirection==1){
				this.x+=5;
				}else {
					this.x-=5;
					}
				if(count==50){
					count=0;
					npcdirection*=-1;
					if(npcdirection>0)
					this.setframeArray(workR);
					else 
					this.setframeArray(workL);
					}
			}
	}
	
}
