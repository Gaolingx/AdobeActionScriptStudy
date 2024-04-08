package  {
	
	import flash.display.MovieClip;
	
	
	public class GameLogic extends MovieClip {
		
		public var nodeArray:Array=new Array;
		public function GameLogic() {
			// constructor code
		}
		public function initArray(row:Number,col:Number):void{
			nodeArray.splice(0,nodeArray.length);
			for(var i:Number=0;i<row*col;i++){
				nodeArray.push(0);
				}
			}
		public function createBomb(count:Number):void{
			for(var i:Number=0;i<count;){
				var row:Number=Math.floor(Math.random()*30);
				var col:Number=Math.floor(Math.random()*30);
				if(nodeArray[row*30+col]==0){
					nodeArray[row*30+col]=9;
					i++;
					}
				}
			}
			
		public function fillArray():void{
			var count:Number;
			for(var row:Number=0;row<30;row++)
			for(var col:Number=0;col<30;col++){
				if(nodeArray[row*30+col]==0){
				count=0;
				if(row>0&&nodeArray[(row-1)*30+col]==9)count++;
				if(row<29&&nodeArray[(row+1)*30+col]==9)count++;
				if(col>0&&nodeArray[(row)*30+col-1]==9)count++;
				if(col<29&&nodeArray[(row)*30+col+1]==9)count++;
				
				if(row>0&&col>0&&nodeArray[(row-1)*30+col-1]==9)count++;
				if(row<29&&col<29&&nodeArray[(row+1)*30+col+1]==9)count++;
				if(col>0&&row<29&&nodeArray[(row+1)*30+col-1]==9)count++;
				if(col<29&&row>0&&nodeArray[(row-1)*30+col+1]==9)count++;
				nodeArray[row*30+col]=count;
				}
				}
			
			
			}
			
	public function isNum(row:Number,col:Number):void{
		
		nodeArray[row*30+col]+=10;
		}
	public function showMap():void{
		
		for(var i:Number=0;i<900;i++){
			nodeArray[i]+=10;
			}
		}	
	public function isBomb():void{
		
		for(var i:Number=0;i<900;i++){
			if(nodeArray[i]==9){
				nodeArray[i]=19;
				}
			}
		}
	public function isNull(row:Number,col:Number):void{
		nodeArray[row*30+col]+=10;
		if(row>0&&nodeArray[(row-1)*30+col]<10){
			if(nodeArray[(row-1)*30+col]!=0)isNum(row-1,col);
			else isNull(row-1,col);
			}
		if(row<29&&nodeArray[(row+1)*30+col]<10){
			if(nodeArray[(row+1)*30+col]!=0)isNum(row+1,col);
			else isNull(row+1,col);
			}
		if(col>0&&nodeArray[(row)*30+col-1]<10){
			if(nodeArray[(row)*30+col-1]!=0)isNum(row,col-1);
			else isNull(row,col-1);
			}
		if(col<29&&nodeArray[(row)*30+col+1]<10){
			if(nodeArray[(row)*30+col+1]!=0)isNum(row,col+1);
			else isNull(row,col+1);
			}
			
		
		if(row>0&&col>0&&nodeArray[(row-1)*30+col-1]<10){
			if(nodeArray[(row-1)*30+col-1]!=0)isNum(row-1,col-1);
			else isNull(row-1,col-1);
			}
		if(row<29&&col<29&&nodeArray[(row+1)*30+col+1]<10){
			if(nodeArray[(row+1)*30+col+1]!=0)isNum(row+1,col+1);
			else isNull(row+1,col+1);
			}
		if(col>0&&row<29&&nodeArray[(row+1)*30+col-1]<10){
			if(nodeArray[(row+1)*30+col-1]!=0)isNum(row+1,col-1);
			else isNull(row+1,col-1);
			}
		if(col<29&&row>0&&nodeArray[(row-1)*30+col+1]<10){
			if(nodeArray[(row-1)*30+col+1]!=0)isNum(row-1,col+1);
			else isNull(row-1,col+1);
			}
			
		}
	}//类
	
}//包
