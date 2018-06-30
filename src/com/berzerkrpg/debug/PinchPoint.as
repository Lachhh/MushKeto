package com.berzerkrpg.debug {
	import starling.events.Touch;
	import flash.geom.Point;
	/**
	 * @author Lachhh
	 */
	public class PinchPoint {
		public var pivot:Point = new Point();
		public var radius:Number = 1;
		public var t1:Touch;
		public var t2:Touch;
		
		public function calculate(pT1:Touch, pT2:Touch):void {
			t1 = pT1;
			t2 = pT2;
			var dx:Number = (t2.globalX-t1.globalX);
			var dy:Number = (t2.globalY-t1.globalY);
			pivot.x = dx*0.5+t1.globalX;
			pivot.y = dy*0.5+t1.globalY;
			radius = Math.sqrt(dx*dx+dy*dy);
			
		}
		
		
	}
}