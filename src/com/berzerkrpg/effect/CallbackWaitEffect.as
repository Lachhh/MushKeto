package com.berzerkrpg.effect {
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class CallbackWaitEffect extends ActorComponent {
		public var callback:Callback;
		public var wait:Number;
		public var waitAtStart:Number;
		public var relativeToGameSpeed:Boolean = true;
		
		public function CallbackWaitEffect() {
			super();
		}

		override public function start() : void {
			super.start();
			waitAtStart = wait;
		}

		override public function update() : void {
			super.update();
			wait -= (relativeToGameSpeed ? GameSpeed.getSpeed() : 1);
			if(wait <= 0) {
				if(callback) callback.call();
				destroyAndRemoveFromActor();
			}
		}
		
		public function getPrctComplete():Number {
			return 1-(wait/waitAtStart);
		}
		
		static public function addWaitCallbackToActor(actor:Actor, callback:Callback, wait:Number):CallbackWaitEffect {
			var result:CallbackWaitEffect = new CallbackWaitEffect();
			result.callback = callback;
			result.wait = wait;
			actor.addComponent(result);
			return result;	
		}
		
		static public function addWaitCallFctToActor(actor:Actor, fct:Function, frame:Number):CallbackWaitEffect {
			return addWaitCallbackToActor(actor, new Callback(fct, null, null), frame);	
		}
		
		static public function addWaitCallFctToActorRelatedToGameSpeed(actor:Actor, fct:Function, frame:Number, relativeToGameSpeed:Boolean):CallbackWaitEffect {
			var c:CallbackWaitEffect = addWaitCallbackToActor(actor, new Callback(fct, null, null), frame);
			c.relativeToGameSpeed = relativeToGameSpeed; 
			return c;
		}

	}
}
