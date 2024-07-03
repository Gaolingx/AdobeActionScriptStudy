package classes
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.events.Event;
	
	public class myStage extends MovieClip
	{
		//定义一组物品类型的数据
		private var m_bGame:Boolean;			//是否在游戏
		private var m_aObjects:Array;
		private var m_nIndex:int;				//被钩住的物体编号
		private var m_nTime:int;				//记录当前时间
		private var m_nScore:int;				//记录当前分数
		private var m_nObjectScore:int;			//记录目标分数
		private var m_getGoldSoundName:String = "Sound_GetGold.mp3";

		public function myStage()
		{
			btnPlay.addEventListener(MouseEvent.CLICK, playGame);
			stop();
		}
		public static function playSound(path:String, length:Number, times:Number):void
		{
			var snd:Sound = new Sound(new URLRequest(path));
			snd.play(length, times);
		}
		public function playGame(e:MouseEvent):void
		{	
			gotoAndPlay(2);
			stop();
			m_aObjects = new Array(12);
			
			m_nObjectScore = 1000;
			T_ObjectScore.text = "" + m_nObjectScore;
			
			Reset();
			this.stage.addEventListener( MouseEvent.MOUSE_UP,onMouseUpEvent );
			
			var myTimer:Timer = new Timer(50, 0);
			myTimer.addEventListener("timer", timerHandler );
			myTimer.start();
		}
		public function Reset()
		{
			for( var i:int = 0; i < m_aObjects.length; i ++ )
			{
				if( m_aObjects[i] != null )
				{
					this.removeChild( m_aObjects[i] ); 
				}
				m_aObjects[i] = null;
				var type:int = int(  Math.random() * myObject.OBJECT_TYPE_NUM  );
				if( type < myObject.OBJECT_TYPE_OBJECT_NUM　)
				{
					m_aObjects[i] = new myObject();
				}
				else
				{
					m_aObjects[i] = new Monster();
				}
				m_aObjects[i].setType(type);
				m_aObjects[i].x = 100 + Math.random() * 1080;
				m_aObjects[i].y = 300 + Math.random() * 600;
				this.addChild( m_aObjects[i] );
			}
			m_nIndex　= - 1;
			T_Win.visible = false;
			T_Lost.visible = false;
			m_nTime = 1200;
			m_nScore = 0;
			m_bGame = true;
		}
		public function onMouseUpEvent( e:MouseEvent ):void
		{
			if( m_bGame == false )
			{
				Reset();
				return;
			}
			T_Miner.SendHook();
		}
		public function timerHandler(e:TimerEvent):void
		{
			if( m_bGame == false )
				return;
			var getObject:myObject = null;
			if( m_nIndex != - 1 )
			{
				getObject = m_aObjects[m_nIndex];
			}
			if( T_Miner.Logic(getObject) == true )
			{
				m_nScore = m_nScore + m_aObjects[m_nIndex].getScore();
				myStage.playSound(m_getGoldSoundName, 0, 1);
				this.removeChild( m_aObjects[m_nIndex] );
				m_aObjects[m_nIndex] = null;
				m_nIndex = -1;
			}
			for( var i:int = 0; i < m_aObjects.length; i ++ )
			{
				if( m_aObjects[i] == null )
					continue;
				if( i == m_nIndex )
					continue;
				m_aObjects[i].Logic();
				if( T_Miner.getObject( m_aObjects[i] ) == true )
				{
					m_nIndex　= i;
				}
			}
			T_Score.text = "" + m_nScore;
			T_Time.text = "" + int(m_nTime * 0.05);
			m_nTime --;
			if( m_nTime <= 0 )
			{
				m_bGame = false;
				if( m_nScore > m_nObjectScore )
				{
					T_Win.visible = true;
				}
				else
				{
					T_Lost.visible = true;
				}
			}
			
		}
	}
}