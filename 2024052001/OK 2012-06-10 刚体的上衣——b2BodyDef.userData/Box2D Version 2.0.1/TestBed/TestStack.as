package TestBed{

	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;

	public class TestStack extends Test {

		public function TestStack() {
			var sd:b2PolygonDef = new b2PolygonDef();
			var bd:b2BodyDef = new b2BodyDef();
			var b:b2Body;
			sd.density = 1;
			sd.friction = 1;
			sd.restitution = 0;
			var i:int;
			for (i = 0; i < 5; i++) {
				sd.SetAsBox(12/m_physScale, 12/m_physScale);
				bd.position.Set(300 / m_physScale, (340-i*24)/m_physScale);
				b = m_world.CreateBody(bd);
				b.CreateShape(sd);
				b.SetMassFromShapes();
			}
			for (i = 0; i < 5; i++) {
				sd.SetAsBox(12/m_physScale, 12/m_physScale);
				bd.position.Set(200/m_physScale, (340-i*24)/m_physScale);
				b = m_world.CreateBody(bd);
				b.CreateShape(sd);
				b.SetMassFromShapes();
			}
			sd.SetAsBox(100/m_physScale, 12/m_physScale);
			bd.position.Set(250/m_physScale, 220/m_physScale);
			b = m_world.CreateBody(bd);
			b.CreateShape(sd);
			b.SetMassFromShapes();
			var cd:b2CircleDef = new b2CircleDef();
			cd.radius = 20/m_physScale;
			cd.density = 2;
			cd.restitution = 0.2;
			cd.friction = 0.5;
			bd.position.Set(250/m_physScale,150/m_physScale);
			b = m_world.CreateBody(bd);
			b.CreateShape(cd);
			b.SetMassFromShapes();

		}
	}
}