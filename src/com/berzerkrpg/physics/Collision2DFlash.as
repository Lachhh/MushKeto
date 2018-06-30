package com.berzerkrpg.physics {
	import flash.geom.Point;
	/**
	 * @author LachhhSSD
	 */
	public class Collision2DFlash {
		public var distV1:Number ;
		public var distV2:Number ;
		public var pFirstCollision:Point ;
		public var pFinal:Point ;
		public var vecFinal:Point ;
		public var vecRebound:Point ;
		public var vecAng:Point ;
		public var vecFollow:Point ;
		public var vecFollowSansPerte:Point ;
		public var line:Line ;
		public var sens:Number ;
		public var pointOfCollision:Circle ;
		
		
		public function Collision2DFlash() {
			//DO nothing
		}
	
		public function IsWithCircle():Boolean {
			return (pointOfCollision != null); 	
		}
	}
}
