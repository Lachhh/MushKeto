package com.berzerkrpg.effect {
	import flash.geom.Point;
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.lachhhengine.actor.Actor;

	/**
	 * @author LachhhSSD
	 */
	public class EffectShakeNES extends ActorComponent {
		public var shakeForceX:Number = 0;
		public var shakeForceY:Number = 0;
		public var shakeAppliedX:Number = 0;
		public var shakeAppliedY : Number = 0;
		public var duration : Number = 30;
		public var mod:int = 1;
		public var pointToSkake:Point;

		public function EffectShakeNES() {
			super();
		}
		
		override public function update() : void {
			super.update();
			pointToSkake.x -= shakeAppliedX;
			pointToSkake.y -= shakeAppliedY;
			
			shakeAppliedX = mod*shakeForceX-shakeForceX*0.5;
			shakeAppliedY = mod*shakeForceY-shakeForceY*0.5;
			shakeAppliedX *= GameSpeed.getSpeed();
			shakeAppliedY *= GameSpeed.getSpeed();
			pointToSkake.x += shakeAppliedX;
			pointToSkake.y += shakeAppliedY;	
			mod *= -1;
			duration -= GameSpeed.getSpeed();
			if(duration <= 0) {
				destroyAndRemoveFromActor();
			}
		}

		override public function destroy() : void {
			super.destroy();
			pointToSkake.x -= shakeAppliedX;
			pointToSkake.y -= shakeAppliedY;
		}
		
		static public function addToActor(actor:Actor, pToShake:Point, shakeX:int, shakeY:int):EffectShakeNES {
			var result:EffectShakeNES = new EffectShakeNES();
			result.pointToSkake = pToShake;
			result.shakeForceX = Math.abs(shakeX) ;
			result.shakeForceY = Math.abs(shakeY) ; 
			actor.addComponent(result);
			return result;
		}
	}
}
