package{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	// Classes used in this example
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import General.Input;
	import Box2D.Dynamics.b2DebugDraw;
	
	public class HelloWorld extends Sprite{
		
		static public var mouseXWorldPhys:Number;
			static public var mouseYWorldPhys:Number;
			static public var mouseXWorld:Number;
			static public var mouseYWorld:Number;
		
		public function HelloWorld(){
			
			// world mouse position
			
			
			
			
			// Add event for main loop
			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			
			// Creat world AABB
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-100.0, -100.0);
			worldAABB.upperBound.Set(100.0, 100.0);
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			// Construct a world object
			m_world = new b2World(worldAABB, gravity, doSleep);
			
			// set debug draw
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			var dbgSprite:Sprite = new Sprite();
			addChild(dbgSprite);
			dbgDraw.m_sprite = dbgSprite;
			dbgDraw.m_drawScale = 30.0;
			dbgDraw.m_fillAlpha = .8;
			dbgDraw.m_lineThickness = 1.0;
			dbgDraw.m_drawFlags = 0xFFFFFFFF;
			m_world.SetDebugDraw(dbgDraw);
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit);
			
			
			
			// Vars used to create bodies
			var body:b2Body;
			var bodyDef:b2BodyDef;
			var boxDef:b2PolygonDef;
			var circleDef:b2CircleDef;
				
			// Add ground body
			bodyDef = new b2BodyDef();
			//bodyDef.position.Set(15, 19);
			bodyDef.position.Set(10, 12);
			bodyDef.angle = 0;
			
			// Add sprite to body userData
			bodyDef.userData = new PhysGround();
			//bodyDef.userData = new PhysCircle();
			bodyDef.userData.width = 30 * 2 * 30; 
			bodyDef.userData.height = 30 * 2 * 3; 
			addChild(bodyDef.userData);
			
			body = m_world.CreateBody(bodyDef);
			
			boxDef = new b2PolygonDef();
			//boxDef.SetAsBox(30, 3);
			boxDef.friction = 0.3;
			boxDef.density = 0; // static bodies require zero density
			/*circleDef = new b2CircleDef();
			circleDef.radius = 10;
			circleDef.restitution = 0.2;*/
			
			body.CreateShape(boxDef);
			//body.CreateShape(circleDef);
			//body.SetMassFromShapes();
			
			// Add some objects
			for (var i:int = 1; i < 3; i++){
				bodyDef = new b2BodyDef();
				bodyDef.position.x = Math.random() * 15 + 5;
				bodyDef.position.y = Math.random() * 10;
				var rX:Number = Math.random() + 0.5;
				var rY:Number = Math.random() + 0.5;
				// Box
				if (Math.random() < 0.5){
					boxDef = new b2PolygonDef();
					boxDef.SetAsBox(rX, rY);
					boxDef.density = 1.0;
					boxDef.friction = 0.5;
					boxDef.restitution = 0.2;
					bodyDef.userData = new PhysBox();
					bodyDef.userData.width = rX * 2 * 30; 
					bodyDef.userData.height = rY * 2 * 30; 
					body = m_world.CreateBody(bodyDef);
					body.CreateShape(boxDef);
				} 
				// Circle
				else {
					circleDef = new b2CircleDef();
					circleDef.radius = rX;
					circleDef.density = 1.0;
					circleDef.friction = 0.5;
					circleDef.restitution = 0.2
					bodyDef.userData = new PhysCircle();
					bodyDef.userData.width = rX * 2 * 30; 
					bodyDef.userData.height = rX * 2 * 30; 
					body = m_world.CreateBody(bodyDef);
					body.CreateShape(circleDef);
				}
				body.SetMassFromShapes();
				addChild(bodyDef.userData);
				
			}
			
		}
		
		/*public function get_click(e:MouseEvent):void{
			UpdateMouseWorld();
			trace(GetBodyAtMouse(true));
		}
		
		public function UpdateMouseWorld():void{
			var m_physScale = 1;
			trace(Input.mouseX);
			mouseXWorldPhys = (Input.mouseX)/m_physScale; 
			mouseYWorldPhys = (Input.mouseY)/m_physScale; 
			
			mouseXWorld = (Input.mouseX); 
			mouseYWorld = (Input.mouseY); 
		}*/
		
		private var mousePVec:b2Vec2 = new b2Vec2();
		public function GetBodyAtMouse(includeStatic:Boolean=false):b2Body{
			// Make a small box.
			mousePVec.Set(mouseXWorldPhys, mouseYWorldPhys);
			var aabb:b2AABB = new b2AABB();
			trace(mouseXWorldPhys);
			aabb.lowerBound.Set(mouseXWorldPhys - 0.001, mouseYWorldPhys - 0.001);
			aabb.upperBound.Set(mouseXWorldPhys + 0.001, mouseYWorldPhys + 0.001);
			
			// Query the world for overlapping shapes.
			var k_maxCount:int = 10;
			var shapes:Array = new Array();
			var count:int = m_world.Query(aabb, shapes, k_maxCount);
			var body:b2Body = null;
			for (var i:int = 0; i < count; ++i)
			{
				if (shapes[i].GetBody().IsStatic() == false || includeStatic)
				{
					var tShape:b2Shape = shapes[i] as b2Shape;
					var inside:Boolean = tShape.TestPoint(tShape.GetBody().GetXForm(), mousePVec);
					if (inside)
					{
						body = tShape.GetBody();
						break;
					}
				}
			}
			return body;
		}
		
		public function Update(e:Event):void{
			
			m_world.Step(m_timeStep, m_iterations);
			
			// Go through body list and update sprite positions/rotations
			for (var bb:b2Body = m_world.m_bodyList; bb; bb = bb.m_next){
				if (bb.m_userData is Sprite){
					bb.m_userData.x = bb.GetPosition().x * 30;
					bb.m_userData.y = bb.GetPosition().y * 30;
					bb.m_userData.rotation = bb.GetAngle() * (180/Math.PI);
				}
			}
			
		}
		
		public var m_world:b2World;
		public var m_iterations:int = 10;
		public var m_timeStep:Number = 1.0/30.0;
		
	}

}