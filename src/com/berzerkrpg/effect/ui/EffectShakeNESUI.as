package com.berzerkrpg.effect.ui {
	import com.berzerkrpg.scenes.GameScene;
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;

	/**
	 * @author LachhhSSD
	 */
	public class EffectShakeNESUI extends ActorComponent {
		public var shakeForceX:Number = 0;
		public var shakeForceY:Number = 0;
		public var shakeAppliedX:Number = 0;
		public var shakeAppliedY : Number = 0;
		public var duration : Number = 30;
		public var waitBetweenShake : Number = 1;
		private var wait : Number = 0;
		public var mod:int = 1;
		public var visual:DisplayObject;

		public function EffectShakeNESUI() {
			super();
		}
		
		override public function update() : void {
			super.update();
			duration -= GameSpeed.getSpeed();
			if(duration <= 0) {
				destroyAndRemoveFromActor();
				return ;
			}
			
			if(wait  > 0) {
				wait -= GameSpeed.getSpeed();
				return ;
			}
			wait = waitBetweenShake ;
			
			visual.x -= shakeAppliedX;
			visual.y -= shakeAppliedY;
			
			shakeAppliedX = mod*shakeForceX-shakeForceX*0.5;
			shakeAppliedY = mod*shakeForceY-shakeForceY*0.5;
			shakeAppliedX *= GameSpeed.getSpeed();
			shakeAppliedY *= GameSpeed.getSpeed();
			visual.x += shakeAppliedX;
			visual.y += shakeAppliedY;	
			mod *= -1;
			
		}

		override public function destroy() : void {
			super.destroy();
			visual.x -= shakeAppliedX;
			visual.y -= shakeAppliedY;
		}
		
		static public function addToActor(actor:Actor, visual:DisplayObject, shakeX:int, shakeY:int):EffectShakeNESUI {
			var result:EffectShakeNESUI = new EffectShakeNESUI();
			result.visual = visual;
			result.shakeForceX = Math.abs(shakeX) ;
			result.shakeForceY = Math.abs(shakeY) ; 
			actor.addComponent(result);
			return result;
		}
	}
}
