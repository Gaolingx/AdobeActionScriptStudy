package {

	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Common.Math.*;
	import flash.events.Event;
	import flash.display.*;
	import flash.text.*;
	import General.*;
	import TestBed.Test;
	import TestBed.TestStack;
	import TestBed.*;
	
	import flash.display.MovieClip;
	public class Main extends MovieClip {
		public var m_currTest:Test;
		static public  var m_sprite:Sprite;
		static public var m_aboutText:TextField;
		
		public var m_input:Input;
		public function Main() {
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			m_sprite = new Sprite();
			addChild(m_sprite);
			m_input = new Input(m_sprite);
			m_aboutText = tag;
		}
		public function update(e:Event):void {
			if (!m_currTest) {
				m_currTest = new TestBridge();
			}
			m_currTest.Update();
			FRateLimiter.limitFrame(30);
		}
	}
}