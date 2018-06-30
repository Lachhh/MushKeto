package com.berzerkrpg.physics {
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.PhysicComponent;

	/**
	 * @author LachhhSSD
	 */
	public class DummyCollisionWithWorld extends PhysicComponent {
		
		static public var STOP_ON_Y:int = 390;
		public function DummyCollisionWithWorld() {
			super();
		}

		override public function update() : void {
			super.update();
			isTouchingFloor = false;
			if(actor.py >= STOP_ON_Y) {
				actor.py = STOP_ON_Y;
				vy = 0;
				isTouchingFloor = true;
			}
		}
		
		static public function addToActor(actor: Actor): DummyCollisionWithWorld {
			var result: DummyCollisionWithWorld = new DummyCollisionWithWorld ();
			actor.addComponent(result);
			return result;
		}

	}
}
