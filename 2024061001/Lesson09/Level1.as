package  
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.display.SimpleButton;

	public class Level1 extends MovieClip 
	{
		var count:int;//点击按钮的次数
		public function Level1() 
		{
			count = 0;
			A1.addEventListener(MouseEvent.CLICK,
								  clickHandler);
			A2.addEventListener(MouseEvent.CLICK,
								  clickHandler);
			B1.addEventListener(MouseEvent.CLICK,
								  clickHandler);
			B2.addEventListener(MouseEvent.CLICK,
								  clickHandler);
			C1.addEventListener(MouseEvent.CLICK,
								  clickHandler);
			C2.addEventListener(MouseEvent.CLICK,
								  clickHandler);
			D1.addEventListener(MouseEvent.CLICK,
								  clickHandler);
			D2.addEventListener(MouseEvent.CLICK,
								  clickHandler);
			E1.addEventListener(MouseEvent.CLICK,
								  clickHandler);
			E2.addEventListener(MouseEvent.CLICK,
								  clickHandler);
		}
		function clickHandler(evt:MouseEvent)
		{
			//1、获取当前按钮的名字
			var btnName:String = evt.target.name;
			//2、找到跟这个名字对应的另一个对象，譬如
			//你点击了A1这个对象，那么要找到A2这个对象
			var str1:String = btnName.charAt(0);//第1个字符
			var str2:String = btnName.charAt(1);//第2个字符
			
			if(str2 == "1")
				str2 = "2";
			else
				str2 = "1";
			//得到另一个成对的按钮的名字
			var otherBtnName:String = str1+str2;
			//3、得到这两个按钮的对象
			var btn1:SimpleButton = 
				(SimpleButton)(evt.target);
			var btn2:SimpleButton = 
				(SimpleButton)(this.getChildByName(otherBtnName));
			//4、在两个按钮的位置上画圈（在上面生成一个圈对象）
			var c1:Circle = new Circle();
			var c2:Circle = new Circle();
			this.addChild(c1);
			this.addChild(c2);
			c1.x = btn1.x;c1.y = btn1.y;//把圆圈的位置和按钮的
			c2.x = btn2.x;c2.y = btn2.y;//位置设置为相同
			c1.gotoAndPlay(2);//两个影片剪辑
			c2.gotoAndPlay(2);//播放
			// 5、去除掉成对的两个按钮
			this.removeChild(btn1);
			this.removeChild(btn2);
			// 6、开始统计次数，并判断是否已经完成游戏
			count++;
			if(count>=5)//胜利条件
			{
				var main:Main = (Main)(this.parent);
				main.gotoAndStop(3);//跳转到结束画面
			}
		}
	}
}
