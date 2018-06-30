package com.berzerkrpg.effect.ui {
	import com.berzerkstudio.IDisplayProxy;
	import com.lachhh.lachhhengine.actor.Actor;

	/**
	 * @author LachhhSSD
	 */
	public class EffectShakeUI extends EffectShakeConstantUI {
		public var speedFadeX:Number = 0.9;
		public var speedFadeY:Number = 0.9;
		public function EffectShakeUI() {
			super();
		}
		
		
		override public function start() : void {
			super.start();
			
		}
		
		override public function update() : void {
			super.update();
			shakeForceX *= speedFadeX;
			shakeForceY *= speedFadeY;
			if(shakeForceX < 1) shakeForceX = 0;
			if(shakeForceY < 1) shakeForceY = 0;
			
			if(shakeForceX <= 0 && shakeForceY <= 0) {
				destroyAndRemoveFromActor();
			} 
		}

		public function setFade(n:Number):void {
			speedFadeX = n;
			speedFadeY = n;
		}
		
		static public function addToActor(actor:Actor, visual:IDisplayProxy, shakeX:int, shakeY:int):EffectShakeUI {
			var result:EffectShakeUI = new EffectShakeUI();
			result.shakeForceX = shakeX ;
			result.shakeForceY = shakeY ; 
			result.visual = visual;
			actor.addComponent(result);
			return result;
		}
	}
}
