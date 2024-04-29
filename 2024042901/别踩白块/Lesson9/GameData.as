package  {
	
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.events.SampleDataEvent;
	import flash.utils.ByteArray;
	
	
	public class GameData extends MovieClip {
		public static var floorArray:Array=new Array;
		public static var gameTime:Number=5000;
		public static var lastLayerID:Number=0;
		public static var currentLayer:Number=0;
		public var soundName:String=new String;
		public var mySound:Sound=new Sound;
		public var url:URLRequest;
		public static var msc:SoundChannel=new SoundChannel;
		public var otherSound:Sound=new Sound;
		public function GameData(soundName:String) {
			url=new URLRequest(soundName);
			mySound.load(url);
			mySound.addEventListener(Event.COMPLETE,pp);
			// constructor code
		}
		function pp(e:Event):void{
			otherSound.addEventListener(SampleDataEvent.SAMPLE_DATA, 
										processSound);
			msc=otherSound.play();
			
			}
		function processSound(event:SampleDataEvent):void 
		{ 
        var bytes:ByteArray = new ByteArray(); 
        mySound.extract(bytes, 8192); 
        event.data.writeBytes(upOctave(bytes)); 
		} 
		function upOctave(bytes:ByteArray):ByteArray 
		{ 
    	var returnBytes:ByteArray = new ByteArray(); 
    	bytes.position = 0; 
    	while(bytes.bytesAvailable > 0) 
    	{ 
        returnBytes.writeFloat(bytes.readFloat()); 
        returnBytes.writeFloat(bytes.readFloat()); 
        if (bytes.bytesAvailable > 0) 
        { 
            bytes.position +=8; 
			//trace(bytes.position)
        } 
    } 
    return returnBytes; 
	}	
	
	
	
	}
	
}
