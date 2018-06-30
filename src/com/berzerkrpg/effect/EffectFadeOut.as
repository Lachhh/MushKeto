package com.berzerkrpg.effect {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.utils.Utils;

	/**
	 * @author Lachhh
	 */
	public class EffectFadeOut extends ActorComponent {
		public var fadeOutTime:Number = 60;
		public var color:int = 0xFFFFFF;
		
		public var prct:Number = 1;
		private var prctMod:Number = 0.1;
		private var _fadeOutTimeStart:Number = 0;
		
		private var _r:Number = 0;
		private var _g:Number = 0;
		private var _b:Number = 0;
		
		public var animView:DisplayObject ;
		public var relatedToGameSpeed:Boolean = true;
		
		public function EffectFadeOut(pFadeOutTime:int) {
			super();
			fadeOutTime = _fadeOutTimeStart = pFadeOutTime;
			prct = 1;
			prctMod = 1/_fadeOutTimeStart;
		}

		override public function start() : void {
			super.start();
			
			_r = (((color >> 16) & 0xFF)+0.0);//255;
			_g = (((color >> 8) & 0xFF)+0.0);//255;
			_b = (((color >> 0) & 0xFF)+0.0);//255;
			Utils.SetColorAnimViewPrct(animView, _r, _g, _b, prct);
			
		}
		
		override public function update() : void {
			super.update();
			
			prct -= prctMod*(relatedToGameSpeed ? GameSpeed.getSpeed() : 1);
			
			Utils.SetColorAnimViewPrct(animView, _r, _g, _b, prct);
			
			if(prct <= 0) {
				destroyAndRemoveFromActor();
			}
		}
		
		
		override public function destroy() : void {
			super.destroy();
			Utils.SetColorAnimView(animView);
		}

		static public function addToActor(actor:Actor, fadeOutTime:int, color:uint):EffectFadeOut {
			return addToActorWithSpecificMc(actor, actor.renderComponent.animView.anim, fadeOutTime, color);
		}
		
		static public function addToActorWithSpecificMc(actor:Actor, displayObject:DisplayObject, fadeOutTime:int, color:uint):EffectFadeOut {
			if(fadeOutTime <= 0) throw new Error("FadeoutTime Cannot be negative");
			var result:EffectFadeOut = new EffectFadeOut(fadeOutTime);
			result.color = color;
			result.animView = displayObject;
			actor.addComponent(result);
			
			return result;
		}
	}
}
