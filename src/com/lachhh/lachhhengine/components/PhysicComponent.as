package com.lachhh.lachhhengine.components {
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.actor.Actor;

	/**
	 * @author LachhhSSD
	 */
	public class PhysicComponent extends ActorComponent {
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var gravY:Number = 0.6;
		public var gravX:Number = 0;
		public var respectGameSpeed:Boolean = true;
		public var isTouchingFloor:Boolean = false;
		public var isTouchingWall:Boolean = false;
		
		public function PhysicComponent() {
			super();	
		}

		override public function update() : void {
			super.update();
			var speed:Number = getSpeed();
			vx += gravX*speed;
			vy += gravY*speed;
			actor.px += vx*speed;
			actor.py += vy*speed;
		}
		
		public function getSpeed():Number {
			if(respectGameSpeed) return GameSpeed.getSpeed();
			return 1;
		}
		
		public function isMoving():Boolean {
			return (vx != 0 || vy != 0);
		}
		
		static public function addToActor(actor:Actor):PhysicComponent {
			var result:PhysicComponent = new PhysicComponent();
			actor.addComponent(result);
			return result;
		}
	}
}
