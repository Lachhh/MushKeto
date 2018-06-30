package com.berzerkrpg.effect {
	import com.lachhh.lachhhengine.camera.CameraFlash;
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	import flash.geom.Point;

	/**
	 * @author LachhhSSD
	 */
	public class LogicLockInsideCamBounds extends ActorComponent {
		public var threshold:Point = new Point(15, -300);

		public function LogicLockInsideCamBounds() {
			super();
		}

		override public function update() : void {
			super.update();
			actor.px = Math.max(CameraFlash.mainCamera.boundsFOV.left+threshold.x, actor.px);
			actor.px = Math.min(CameraFlash.mainCamera.boundsFOV.right-threshold.x, actor.px);
			actor.py = Math.max(CameraFlash.mainCamera.boundsFOV.top+threshold.y, actor.py);
			actor.py = Math.min(CameraFlash.mainCamera.boundsFOV.bottom-threshold.y, actor.py);
			
		}
		
		static public function addToActor(actor: Actor):LogicLockInsideCamBounds {
			var result:LogicLockInsideCamBounds = new LogicLockInsideCamBounds();
			actor.addComponent(result);
			return result;
		}

	}
}
