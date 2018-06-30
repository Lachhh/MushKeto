package com.berzerkrpg.physics {
	/**
	 * @author LachhhSSD
	 */
	public class Circle {
		static public var circleTemp:Circle = new Circle(0, 0, 0);
		public var x:Number = 0;
		public var y:Number = 0;
		public var radius : Number = 0;

		public function Circle(pX:Number, pY:Number, pRadius:Number) {
			x = pX;
			y = pY;
			radius = pRadius;
		}
		
		public function intersectWithCircle(c:Circle):Boolean {
			var dx:Number = x-c.x;
			var dy:Number = y-c.y;
			var sumRadius:Number = radius+c.radius; 
			return (dx*dx+dy*dy) <= sumRadius*sumRadius;
		}
		
		static public function toCircleTemp(x:Number, y:Number, radius:Number):Circle {
			circleTemp.x = x;
			circleTemp.y = y;
			circleTemp.radius = radius;
			return circleTemp;
		} 
		
	}
}
