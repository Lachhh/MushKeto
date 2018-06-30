package com.berzerkrpg.effect.ui {
	import com.berzerkstudio.IAnimationProxy;
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.utils.Utils;

	/**
	 * @author Eel
	 */
	public class EffectFadeInAlphaUI extends ActorComponent {
		
		public var time:Number = 60;
		public var counter:Number = 0;
		
		public var relativeToGameSpeed:Boolean = true;
		
		public var renderer:RenderFlashOrDisplay;
		
		
		public function EffectFadeInAlphaUI(pFadeOutTime:Number, pRenderer:RenderFlashOrDisplay) {
			super();
			
			renderer = pRenderer;
			time = pFadeOutTime;
			
		}
		
		
		override public function start() : void {
			super.start();
			
			renderer.alpha = 0.01;
			renderer.animView.anim.alpha = 0.01;
		}
		
		override public function update() : void {
			super.update();
			
			var prct:Number = Utils.lerp(0, 1, counter/time);
			renderer.alpha = prct;
			renderer.animView.anim.alpha = prct;
			
			if(counter >= time) {
				renderer.alpha = 1;
				renderer.animView.anim.alpha = 1;
				//Utils.SetColor(actor.renderComponent.animView.anim);
				destroyAndRemoveFromActor();
			}
			
			counter++;
		}


		static public function addToActor(actor:Actor, fadeOutTime:int, renderer:RenderFlashOrDisplay):EffectFadeInAlphaUI {
			if(fadeOutTime <= 0) throw new Error("FadeoutTime Cannot be negative");
			var result:EffectFadeInAlphaUI = new EffectFadeInAlphaUI(fadeOutTime, renderer);
			actor.addComponent(result);
			return result;
		}
	}
}