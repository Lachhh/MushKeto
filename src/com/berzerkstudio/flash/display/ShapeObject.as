package com.berzerkstudio.flash.display {
	import starling.textures.Texture;
	import starling.utils.VertexData;

	import com.berzerkstudio.flash.meta.MetaDisplayObject;

	import flash.geom.Matrix;
	public class ShapeObject extends DisplayObject {
		public var packedSpriteframe:int;
		public var textureWidth:int = 0;
		public var textureHeight : int = 0;
		public var anchorX : Number;
		public var anchorY : Number;
		public var vertexData : VertexData;
		public var needToRefreshVertexData:Boolean = false;
		

		public function ShapeObject() {
			
		}

		override public function LoadFromMeta(m : MetaDisplayObject) : void {
			super.LoadFromMeta(m);
			//prefabId = m.prefabId;
			//prefabName = m.prefabName;
			packedSpriteframe = m.packedSpriteframe;
			textureWidth = m.width;
			textureHeight = m.height;
			hitArea.width = m.width;
			hitArea.height = m.height;
			
			anchorX = m.anchorX;
			anchorY = m.anchorY;
		}
		
		public function refreshVertexData(t:Texture, matrix:Matrix, premulAlpha:Boolean = true):void {
			
			if(vertexData == null) {
				vertexData = new VertexData(4, premulAlpha);
				refreshTextCoord(t);
			}
			
			if(!needToRefreshVertexData) return ;
			needToRefreshVertexData = false;
			
			refreshVerticesPosition(0, matrix, 0, 0);
			refreshVerticesPosition(1, matrix, textureWidth, 0);
			refreshVerticesPosition(2, matrix, 0, textureHeight);
			refreshVerticesPosition(3, matrix, textureWidth, textureHeight);
		}
		
		public function refreshTextCoord(t:Texture):void {
			if(vertexData == null) {
				vertexData = new VertexData(4, false);
			}
			vertexData.setTexCoords(0, 0, 0);
			vertexData.setTexCoords(1, 1, 0);
			vertexData.setTexCoords(2, 0, 1);
			vertexData.setTexCoords(3, 1, 1);
			t.adjustVertexData(vertexData, 0, 4);
			needToRefreshVertexData = true;
		}
		
		private function refreshVerticesPosition(index:int, matrix:Matrix, x:int, y:int):void {
			var newX:int = matrix.a * x + matrix.c * y + matrix.tx;
            var newY:int = matrix.d * y + matrix.b * x + matrix.ty;
			vertexData.setPosition(index, newX, newY);
		}
		
		/*private function refreshVerticesCoord(index:int, matrix:Matrix, x:int, y:int):void {
			var newX:int = matrix.a * x + matrix.c * y + matrix.tx;
            var newY:int = matrix.d * y + matrix.b * x + matrix.ty;
			vertexData.setTexCoords(index, newX, newY);
		}*/
		
		override public function get width() : Number {
			return textureWidth*scaleX ;
		}

		override public function get height() : Number {
			return textureHeight*scaleY ;
		}

		override public function set width(value : Number) : void {
			var scale:Number = value/textureWidth;
			scaleX = scale;
		}

		override public function set height(value : Number) : void {
			var scale:Number = value/textureHeight;
			scaleY = scale;
		}

		override public function get isShape() : Boolean {
			return true ;
		}
	}

}