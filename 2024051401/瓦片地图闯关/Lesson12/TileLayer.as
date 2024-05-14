package 
{

	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.geom.Matrix;


	public class TileLayer extends MovieClip
	{
		public var mapArray:Array = new Array  ;
		public var blockWidth:Number = 0;
		public var blockHight:Number = 0;
		public var mapWidth:Number = 0;
		public var mapHight:Number = 0;
		public var bmd:BitmapData;
		public var loader:Loader = new Loader  ;
		public var imgWidth:Number;
		public var imgHight:Number;
		public var imgrow:Number;
		public var imgcol:Number;
		//public var childArray:Array=new Array;
		public var isOK:Boolean=false;
		public function TileLayer(mapArray:Array,blockWidth:Number,blockHight:Number,mapWidth:Number,mapHight:Number,u:String,imgWidth:Number,imgHight:Number)
		{
			// constructor code
			this.mapArray = mapArray;
			this.blockWidth = blockWidth;
			this.blockHight = blockHight;
			this.mapWidth = mapWidth;
			this.mapHight = mapHight;
			this.imgHight = imgHight;
			this.imgWidth = imgWidth;
			imgrow = imgHight / blockHight;
			imgcol = imgWidth / blockWidth;
			var url:URLRequest = new URLRequest(u);
			loader.load(url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,fill);
		}
		function fill(e:Event):void
		{

			for (var i:Number=0; i<mapWidth*mapHight; i++)
			{
				var row=Math.floor(i/mapWidth);
				var col = i % mapWidth;
				if (mapArray[i] != 0)
				{
					bmd = new BitmapData(blockWidth,blockHight,true,0x00000000);
					var r:Number=Math.floor((mapArray[i]-1)/imgcol);
					var c:Number=(mapArray[i]-1)%imgcol;
					var rect:Rectangle = new Rectangle(0,0,blockWidth,blockHight);
					var matrix:Matrix = new Matrix  ;
					matrix.translate(-c*blockWidth,-r*blockHight);
					bmd.draw(loader,matrix,null,null,rect,false);
					var btm:Bitmap = new Bitmap(bmd);
					btm.x = col * blockWidth;
					btm.y = row * blockHight;
					this.addChild(btm);
				}
			}
			isOK=true;
		}
		public function hitTest1(Npc:MovieClip):Boolean
		{
			var count :Number=this.numChildren;
			//var count:Number =childArray.length ;
			for (var i=0; i<count; i++)
			{
				var bb:Bitmap = this.getChildAt(i)as Bitmap;
				if(bb.hitTestObject(Npc)){return true;}
				
			}
			return false;
		}

	}

}