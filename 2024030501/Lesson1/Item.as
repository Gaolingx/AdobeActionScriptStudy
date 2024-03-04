package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Item extends MovieClip {
		
		
		public function Item() {//构造函数
		//1.跟类名相同
		//2.没有返回值
		//3.对象创建时自动调用
			// constructor code
			this.addEventListener(Event.ENTER_FRAME,go);
		}
		public function go(e:Event):void{
			this.rotation+=5;
			}
	}
	
}
