package com.berzerkrpg.effect {
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class SimpleTimer extends ActorComponent {
		public var wait:Number = 0;
		public var waitMax : Number = 1;
		public var relativeToGameSpeed : Boolean = false;

		public function SimpleTimer() {
		}

		public function reset() : void {
			wait = waitMax;
		}
		
		public function complete():void {
			wait = 0;
		}
		
		override public function update() : void {
			super.update();
			if(wait > 0) {
				wait -= 1;
			}
		}
		
		public function isCompleted():Boolean {
			if(waitMax <= 0) return false;
			return (wait <= 0);
		}
		
		public function getPrctCompleted():Number {
			if(waitMax <= 0) return 0;
			return 1-(wait/waitMax);
		}
		
		public function getPrctLeft():Number {
			if(waitMax <= 0) return 0;
			return (wait/waitMax);
		}
		
		static public function addToActor(wait:Number, actor: Actor):SimpleTimer {
			if(wait <= 0) throw new Error("SimpleTimer :: wait time cannot be less or equal 0");
			
			var result:SimpleTimer = new SimpleTimer();
			
			result.waitMax = wait;
			result.reset();
			actor.addComponent(result);
			return result;
		}
	}
}
