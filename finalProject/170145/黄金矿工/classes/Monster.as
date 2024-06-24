package classes
{
	import flash.display.MovieClip;

	public class Monster extends myObject
	{
		private var m_bRight:Boolean = true;
		public function Monster()
		{
			m_nType = OBJECT_TYPE_MONSTER_1;
			stop();
	    }
		override public function setType( type:int )
		{
			m_nType = type;
			this.scaleX = 1;
			this.scaleY = 1;
			switch( m_nType )
			{
			case OBJECT_TYPE_MONSTER_1:
				this.gotoAndStop(1);
				break;
			case OBJECT_TYPE_MONSTER_2:
				this.gotoAndStop(2);
				break;
			}
		}
		override public function Logic()
		{
			if( m_bRight == true )
			{
				this.scaleX = 1;
				this.x = this.x + 4;
				if( this.x > 800 )
				{
					m_bRight = false;
				}
			}
			else
			{
				this.scaleX = -1;
				this.x = this.x - 4;
				if( this.x < 380 )
				{
					m_bRight = true;
				}
			}
		}
	}
}