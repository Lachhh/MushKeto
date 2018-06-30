package com.berzerkrpg.effect {
	import com.lachhh.utils.Utils;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class CallbackTimerEffect extends ActorComponent {
		public var callback:Callback;
		public var wait:Number;
		public var waitAtStart:Number;
		public var lastTime:Number;
		public var isLoop:Boolean;
		public var relativeToGameSpeed:Boolean = true;
		
		
		public function CallbackTimerEffect() {
			super();
			isLoop = false;
			lastTime = GameSpeed.getTime();
		}
		
		override public function start() : void {
			super.start();
			reset();
		}
		
		public function reset():void {
			lastTime = GameSpeed.getTime();
		}
		

		override public function update() : void {
			super.update();
			wait = (GameSpeed.getTime() - lastTime);
			
			if(wait >= waitAtStart) {
				if(callback) callback.call();
				if(!isLoop) {
					destroyAndRemoveFromActor();
				} else {
					lastTime = GameSpeed.getTime();
				}
			}
		}
		
		public function complete():void {
			waitAtStart = 0;
		}
		
		public function getPrctDone():Number {
			return Utils.minMax(1-(wait/waitAtStart), 0, 1);
		}

		static public function addWaitCallbackToActor(actor:Actor, callback:Callback, wait:Number):CallbackTimerEffect {
			var result:CallbackTimerEffect = new CallbackTimerEffect();
			result.callback = callback;
			result.waitAtStart = wait;
			
			actor.addComponent(result);
			return result;	
		}

		static public function addWaitCallFctToActor(actor:Actor, fct:Function, wait:Number):CallbackTimerEffect {
			return addWaitCallbackToActor(actor, new Callback(fct, null, null), wait);	
		}
	}
}
