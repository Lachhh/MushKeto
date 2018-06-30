//@script Serializable
package com.berzerkstudio.flash.meta {
	import com.lachhh.flash.FlashUtils;
	public class Meta2DTransform {
		public var matrix:Meta2DMatrix ;
		public var colorTransform:MetaColorTransform ;
		
		private var _rotation:Number = 0;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		
		private var _isUniform:Boolean = false;
		
		private var _isDirty:Boolean = true;
		//private var _matrix3D:Matrix4x4 = Matrix4x4.createIdentity();
		
		public function Meta2DTransform() {
			matrix = new Meta2DMatrix();
			colorTransform = new MetaColorTransform();
		}
		
		public function LoadFromFromRows(row0:Vector4, row1:Vector4):void {
			matrix.a = row0.x ; 
			matrix.b = row0.y ; 
			matrix.c = row1.x ; 
			matrix.d = row1.y ; 
			matrix.tx = row0.w ; 
			matrix.ty = row1.w ; 
		}
		
		public function GetMatrix():Meta2DMatrix {
			if( !_isDirty) return matrix;
									
			
			if(canCalculateScaleFromMatrix()) {
				_isUniform = true;
				_rotation = Math.sin(matrix.c);
				var cos:Number = Math.cos(_rotation);
				_scaleX = matrix.a/cos;
				_scaleY = matrix.d/cos;
			} else {
				_isUniform = false;
				_rotation = 0;  
			}
			
			if(_scaleX <= 0.002 && _scaleX > 0) {
				_scaleX = 0;
			}
			
			
			
			_isDirty = false;
			return matrix;
		}
		
		private function canCalculateScaleFromMatrix():Boolean {
			if(-matrix.b != matrix.c) return false;
			if(isTooCloseToZero(matrix.a) && isTooCloseToZero(matrix.d)) return false;
			if(FlashUtils.myIsNan(Math.sin(matrix.c))) return false;
			 
			return false;
		}
		
		private function isTooCloseToZero(n:Number):Boolean {
			if(n < 0) return false;
			if(n > 0.01) return false;
			return true;
		}
		
		public function get isUniform():Boolean { return _isUniform;};
		public function get rotation():Number { return _rotation;};
		public function get scaleX():Number { return _scaleX;};
		public function get scaleY():Number { return _scaleY;};
		public function get x():Number { return _x;};
		public function get y():Number { return _y;};
	}
}