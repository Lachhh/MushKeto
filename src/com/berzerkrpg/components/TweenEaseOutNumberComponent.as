package com.berzerkrpg.components {
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class TweenEaseOutNumberComponent extends ActorComponent {
		public var value:Number;
		public var gotoValue:Number;
		public var ease:Number = 0.01;
		public var minimumStep:Number = 1;
		public var thresholdCallback:Number = 0.01;
		public var callbackOnReach : Callback;

		public function TweenEaseOutNumberComponent() {
			super();
			value = 0;
		}

		override public function update() : void {
			super.update();
			
			if(Math.abs(gotoValue - value) <= thresholdCallback) {
				value = gotoValue;
				if(callbackOnReach) {
					callbackOnReach.call();
					callbackOnReach = null;
				}
			} else {
				var step:Number = (gotoValue-value)*ease;
				if(step > 0) step = Math.max(step, minimumStep);
				if(step < 0) step = Math.min(step, -minimumStep);
				value += step;	
			}
		}
		
		static public function addToActor(actor: Actor):TweenEaseOutNumberComponent {
			var result:TweenEaseOutNumberComponent = new TweenEaseOutNumberComponent();
			actor.addComponent(result);
			return result;
		}
	}
}
