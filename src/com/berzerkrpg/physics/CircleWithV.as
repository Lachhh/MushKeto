package com.berzerkrpg.physics {

	/**
	 * @author LachhhSSD
	 */
	public class CircleWithV extends Circle {
		static public var circleTemp:CircleWithV = new CircleWithV(0, 0, 0);
		public var vx:Number = 0;
		public var vy:Number = 0;
		public function CircleWithV(pX : Number, pY : Number, pRadius : Number) {
			super(pX, pY, pRadius);
		}
		
		static public function toCircleWithVTemp(x:Number, y:Number, radius:Number, vx:Number, vy:Number):CircleWithV {
			circleTemp.x = x;
			circleTemp.y = y;
			circleTemp.radius = radius;
			circleTemp.vx = vx;
			circleTemp.vy = vy;
			return circleTemp;
		} 
	}
}
