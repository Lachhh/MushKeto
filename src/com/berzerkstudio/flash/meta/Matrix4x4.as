package com.berzerkstudio.flash.meta {
	import flash.geom.Matrix3D;
	/**
	 * @author LachhhSSD
	 */
	public class Matrix4x4 extends Matrix3D{
		private var v0:Vector4 = new Vector4();
		private var v1:Vector4 = new Vector4();
		private var v2 : Vector4 = new Vector4();
		private var v3 : Vector4 = new Vector4();

		public function Matrix4x4() {
		}

		public function GetColumn(i : int) : Vector4 {
			if(i == 0) {copyColumnTo(i, v0); return v0;}
			if(i == 1) {copyColumnTo(i, v1); return v1;}
			if(i == 2) {copyColumnTo(i, v2); return v2;}
			if(i == 3) {copyColumnTo(i, v3); return v3;}
			
			return null;
		}
		
		public function SetColumn(i:int, v:Vector4):void {
			copyColumnTo(i, v);
		}
		
		public function multiply(m:Matrix4x4):Matrix4x4 {
			append(m);
			return this;
		}

		public function MultiplyPoint3x4(verts : Vector3) : Vector3 {
			return null;
		}
		
		public function get m00():Number {return v0.x ;}
		public function get m01():Number {return v0.y ;}
		public function get m02():Number {return v0.z ;}
		public function get m03():Number {return v0.w ;}
		
		public function get m10():Number {return v1.x ;}
		public function get m11():Number {return v1.y ;}
		public function get m12():Number {return v1.z ;}
		public function get m13():Number {return v1.w ;}
		
		public function get m20():Number {return v2.x ;}
		public function get m21():Number {return v2.y ;}
		public function get m22():Number {return v2.z ;}
		public function get m23():Number {return v2.w ;}
		
		public function get m30():Number {return v3.x ;}
		public function get m31():Number {return v3.y ;}
		public function get m32():Number {return v3.z ;}
		public function get m33():Number {return v3.w ;}
		

		public function set m00(value : Number) : void {v0.x = value;}
		public function set m01(value : Number) : void {v0.y = value;}
		public function set m02(value : Number) : void {v0.z = value;}
		public function set m03(value : Number) : void {v0.w = value;}
		
		public function set m10(value : Number) : void {v1.x = value;}
		public function set m11(value : Number) : void {v1.y = value;}
		public function set m12(value : Number) : void {v1.z = value;}
		public function set m13(value : Number) : void {v1.w = value;}
	
		public function set m20(value : Number) : void {v2.x = value;}
		public function set m21(value : Number) : void {v2.y = value;}
		public function set m22(value : Number) : void {v2.z = value;}
		public function set m23(value : Number) : void {v2.w = value;}
		
		public function set m30(value : Number) : void {v3.x = value;}
		public function set m31(value : Number) : void {v3.y = value;}
		public function set m32(value : Number) : void {v3.z = value;}
		public function set m33(value : Number) : void {v3.w = value;}
		
		static public function createIdentity():Matrix4x4 {
			var result:Matrix4x4 = new Matrix4x4();
			result.identity();
			
			return result;
		}
		
		
	}
}
