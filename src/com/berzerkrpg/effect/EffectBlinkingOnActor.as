package com.berzerkrpg.effect {
	import com.lachhh.lachhhengine.actor.Actor;

	/**
	 * @author Lachhh
	 */
	public class EffectBlinkingOnActor extends EffectBlinking {

		override public function update() : void {
			super.update();
			animView = actor.renderComponent.animView.anim;
			
		}
	
		static public function addToActor(actor:Actor, blinkingTime:int, color:uint):EffectBlinkingOnActor {
			var result:EffectBlinkingOnActor = new EffectBlinkingOnActor();
			result.blinkingTime = blinkingTime;
			result.color = color;
			result.animView = actor.renderComponent.animView.anim;
			actor.addComponent(result);
			
			return result;
		}		
	}
}
