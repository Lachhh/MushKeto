package com.berzerkrpg.effect {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.IAnimationProxy;
	import com.lachhh.utils.Utils;
	import com.lachhh.io.CallbackGroup;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	
	import flash.geom.Point;

	/**
	 * @author LachhhSSD
	 */
	public class EffectGotoEaseOutUI extends ActorComponent {
		public var gotoPos:Point = new Point();
		public var ease:Point = new Point();
		public var minSpeed:Number = 2;
		public var visualMc:DisplayObject ;
		public var threshold:int = 3;
		public var callbackOnArrived:CallbackGroup = new CallbackGroup();
		public var destroyWhenReachedGoto:Boolean = false;
		private var delta:Point = new Point();
		private var spd:Point = new Point();
		
		
		public function EffectGotoEaseOutUI(pDisplay:DisplayObject) {
			super();
			visualMc = pDisplay;
			ease.x = 0.03;
			ease.y = 0.03;
			minSpeed = 2;
		}

		override public function update() : void {
			super.update();
			delta.x = (gotoPos.x-visualMc.x);
			delta.y = (gotoPos.y-visualMc.y);
			
			spd.x = delta.x*ease.x;
			spd.y = delta.y*ease.y;
			if(spd.length < minSpeed) {
				spd.normalize(minSpeed);
			}
			
			visualMc.x += spd.x;
			visualMc.y += spd.y;
			 
			if(delta.x*delta.x+delta.y*delta.y < threshold) {
				visualMc.x = gotoPos.x;
				visualMc.y = gotoPos.y;
				callbackOnArrived.call();
				if(destroyWhenReachedGoto) destroyAndRemoveFromActor();	
			}
		}
		
		private function takeLargest(n:Number, min:Number):Number {
			if(Math.abs(n) > Math.abs(min)) return n;
			if(n > 0) return min; 
			return -min;
		}
		
		
		static public function addToActor(actor:Actor, x:Number, y:Number, displayObject:DisplayObject):EffectGotoEaseOutUI {
			var result:EffectGotoEaseOutUI = new EffectGotoEaseOutUI(displayObject);
			result.gotoPos.x = x;
			result.gotoPos.y = y;
			result.visualMc = displayObject;
			
			actor.addComponent(result);
			return result;
		}
	}
}
