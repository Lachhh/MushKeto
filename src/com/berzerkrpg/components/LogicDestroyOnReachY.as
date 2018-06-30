package com.berzerkrpg.components {
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class LogicDestroyOnReachY extends ActorComponent {
		public var stopOnY : int = 0;

		public function LogicDestroyOnReachY(y : int) {
			super();
			stopOnY = y;
		}
		
		
		override public function update() : void {
			super.update();
			if(actor.physicComponent.vy > 0 && actor.py >= stopOnY) {
				actor.py = stopOnY;
				actor.physicComponent.vy = 0;
				actor.destroy();
			}
		}
		
		static public function addToActor(actor: Actor, y:int): LogicDestroyOnReachY {
			var result: LogicDestroyOnReachY = new LogicDestroyOnReachY (y);
			actor.addComponent(result);
			return result;
		}
	}
}
