package  
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * http://www.ladeng6666.com
	 * @author ladeng6666
	 */
	public class Main extends Sprite 
	{
		private var world:b2World;
		private var body:b2Body;
		
		public function Main() 
		{
			createWorld();
			createDebug();
			createBody(stage.stageWidth/2,0);
			createGround();
			
			addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}
		
		private function onStageMouseDown(e:MouseEvent):void 
		{
			createBody(mouseX,mouseY);
		}
		
		private function loop(e:Event):void 
		{
			world.Step(1/30, 10);
		}
		
		private function createWorld():void 
		{
			//1.创建一个环境
			var environment:b2AABB = new b2AABB();
			environment.lowerBound = new b2Vec2( -100, -100);
			environment.upperBound = new b2Vec2(100, 100);
			//2.声明重力
			var gravity:b2Vec2 = new b2Vec2(0, 10);
			//3.睡着的对象是否模拟
			var doSleep:Boolean = true;
			//4.创建b2World世界
			world = new b2World(environment, gravity, doSleep);
		}
		
		private function createDebug():void 
		{
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.m_sprite = debugSprite;
			debugDraw.m_drawScale = 30.0;
			debugDraw.m_fillAlpha = 0.5;
			debugDraw.m_lineThickness = 1.0;
			debugDraw.m_drawFlags = b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit;
			
			world.SetDebugDraw(debugDraw);
		}
		
		private function createBody(posX:Number,posY:Number):void 
		{
			//1.创建刚体需求b2BodyDef
			var bodyRequest:b2BodyDef = new b2BodyDef();
			bodyRequest.position.Set(posX / 30, posY / 30);//记得米和像素的转换关系
			//2.Box2D世界工厂更具需求创建createBody()生产刚体
			body=world.CreateBody(bodyRequest);
			//3.创建敢提形状需求b2ShapeDef的子类
			var shapeRequest:b2PolygonDef = new b2PolygonDef();
			//详细说明我们的需求
			shapeRequest.density = 3;
			shapeRequest.friction = 0.3;
			shapeRequest.restitution = 0.2;
			shapeRequest.SetAsBox(1, 1);
			//4.b2Body刚体工厂根据需求createShape生产形状
			body.CreateShape(shapeRequest);
			body.SetMassFromShapes();
			
		}
		
		private function createGround():void 
		{
			//1.创建刚体需求b2BodyDef
			var bodyRequest:b2BodyDef = new b2BodyDef();
			bodyRequest.position.Set(stage.stageWidth/2 / 30, stage.stageHeight/30);//记得米和像素的转换关系
			//2.Box2D世界工厂更具需求创建createBody()生产刚体
			body=world.CreateBody(bodyRequest);
			//3.创建敢提形状需求b2ShapeDef的子类
			var shapeRequest:b2PolygonDef = new b2PolygonDef();
			//详细说明我们的需求
			shapeRequest.density = 0;
			shapeRequest.friction = 0.3;
			shapeRequest.restitution = 0.2;
			shapeRequest.SetAsBox(stage.stageWidth/30, 1);
			//4.b2Body刚体工厂根据需求createShape生产形状
			body.CreateShape(shapeRequest);
			body.SetMassFromShapes();
		}
		
	}

}