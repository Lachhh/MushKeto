package com.berzerkrpg.effect.ui {
	import com.lachhh.ResolutionManager;
	import flash.geom.Rectangle;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.camera.CameraFlash;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class LogicDestroyOutsideOfBounds2 extends ActorComponent {
		static public var EMPTY_RECT:Rectangle = new Rectangle(); 
		public var bounds:Rectangle = EMPTY_RECT;
		public function LogicDestroyOutsideOfBounds2() {
			super();
		}

		override public function update() : void {
			super.update();
			if(actor.px < bounds.left -100) {
				actor.destroy();
			} else if(actor.px > bounds.right + 2500) {
				actor.destroy();
			}	
			
			if(actor.py < bounds.top - 100) {
				actor.destroy();
			} else if(actor.py > bounds.bottom + 300) {
				actor.destroy();
			}			
		}
		
		static public function addToActorBasedOnCamera(actor:Actor):LogicDestroyOutsideOfBounds2 {
			return addToActor(actor, CameraFlash.mainCamera.boundsFOV.clone());
		}
		
		static public function addToActorBasedOnUI(actor:Actor):LogicDestroyOutsideOfBounds2 {
			return addToActor(actor, new Rectangle(0,0,ResolutionManager.getGameWidth(),ResolutionManager.getGameHeight()));
		}
		
		static public function addToActor(actor:Actor, bounds:Rectangle):LogicDestroyOutsideOfBounds2 {
			var result:LogicDestroyOutsideOfBounds2 = new LogicDestroyOutsideOfBounds2();
			result.bounds = bounds;
			actor.addComponent(result);
			return result;
		}
	}
}
