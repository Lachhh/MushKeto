package com.berzerkrpg.components {
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class TweenNumberComponent extends ActorComponent {
		public var value:Number;
		public var gotoValue:Number;
		public var ease:Number = 2;
		public var callbackOnReach:Callback;
		public function TweenNumberComponent() {
			super();
			value = 0;
		}

		override public function update() : void {
			super.update();
			if(value > (gotoValue+ease)) {
				value-=ease;
			} else if(value < (gotoValue-ease)) {
				value+=ease;
			}
			if(hasReachedGoto()) {
				value = gotoValue;
				if(callbackOnReach) {
					callbackOnReach.call();
					callbackOnReach = null;
				}
			}
		}
		
		public function hasReachedGoto():Boolean {
			return Math.abs(gotoValue - value) <= ease;
		}
		
		static public function addToActor(actor: Actor):TweenNumberComponent {
			var result:TweenNumberComponent = new TweenNumberComponent();
			actor.addComponent(result);
			return result;
		}
	}
}
