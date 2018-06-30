package com.berzerkstudio.flash.meta {
	import flash.geom.Vector3D;
	/**
	 * @author LachhhSSD
	 */
	public class Vector4 extends Vector3D{
		
		static public function create(x:Number, y:Number, z:Number, w:Number):Vector4 {
			var result:Vector4 = new Vector4();
			result.x = x;
			result.y = y;
			result.z = z;
			result.w = w;
			return result;
		}
		
	}
}
