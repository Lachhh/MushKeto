package com.berzerkrpg.effect {
	import com.lachhh.lachhhengine.GameSpeed;
	import flash.geom.Point;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class EffectKickBackElastic extends ActorComponent {
		public var kickbackForceX:Number = 0;
		public var kickbackForceY:Number = 0;
		public var kickbackAppliedX:Number = 0;
		public var kickbackAppliedY:Number = 0;
		public var kickbackTime:Number = 30;
		private var prct:Number = 0;
		private var prctMod:Number = 1;
		//public var kickbackEase:Point = new Point(0.9, 0.9);
		

		public function EffectKickBackElastic() {
			super();
			prct = 0;
		}

		override public function start() : void {
			super.start();
			prctMod = 1/kickbackTime;
			kickbackAppliedX = 0;
			kickbackAppliedY = 0;
		}
		
		override public function update() : void {
			super.update();
			var prctToApply:Number = prct < 0.5 ? (prct*2) : (1-prct)*2;
			actor.px -= kickbackAppliedX;
			actor.py -= kickbackAppliedY;
			
			kickbackAppliedX = prctToApply*kickbackForceX;
			kickbackAppliedY = prctToApply*kickbackForceY;
			
			actor.px += kickbackAppliedX;
			actor.py += kickbackAppliedY;	
			prct += prctMod*GameSpeed.getSpeed();
			if(prct >= 1 || prct < 0) {
				destroyAndRemoveFromActor();
			}
		}

		override public function destroy() : void {
			super.destroy();
			actor.px -= kickbackAppliedX;
			actor.py -= kickbackAppliedY;
		}
		
		static public function addToActor(actor:Actor, kickBackX:int, kickBackY:int, time:Number):EffectKickBackElastic {
			var result:EffectKickBackElastic = new EffectKickBackElastic();
			result.kickbackForceX = kickBackX ;
			result.kickbackForceY = kickBackY ; 
			result.kickbackTime = Math.max(1,time);
			actor.addComponent(result);
			return result;
		}
	}
}
