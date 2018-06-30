package com.berzerkrpg.effect {
	import com.lachhh.utils.Utils;
	import flash.geom.Rectangle;
	import com.lachhh.lachhhengine.camera.CameraFlash;
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	import flash.geom.Point;

	/**
	 * @author LachhhSSD
	 */
	public class LogicLockInsideOfBounds extends ActorComponent {
		public var bounds:Rectangle = new Rectangle();

		public function LogicLockInsideOfBounds() {
			super();
		}

		override public function update() : void {
			super.update();
			
			actor.px = Utils.minMax(actor.px, bounds.left, bounds.right);
			actor.py = Utils.minMax(actor.py, bounds.top, bounds.bottom);
			
		}
		
		static public function addToActor(actor: Actor):LogicLockInsideOfBounds {
			var result:LogicLockInsideOfBounds = new LogicLockInsideOfBounds();
			actor.addComponent(result);
			return result;
		}

	}
}
