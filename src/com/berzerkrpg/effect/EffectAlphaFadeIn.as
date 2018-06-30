package com.berzerkrpg.effect {
	import com.lachhh.lachhhengine.GameSpeed;
	import com.berzerkstudio.IDisplayProxy;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author Eel
	 */
	public class EffectAlphaFadeIn extends ActorComponent {
		
		public var prctPerFrame:Number = 0.01;
		
		private var alpha:Number = 0;
		
		public var wait:Number = 0;
		
		public function EffectAlphaFadeIn() {
			super();
		}
		
		public override function start():void{
			super.start();
			actor.renderComponent.alpha = 0;
		}
		
		public override function update():void{
			super.start();
			
			if(wait > 0) {
				wait -= GameSpeed.getSpeed();
				return;
			}
			
			alpha += prctPerFrame;
			
			if(alpha >= 1){
				destroyAndRemoveFromActor();
			}
			
			actor.renderComponent.alpha = alpha;
		}
		
		override public function destroy() : void {
			super.destroy();
			actor.renderComponent.alpha = 1;
		}
		
		public static function addToActor(actor:Actor, pPrctPerFrame:Number, pWait:Number = 0):EffectAlphaFadeIn{
			var result:EffectAlphaFadeIn = new EffectAlphaFadeIn();
			
			result.prctPerFrame = pPrctPerFrame;
			result.wait = pWait;
			
			actor.addComponent(result);
		
			return result;
		}
	}
}