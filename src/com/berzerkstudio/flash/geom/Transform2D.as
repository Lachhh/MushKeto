package com.berzerkstudio.flash.geom {
	import flash.geom.Rectangle;
	import starling.utils.VertexData;

	import com.berzerkstudio.flash.meta.Matrix4x4;
	import com.berzerkstudio.flash.meta.Meta2DMatrix;
	import com.berzerkstudio.flash.meta.Meta2DTransform;
	import com.lachhh.flash.FlashUtils;

	import flash.geom.Matrix;
	public class Transform2D {
		public var colorTransform:ColorTransform = new ColorTransform(); 
	
		//public var _matrix:Matrix4x4 = Matrix4x4.createIdentity();
		//public var concatenedMatrix:Matrix4x4 = Matrix4x4.createIdentity()  ;
		
		public var matrix2D:Matrix = new Matrix();
		public var concatenedMatrix2D:Matrix = new Matrix() ;
		public var maskConcatened:Rectangle ;
		
		public var concatenedRot:Number = 0;
		
		public var _rotation:Number = 0;
		public var _scaleX:Number = 1;
		public var _scaleY:Number = 1;
		public var _x:Number = 0;
		public var _y:Number = 0;
		private var _resolutionOffsetX:Number = 0;
		private var _resolutionOffsetY:Number = 0;
		private var _resolutionOffsetScaleX:Number = 1;
		private var _resolutionOffsetScaleY:Number = 1;
		public var isUniform:Boolean = true;
		public var _isDirty:Boolean = false;
		public var _isConcatenedDirty:Boolean = true;
		public var mustUpdateConcatened : Boolean = true; // Renderer handle this

		public function Transform2D() {
			
		}

		public function LoadFromTransform(metaTransform : Meta2DTransform) : void {
			_isDirty = false;
			_isConcatenedDirty = true;
			matrix2D.a = metaTransform.matrix.a;
			matrix2D.b = metaTransform.matrix.b;
			matrix2D.c = metaTransform.matrix.c;
			matrix2D.d = metaTransform.matrix.d;
			matrix2D.tx = metaTransform.matrix.tx;
			matrix2D.ty = metaTransform.matrix.ty;
			
			concatenedMatrix2D.a = 1;
			concatenedMatrix2D.b = 0;
			concatenedMatrix2D.c = 0;
			concatenedMatrix2D.d = 1;
			concatenedMatrix2D.tx = 0;
			concatenedMatrix2D.ty = 0;
			
			concatenedRot = 0 ; 
			
			var m:Meta2DMatrix = metaTransform.GetMatrix();
			if(metaTransform.isUniform) {
				_rotation = metaTransform.rotation;
				_scaleX = metaTransform.scaleX;
				_scaleY = metaTransform.scaleY;
				_x = metaTransform.matrix.tx;
				_y = metaTransform.matrix.ty;
				isUniform = true;
				
				
				matrix2D.a = m.a;
				matrix2D.b = m.b;
				matrix2D.c = m.c;
				matrix2D.d = m.d;
				matrix2D.tx = m.tx;
				matrix2D.ty = m.ty;
			} else {
				LoadFromMatrix(m);
			}
			
			if(hasResolutionOffset()) _isDirty = true;
			
			
			colorTransform.LoadFromColorTransform(metaTransform.colorTransform);
			mustUpdateConcatened = true;
		}
		
		public function LoadFromMatrix(m:Meta2DMatrix):void {
			
			_x = m.tx ;
			_y = m.ty ;
	
			_rotation = Math.asin(m.c);
			if(-m.b == m.c && !FlashUtils.myIsNan(_rotation)) {
				isUniform = true;
				var cos:Number = Math.cos(_rotation);
				_scaleX = m.a/cos;
				_scaleY = m.d/cos;
			} else {
				isUniform = false;
				_rotation = 0;  
			}
			_isDirty = false;
		}
		
		public function Dispose():void {
			isUniform = true;
			_isConcatenedDirty = true;
			
			matrix2D.a = 1; //a
			matrix2D.b = 0; //c
			matrix2D.c = 0; //b
			matrix2D.d = 1; //d
			matrix2D.tx = 0; //tx
			matrix2D.ty = 0; //ty
			
			concatenedMatrix2D.a = 1;
			concatenedMatrix2D.b = 0;
			concatenedMatrix2D.c = 0;
			concatenedMatrix2D.d = 1;
			concatenedMatrix2D.tx = 0; //tx
			concatenedMatrix2D.ty = 0; //ty
			
			mustUpdateConcatened = true;
			_rotation = 0 ; 
			_scaleX = 1;
			_scaleY = 1;
			_x = 0 ;
			_y = 0 ; 
			
			_resolutionOffsetX = 0;
			_resolutionOffsetY = 0;
			_resolutionOffsetScaleX = 1;
			_resolutionOffsetScaleY = 1;
		}
		
		public function CalcMatrix():void {
			if(isUniform) {
				//var sin:Number = Mathf.Sin(_rotation);
				var cos:Number = Math.cos(_rotation);
	
				matrix2D.a = (_scaleX*_resolutionOffsetScaleX)*cos; //a
				//matrix2D.c = _scaleX*Math.sin(_rotation); //c
				//matrix2D.b = -_scaleY*Math.sin(_rotation); //b

				matrix2D.c = Math.sin(_rotation); //c
				matrix2D.b = -matrix2D.c; //b
				matrix2D.d = (_scaleY*_resolutionOffsetScaleY)*cos; //d
				matrix2D.tx = _x+_resolutionOffsetX; //tx
				matrix2D.ty = _y+_resolutionOffsetY; //ty
				
			} else {			
				
				matrix2D.tx = _x+_resolutionOffsetX; //tx
				matrix2D.ty = _y+_resolutionOffsetY; //ty
			}
			
			_isDirty = false;
		}
		
		public function GetMatrix():Matrix {
			if(!_isDirty) return matrix2D;
			CalcMatrix();
			//mustUpdateConcatened = true;
			return matrix2D;
		}
		
		/*public function toString():String {
			return isUniform + "/" + _matrix.ToString();
		}*/
		
		public function set x(value:Number):void{
			if(_x != value) {
				_x = value; 
				_isDirty = true;
				mustUpdateConcatened = true;
			}
		}
		public function get x():Number{return _x ;}
		
		public function set y(value:Number):void{
			if(_y != value) {
				_y = value; 
				_isDirty = true;
				mustUpdateConcatened = true;
			}
		}
		public function get y():Number{return _y ;}
		
		public function set scaleX(value:Number):void{
			if(_scaleX != value) {
				_scaleX = value; 
				_isDirty = true;
				mustUpdateConcatened = true;
			}
		}
		public function get scaleX():Number{return _scaleX ;}
		
		public function set scaleY(value:Number):void{
			if(_scaleY != value) {
				_scaleY = value; 
				_isDirty = true;
				mustUpdateConcatened = true;
			}
		}
		public function get scaleY():Number{return _scaleY ;}
		
		public function set rotation(value:Number):void{
			var newValue:Number = ((-value)/180)*Math.PI;
			if(_rotation != newValue) {
				_rotation = newValue; 
				_isDirty = true;
				mustUpdateConcatened = true;
			}
		}
		public function get rotation():Number{return (-_rotation)/Math.PI*180 ;}
		
		public function setConcatenedMask(localRect:Rectangle):void {
			if(maskConcatened == null) maskConcatened = new Rectangle();
			maskConcatened.x = concatenedMatrix2D.tx + localRect.x - (x+_resolutionOffsetX);
			maskConcatened.y = concatenedMatrix2D.ty + localRect.y - (y+_resolutionOffsetY);
			maskConcatened.width = localRect.width;
			maskConcatened.height = localRect.height;
		}

		public function get resolutionOffsetX() : Number {
			return _resolutionOffsetX;
		}

		public function set resolutionOffsetX(value : Number) : void {
			if(_resolutionOffsetX != value) {
				_resolutionOffsetX = value; 
				_isDirty = true;
				mustUpdateConcatened = true;
			}
		}

		public function get resolutionOffsetY() : Number {
			return _resolutionOffsetY;
		}

		public function set resolutionOffsetY(value : Number) : void {
			if(_resolutionOffsetY != value) {
				_resolutionOffsetY = value; 
				_isDirty = true;
				mustUpdateConcatened = true;
			}
		}
		
		public function get resolutionOffsetScaleX() : Number {
			return _resolutionOffsetScaleX;
		}

		public function set resolutionOffsetScaleX(value : Number) : void {
			if(_resolutionOffsetScaleX != value) {
				_resolutionOffsetScaleX = value; 
				_isDirty = true;
				mustUpdateConcatened = true;
			}
		}

		public function get resolutionOffsetScaleY() : Number {
			return _resolutionOffsetScaleY;
		}

		public function set resolutionOffsetScaleY(value : Number) : void {
			if(_resolutionOffsetScaleY != value) {
				_resolutionOffsetScaleY = value; 
				_isDirty = true;
				mustUpdateConcatened = true;
			}
		}
		
		public function hasResolutionOffset():Boolean {
			if(_resolutionOffsetX != 0) return true;
			if(_resolutionOffsetY != 0) return true;
			if(_resolutionOffsetScaleX != 0) return true;
			if(_resolutionOffsetScaleY != 0) return true;
			return false;
		}
	
	}
}