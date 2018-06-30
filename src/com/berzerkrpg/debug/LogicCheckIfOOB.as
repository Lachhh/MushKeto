package com.berzerkrpg.debug {
	import flash.geom.Rectangle;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author Lachhh
	 */
	public class LogicCheckIfOOB extends ActorComponent {
		public var bounds : Rectangle = new Rectangle();
		private var offsetX : int = 100;
		private var offsetY : int = 100;

		public function LogicCheckIfOOB() {
			super();
		}
		
		public function isOOB():Boolean {			
			if(actor.physicComponent) return isOOBWithPhysics();
			if((actor.px < bounds.left-offsetX)) return true;
			if((actor.px > bounds.right+offsetX)) return true;
			if(actor.py < bounds.top-offsetY) return true;
			if(actor.py > bounds.bottom+offsetY) return true;
			return false; 
		}
		
		private function isOOBWithPhysics():Boolean {			
			var goingRight:Boolean = (actor.physicComponent.vx > 0);
			if(!goingRight && (actor.px < bounds.left-offsetX)) return true;
			if(goingRight && (actor.px > bounds.right+offsetX)) return true;
			if(actor.py < bounds.top-offsetY) return true;
			if(actor.py > bounds.bottom+offsetY) return true;
			return false; 
		}
	}
}