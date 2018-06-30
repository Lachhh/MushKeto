package com.berzerkrpg.effect {
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.camera.CameraFlash;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class LogicDestroyOutsideOfBounds extends ActorComponent {
		public var offset:int = 100;
		public function LogicDestroyOutsideOfBounds() {
			super();
		}

		override public function update() : void {
			super.update();
			if(isOutsideOfScreen(actor, offset, offset)) {
				actor.destroy();			
			}
		}
		
		
		static public function isOutsideOfScreen(actor:Actor, offsetX:int, offsetY:int):Boolean {
			if(actor.px < CameraFlash.mainCamera.boundsFOV.left -offsetX) {
				return true;
			} else if(actor.px > CameraFlash.mainCamera.boundsFOV.right + offsetX) {
				return true;
			} else if(actor.py < CameraFlash.mainCamera.boundsFOV.top - offsetY) {
				return true;
			} else if(actor.py > CameraFlash.mainCamera.boundsFOV.bottom + offsetY) {
				return true;
			}
			return false;	
		}
		
		static public function addToActor(actor:Actor):LogicDestroyOutsideOfBounds {
			var result:LogicDestroyOutsideOfBounds = new LogicDestroyOutsideOfBounds();
			
			actor.addComponent(result);
			return result;
		}
	}
}
