package com.berzerkrpg.effect {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.utils.Utils;

	/**
	 * @author Lachhh
	 */
	public class EffectBlinkingUI extends ActorComponent {
		public var blinkingTime:Number = 60;
		public var blinkingDelay:Number = 2;
		public var color:int = 0xFFFFFF;
		public var animView:DisplayObject ;
		public var useGameSpeed:Boolean = true;
		public var callbackOnEnd:Callback ;
		
		private var _blinkingDelayWait:Number;
		private var _colorApplied:Boolean;
		
		public function EffectBlinkingUI() {
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
				if(animView != null) { 	
					if(_colorApplied) {
						Utils.SetColor2AnimView(animView, color);
					} else {
						Utils.SetColorAnimView(animView);
					}
				}
			}	
			
			blinkingTime -= (useGameSpeed ? GameSpeed.getSpeed() : 1);
			if(blinkingTime <= 0) {
				destroyAndRemoveFromActor();
				if(callbackOnEnd) callbackOnEnd.call();
			}
		}
		
		
		override public function destroy() : void {
			super.destroy();
			if(animView != null) Utils.SetColorAnimView(animView);
		}

				
		static public function addToActorWithSpecificMc(actor:Actor, displayObject:DisplayObject, blinkingTime:int, color:uint):EffectBlinkingUI {
			var result:EffectBlinkingUI = new EffectBlinkingUI();
			result.blinkingTime = blinkingTime;
			result.color = color;
			result.animView = displayObject;
			actor.addComponent(result);
			
			return result;
		}
		
	}
}
