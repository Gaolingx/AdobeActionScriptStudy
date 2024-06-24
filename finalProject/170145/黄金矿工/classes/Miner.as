package classes
{
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class Miner extends MovieClip
	{
		//定义一组状态类型的数据
		public static var MINER_STATE_NORMAL:int		= 0;	//正常状态
		public static var MINER_STATE_SEND:int			= 1;	//放线
		public static var MINER_STATE_RECV:int			= 2;	//收线
		private var m_nState:int;								//状态类型
		private var m_bHookTurnRight:Boolean;					//钩线向右旋转的标志
		private var m_fHookAngle:Number;						//钩线当前角度
		private var m_LineMC:MovieClip;
		private var m_oldPx:Number;
		private var m_oldPy:Number;
		private var m_moveLen:Number;
		
		public function Miner()
		{
			setState( MINER_STATE_NORMAL );
			m_bHookTurnRight = true;
			m_fHookAngle = 0.0;
			
			m_LineMC = new MovieClip();
			this.addChild(m_LineMC);
			
			m_oldPx = T_Hook.x;
			m_oldPy = T_Hook.y;
			m_moveLen = 0;
			
			
	    }
		public function setState( sta:int )
		{
			m_nState = sta;
			switch( m_nState )
			{
			case MINER_STATE_NORMAL:
				stop();
				break;
			default:
				play();
			}
		}
		public function getState():int
		{
			return m_nState;
		}
		public function Logic( getObject:myObject ):Boolean
		{
			var R = false;
			switch( m_nState )
			{
			case MINER_STATE_NORMAL:
				if( m_bHookTurnRight == true )
				{
					T_Hook.rotationZ = T_Hook.rotationZ - 4;
					if( T_Hook.rotationZ < -80 )
					{
						m_bHookTurnRight = false;
					}
				}
				else
				{
					T_Hook.rotationZ = T_Hook.rotationZ + 4;
					if( T_Hook.rotationZ > 80 )
					{
						m_bHookTurnRight = true;
					}
				}
				break;
			case MINER_STATE_SEND:
			
				m_moveLen = m_moveLen + 10;
				DrawHookAndLine();
				
				if( m_moveLen > 1000 )
				{
					setState( MINER_STATE_RECV );
				}
				break;
			
				break;
			case MINER_STATE_RECV:
				m_moveLen = m_moveLen - 20;
				DrawHookAndLine();
				
				if( getObject != null )
				{
					var arc = -T_Hook.rotationZ * Math.PI / 180;
					var hx:Number = T_Hook.x + 50 *  Math.sin(arc);
					var hy:Number = T_Hook.y + 50 *  Math.cos(arc);
			
					var point:Point = new Point();
					point.x = hx;
					point.y = hy
					point = this.localToGlobal(point);
					getObject.x = point.x;
					getObject.y = point.y;
				}
				
				if( m_moveLen <= 0 )
				{
					m_moveLen = 0;
					if( getObject != null )
					{
						R = true;
					}
					setState( MINER_STATE_NORMAL );
				}
				break;
			}
			return R;
		}
		private function DrawHookAndLine()
		{
			var arc = -T_Hook.rotationZ * Math.PI / 180;
			T_Hook.x = m_oldPx + m_moveLen * Math.sin(arc);
			T_Hook.y = m_oldPy + m_moveLen * Math.cos(arc);

			m_LineMC.graphics.clear();
			m_LineMC.graphics.lineStyle( 0,0x000000 );
			m_LineMC.graphics.moveTo( m_oldPx, m_oldPy );	
			m_LineMC.graphics.lineTo( T_Hook.x, T_Hook.y );	
		}
		public function SendHook()
		{
			if( this.m_nState != MINER_STATE_NORMAL )
				return;
			setState( MINER_STATE_SEND );
		}
		public function getObject( obj:myObject ):Boolean
		{
			if( m_nState != MINER_STATE_SEND )
				return false;
			var arc = -T_Hook.rotationZ * Math.PI / 180;
			var hx:Number = T_Hook.x + 50 *  Math.sin(arc);
			var hy:Number = T_Hook.y + 50 *  Math.cos(arc);
			
			var point:Point = new Point();
			point.x = hx;
			point.y = hy
			point = this.localToGlobal(point);
			
			var Wdis = 20 * Math.abs( obj.scaleX );
			var Hdis = 20 *  Math.abs( obj.scaleY );
			
			if( point.x > obj.x - Wdis && point.x < obj.x + Wdis &&
			    point.y > obj.y - Hdis && point.y < obj.y + Hdis )
			{
				setState( MINER_STATE_RECV );
				return true;
			}
			return false;
		}
	}
}