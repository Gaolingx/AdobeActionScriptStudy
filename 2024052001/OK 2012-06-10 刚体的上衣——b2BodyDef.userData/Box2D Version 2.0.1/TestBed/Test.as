package TestBed{

	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;
	import Main;
	import General.Input;
	import flash.utils.getTimer;
	import flash.display.*;

	public class Test {

		public function Test() {

			m_sprite = Main.m_sprite;
			
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-1000.0, -1000.0);
			worldAABB.upperBound.Set(1000.0, 1000.0);
			
			var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
			var doSleep:Boolean = true;
			
			m_world = new b2World(worldAABB, gravity, doSleep);
			
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.m_sprite = m_sprite;
			dbgDraw.m_drawScale = 30.0;
			dbgDraw.m_fillAlpha = 0.5;
			dbgDraw.m_lineThickness = 1.0;
			dbgDraw.m_drawFlags = b2DebugDraw.e_shapeBit;
			m_world.SetDebugDraw(dbgDraw);
			
			var wallSd:b2PolygonDef = new b2PolygonDef();
			var wallBd:b2BodyDef = new b2BodyDef();
			var wallB:b2Body;
			
			wallBd.position.Set(640/m_physScale/2, (360+95)/m_physScale);
			wallSd.SetAsBox(680/m_physScale/2, 100/m_physScale);
			wallB = m_world.CreateBody(wallBd);
			wallB.CreateShape(wallSd);
			wallB.SetMassFromShapes();
		}
		public function Update():void {
			UpdateMouseWorld();
			MouseDestroy();
			var physStart:uint = getTimer();
			m_world.Step(m_timeStep, m_iterations);
		}
		public var m_world:b2World;
		public var m_bomb:b2Body;
		public var m_mouseJoint:b2MouseJoint;
		public var m_iterations:int = 10;
		public var m_timeStep:Number = 1/30;
		public var m_physScale:Number = 30;

		static public  var mouseXWorldPhys:Number;
		static public  var mouseYWorldPhys:Number;
		static public  var mouseXWorld:Number;
		static public  var mouseYWorld:Number;
		static public  var block_removed:Boolean;

		public var m_sprite:Sprite;

		public function UpdateMouseWorld():void {
			mouseXWorldPhys = (Input.mouseX)/m_physScale;
			mouseYWorldPhys = (Input.mouseY)/m_physScale;

			mouseXWorld = (Input.mouseX);
			mouseYWorld = (Input.mouseY);
		}
		public function MouseDestroy():void {
			if (Input.mouseDown && !block_removed) {
				var body:b2Body = GetBodyAtMouse(true);
				if (body && body.m_I>0) {
					block_removed = true;
					m_world.DestroyBody(body);
					return;
				}
			}
			if (!Input.mouseDown) {
				block_removed = false;
			}
		}
		private var mousePVec:b2Vec2 = new b2Vec2();
		public function GetBodyAtMouse(includeStatic:Boolean=false):b2Body {
			mousePVec.Set(mouseXWorldPhys, mouseYWorldPhys);
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.Set(mouseXWorldPhys - 0.001, mouseYWorldPhys - 0.001);
			aabb.upperBound.Set(mouseXWorldPhys + 0.001, mouseYWorldPhys + 0.001);
			var k_maxCount:int = 10;
			var shapes:Array = new Array();
			var count:int = m_world.Query(aabb, shapes, k_maxCount);
			var body:b2Body = null;
			for (var i:int = 0; i < count; ++i) {
				if (shapes[i].GetBody().IsStatic() == false || includeStatic) {
					var tShape:b2Shape = shapes[i] as b2Shape;
					var inside:Boolean = tShape.TestPoint(tShape.GetBody().GetXForm(), mousePVec);
					if (inside) {
						body = tShape.GetBody();
						break;
					}
				}
			}
			return body;
		}
	}
}