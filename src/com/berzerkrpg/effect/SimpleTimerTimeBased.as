package com.berzerkrpg.effect {
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class SimpleTimerTimeBased extends ActorComponent {
		public var waitInMs:Number = 0;
		public var waitMaxInMs : Number = 1;
		public var lastTime : Number = 0;
		
		public var relativeToGameSpeed : Boolean = false;

		public function SimpleTimerTimeBased() {
			lastTime = getTimer();
		}

		public function reset() : void {
			waitInMs = waitMaxInMs;
			lastTime = getTimer();
		}
		
		public function complete():void {
			waitInMs = 0;
		}
		
		override public function update() : void {
			super.update();
			var delta:Number = getTimer()-lastTime;
			if(waitInMs > 0) {
				waitInMs -= delta;
				lastTime = getTimer();
			}
		}
				
		public function isCompleted():Boolean {
			if(waitMaxInMs <= 0) return false;
			return (waitInMs <= 0);
		}
		
		public function getPrctCompleted():Number {
			if(waitMaxInMs <= 0) return 0;
			return 1-(waitInMs/waitMaxInMs);
		}
		
		public function getPrctLeft():Number {
			if(waitMaxInMs <= 0) return 0;
			return (waitInMs/waitMaxInMs);
		}
		
		static public function addToActor(waitInMs:Number, actor: Actor):SimpleTimerTimeBased {
			if(waitInMs <= 0) throw new Error("SimpleTimer :: wait time cannot be less or equal 0");
			
			var result:SimpleTimerTimeBased = new SimpleTimerTimeBased();
			
			result.waitMaxInMs = waitInMs;
			result.reset();
			actor.addComponent(result);
			return result;
		}
	}
}
