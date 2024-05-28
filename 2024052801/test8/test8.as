package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	public class test8 extends Sprite
	{
		public var world:b2World;
		public var sprite:Sprite=new Sprite;
		public var curpoint:Point=new Point;
		public var perpoint:Point=new Point;
		public var array:Array=new Array;
		public var isDown:Boolean=false;
		public var tipCanvas:Sprite=new Sprite;
		public var test:Array=new Array;
		public function test8()
		{
			var gg:b2Vec2=new b2Vec2(0,10.0);
			var issleep:Boolean=true;
			world=new b2World(gg,issleep);
			
			
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			debugDraw.SetSprite(this);
			debugDraw.SetDrawScale(30.0);
			debugDraw.SetFillAlpha(0.3);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			world.SetDebugDraw(debugDraw);
			world.DrawDebugData();
			
			
			var body:b2Body;
			var bodyDef:b2BodyDef;
			var boxShape:b2PolygonShape;
			var circleShape:b2CircleShape;
			
			bodyDef = new b2BodyDef();
			
			bodyDef.position.Set(10, 12);
			
			boxShape = new b2PolygonShape();
			boxShape.SetAsBox(30, 1);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape = boxShape;
			fixtureDef.friction = 0.3;
			fixtureDef.density = 0; // static bodies require zero density
			fixtureDef.restitution=0.5;
			// Add sprite to body userData
			bodyDef.userData = new PhysGround();
			bodyDef.userData.width = 30 * 2 * 30; 
			bodyDef.userData.height = 30 * 2 * 1; 
			bodyDef.userData.y=12*30;
			addChild(bodyDef.userData);
			body = world.CreateBody(bodyDef);
			body.CreateFixture(fixtureDef);
			
			
			addChild(sprite);
			addChild(tipCanvas);
			addEventListener(Event.ENTER_FRAME,loop);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,msDown);
			stage.addEventListener(MouseEvent.MOUSE_UP,msUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,msMove);
		}
		public function msDown(e:MouseEvent):void{
			isDown=true;
			sprite.graphics.moveTo(mouseX,mouseY);
			curpoint=new Point(mouseX,mouseY);
			perpoint=curpoint.clone();
		}
		public function msMove(e:MouseEvent):void{
			if(!isDown)return;
			sprite.graphics.lineTo(mouseX,mouseY);
			curpoint=new Point(mouseX,mouseY);
			var dis:Number=Point.distance(curpoint,perpoint);
			if(dis>20){
				array.push(new SSpoint(curpoint,perpoint));
				test.push(new b2Vec2(curpoint.x,curpoint.y));
				perpoint=curpoint.clone();
			}
		}
		public function msUp(e:MouseEvent):void{
			isDown=false;
			sprite.graphics.clear();
			createPP(array);
			array=new Array;
		}
		public function createPP(array:Array):void{
			var bodyRequest:b2BodyDef=new b2BodyDef;
			bodyRequest.type=b2Body.b2_dynamicBody;
			bodyRequest.position.Set(0,0);
			var body:b2Body=world.CreateBody(bodyRequest);
			var fixtureRequest:b2FixtureDef = new b2FixtureDef();
			fixtureRequest.density = 3;
			fixtureRequest.friction = 0.3;
			fixtureRequest.restitution = 0.2;		
			for each(var segment:SSpoint in array) {
				var shapeBoxRequest:b2PolygonShape = new b2PolygonShape();
				shapeBoxRequest.SetAsOrientedBox(segment.length /2/ 30, 2 / 30, 
					new b2Vec2(segment.centerX/30, segment.centerY/30), 
					segment.rotation);
				//shapeBoxRequest.SetAsEdge(new b2Vec2(segment.curPoint.x,segment.curPoint.y),new b2Vec2(segment.perPoint.x,segment.perPoint.y));
				fixtureRequest.shape = shapeBoxRequest;
				body.CreateFixture(fixtureRequest);
			}
				
		}
		public function loop(e:Event):void{
			world.Step(1/30,10,10);
			world.ClearForces();
			world.DrawDebugData();
			
			drawTip(array);
		}
		private function drawTip(segmengtsArray:Array):void {
			tipCanvas.graphics.clear();
			for each( var segment:SSpoint in array) {
				tipCanvas.graphics.beginFill(0xFF0000, 0.5);
				tipCanvas.graphics.drawCircle(segment.centerX, segment.centerY,3);
			}
			
		}
	}
}