package  {
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	
	
	public class GameSprite extends MovieClip {
		var loader:Loader=new Loader;
		var bmd:BitmapData;
		var spriteWidth:Number;
		var spriteHight:Number;
		var bmap:Bitmap;
		var frameArray:Array=new Array;
		var frame:Number=0;
		var imageWidth:Number;
		var imageHight:Number;
		var col:Number;
		var row:Number;
		var matrix:Matrix=new Matrix;
		public function GameSprite(u:String,spriteWidth:Number,spriteHight:Number,imageWidth:Number,imageHight:Number) {
			this.spriteWidth=spriteWidth;
			this.spriteHight=spriteHight;
			var uu:URLRequest=new URLRequest(u);
			loader.load(uu);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,fill);
			this.imageHight=imageHight;
			this.imageWidth=imageWidth;
			row=Math.floor(imageHight/spriteHight);
			col=Math.floor(imageWidth/spriteWidth);
		}
		function fill(e:Event):void{
			bmd=new BitmapData(spriteWidth,spriteHight,true,0x00000000);
			matrix.translate(0,0);
			
			bmd.draw(loader,matrix,null,null,new Rectangle(0,0,spriteWidth,spriteHight),false);
			bmap=new Bitmap(bmd);
			
			addChild(bmap);
			this.addEventListener(Event.ENTER_FRAME,nextframe);
			}
		public function setframeArray(array:Array){
			frameArray.splice(0,frameArray.length);
			for(var i=0;i<array.length;i++){
				frameArray.push(array[i]);
				}
			}
		public function nextframe(e:Event):void{
			frame=(frame+1)%frameArray.length;
			var srow=Math.floor(frameArray[frame]/col);
			var scol=frameArray[frame]%col;
			removeChild(bmap);
			bmd=new BitmapData(spriteWidth,spriteHight,true,0x00000000);
			matrix=new Matrix;
			matrix.translate(-scol*spriteWidth,-srow*spriteHight);
			bmd.draw(loader,matrix,null,null,new Rectangle(0,0,spriteWidth,spriteHight),false);
			bmap=new Bitmap(bmd);
			addChild(bmap);
			}
	}
	
}
