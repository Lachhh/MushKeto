package com.berzerkstudio.flash.meta {
	/**
	 * @author LachhhSSD
	 */
	public class Vector3 {
		static public var zero:Vector3 = new Vector3(0, 0, 0);
		public var x:Number = 0;
		public var y:Number = 0;
		public var z : Number = 0;

		public function Vector3(x:Number, y:Number, z:Number) {
			this.x = x;
			this.y = y;
			this.z = z;
		}

	}
}
