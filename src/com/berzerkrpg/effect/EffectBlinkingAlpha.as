package com.berzerkrpg.effect {
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.utils.Utils;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	/**
	 * @author Lachhh
	 */
	public class EffectBlinkingAlpha extends ActorComponent {
		public var blinkingTime:Number = 60;
		public var blinkingDelay:Number = 2;
		
		public var useGameSpeed:Boolean = true;
		public var callbackOnEnd:Callback ;
		
		private var _blinkingDelayWait:Number;
		private var _colorApplied:Boolean;
		
		public function EffectBlinkingAlpha() {
			super();
			_colorApplied = false;
			_blinkingDelayWait = blinkingDelay;
		}
		
		override public function update() : void {
			super.update();
			
			_blinkingDelayWait -= (useGameSpeed ? GameSpeed.getSpeed() : 1);
			if(_blinkingDelayWait <= 0) {
				_blinkingDelayWait = blinkingDelay;
				_colorApplied = !_colorApplied;
				 	
				if(_colorApplied) {
					actor.renderComponent.animView.anim.alpha = 0;
				} else {
					actor.renderComponent.animView.anim.alpha = 1;
				}
				
			}	
			
			blinkingTime -= (useGameSpeed ? GameSpeed.getSpeed() : 1);
			if(blinkingTime <= 0) {
				actor.renderComponent.animView.anim.alpha = 1;
				destroyAndRemoveFromActor();
				if(callbackOnEnd) callbackOnEnd.call();
			}
		}	
		
		static public function addToActor(actor:Actor, blinkingTime:int):EffectBlinkingAlpha {
			var result:EffectBlinkingAlpha = new EffectBlinkingAlpha();
			result.blinkingTime = blinkingTime;
			actor.addComponent(result);
			
			return result;
		}		
	}
}
