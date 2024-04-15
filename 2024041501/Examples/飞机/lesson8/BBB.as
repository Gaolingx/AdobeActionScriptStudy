package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class BBB extends MovieClip {
		
		public  var isfire:Boolean=false;
		public function BBB() {
			// constructor code
			this.y=550;
			this.addEventListener(Event.ENTER_FRAME,go);
			}
		function go(e:Event):void{
			if(isfire){
				this.y-=5;
				if(this.y<-100){
					isfire=false;
					this.y=550
					}
				}	
			}
	}
	
}
