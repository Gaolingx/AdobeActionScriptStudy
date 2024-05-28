package  {
	
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	
	public class Map extends MovieClip {
		
		public var bk:BitmapData;
		public var bmd:BitmapData;
		public var img:Bitmap;
		var loader1:Loader=new Loader;
		var loader2:Loader=new Loader;
		var url1:URLRequest;
		var url2:URLRequest;
		var imgWidth:Number;
		var imgHight:Number;
		public var isshow:Boolean=false;
		public var isdata:Boolean=false;
		public function Map(u1:String,u2:String,imgWidth:Number,imgHight:Number) {
			// constructor code
			url1=new URLRequest(u1);
			url2=new URLRequest(u2);
			loader1.load(url1);
			loader2.load(url2);
			loader1.contentLoaderInfo.addEventListener(Event.COMPLETE,showImg);
			loader2.contentLoaderInfo.addEventListener(Event.COMPLETE,bkdata);
			this.imgWidth=imgWidth;
			this.imgHight=imgHight;
		}
		function showImg(e:Event):void{
			bmd=new BitmapData(imgWidth,imgHight);
			bmd.draw(loader1);
			img=new Bitmap(bmd);
			addChild(img);
			isshow=true;
			}
		function bkdata(e:Event):void{
			bk=new BitmapData(imgWidth,imgHight);
			bk.draw(loader2);
			isdata=true;
			}
		public function jude(x1:Number,y1:Number):uint{
			
			return bk.getPixel(x1,y1);
			}
	}
	
}
