package classes
{
	import flash.display.MovieClip;

	public class myObject extends MovieClip
	{
		//定义一组物品类型的数据
		public static var OBJECT_TYPE_GOLD_BIG:int		= 0;	//小金块
		public static var OBJECT_TYPE_GOLD_SMALL:int	= 1;	//大金块
		public static var OBJECT_TYPE_MONEY:int			= 2;	//钱袋
		public static var OBJECT_TYPE_ROCK_1:int		= 3;	//石头1
		public static var OBJECT_TYPE_ROCK_2:int		= 4;	//石头2
		public static var OBJECT_TYPE_MONSTER_1:int		= 5;	//怪物1
		public static var OBJECT_TYPE_MONSTER_2:int		= 6;	//怪物2
		
		public static var OBJECT_TYPE_OBJECT_NUM:int	= 5;	//普通物品种类的个数
		public static var OBJECT_TYPE_MONSTER_NUM:int	= 2;	//怪物种类数
		public static var OBJECT_TYPE_NUM:int			= 7;	//所有物品种类数
		protected var m_nType:int;								//物体类型
		public function myObject()
		{
			m_nType = OBJECT_TYPE_GOLD_BIG;
			stop();
	    }
		public function setType( type:int )
		{
			m_nType = type;
			this.scaleX = 1;
			this.scaleY = 1;
			switch( m_nType )
			{
			case OBJECT_TYPE_GOLD_BIG:
				this.scaleX = 2.5;
				this.scaleY = 2.5;
				this.gotoAndStop(1);
				break;
			case OBJECT_TYPE_GOLD_SMALL:
				this.gotoAndStop(1);
				break;
			case OBJECT_TYPE_MONEY:
				this.gotoAndStop(2);
				break;
			case OBJECT_TYPE_ROCK_1:
				this.gotoAndStop(3);
				break;
			case OBJECT_TYPE_ROCK_2:
				this.gotoAndStop(4);
				break;
			}
		}
		public function getType():int
		{
			return m_nType;
		}
		public function getScore():int
		{
			switch( m_nType )
			{
			case OBJECT_TYPE_GOLD_BIG:
				return 500;
			case OBJECT_TYPE_GOLD_SMALL:
				return 50;
			case OBJECT_TYPE_MONEY:
				return 100;
			case OBJECT_TYPE_ROCK_1:
				return 1;
			case OBJECT_TYPE_ROCK_2:
				return 1;
			case OBJECT_TYPE_MONSTER_1:
				return 1;
			case OBJECT_TYPE_MONSTER_2:
				return 800;
			}
			return 0;
		}
		public function Logic()
		{
		}
	}
}