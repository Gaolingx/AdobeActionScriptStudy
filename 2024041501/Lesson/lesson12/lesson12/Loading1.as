package  {
	
	import flash.display.MovieClip;
	
	
	public class Loading1 extends MovieClip {
		
		public var mm:MM=new MM;
		public function Loading1() {
			// constructor code
			this.mask=mm;
			mm.width=0;
			mm.height=this.height;
			
		}
	}
	
}
