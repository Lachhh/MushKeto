package com.berzerkrpg.effect {
	import com.berzerkstudio.IAnimationProxy;
	import com.lachhh.utils.Utils;
	import com.lachhh.io.CallbackGroup;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	import flash.display.DisplayObject;
	import flash.geom.Point;

	/**
	 * @author LachhhSSD
	 */
	public class EffectGotoEaseOut2 extends ActorComponent {
		public var gotoPos:Point = new Point();
		public var ease:Point = new Point();
		public var minSpeed:Number = 2;
		public var threshold:int = 3;
		public var callbackOnArrived:CallbackGroup = new CallbackGroup();
		public var destroyWhenReachedGoto:Boolean = false;
		private var delta:Point = new Point();
		private var spd:Point = new Point();
		
		
		public function EffectGotoEaseOut2() {
			super();

			ease.x = 0.03;
			ease.y = 0.03;
			minSpeed = 2;
		}

		override public function update() : void {
			super.update();
			delta.x = (gotoPos.x-actor.px);
			delta.y = (gotoPos.y-actor.py);
			
			spd.x = delta.x*ease.x;
			spd.y = delta.y*ease.y;
			if(spd.length < minSpeed) {
				spd.normalize(minSpeed);
			}
			
			actor.px += spd.x;
			actor.py += spd.y;
			 
			if(delta.x*delta.x+delta.y*delta.y < threshold) {
				actor.px = gotoPos.x;
				actor.py = gotoPos.y;
				callbackOnArrived.call();
				if(destroyWhenReachedGoto) destroyAndRemoveFromActor();	
			}
		}
		
		static public function addToActor(actor:Actor, x:Number, y:Number):EffectGotoEaseOut2 {
			var result:EffectGotoEaseOut2 = new EffectGotoEaseOut2();
			result.gotoPos.x = x;
			result.gotoPos.y = y;
			
			actor.addComponent(result);
			return result;
		}
	}
}
