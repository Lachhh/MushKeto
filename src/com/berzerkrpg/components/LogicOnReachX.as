package com.berzerkrpg.components {
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class LogicOnReachX extends ActorComponent {
		public var gotoX:Number;
		public var endCallback:Callback;
		public function LogicOnReachX() {
			super();
		}

		
		override public function update() : void {
			super.update();
			if(actor.physicComponent.vx > 0	&& actor.px > gotoX) {
				onReached();
			} else if(actor.physicComponent.vx < 0 && actor.px < gotoX) {
				onReached();
			}
		}
		
		private function onReached():void {
			if(endCallback) endCallback.call();
			destroyAndRemoveFromActor();
		}

	}
}
