package com.berzerkstudio.flash.display {
	import com.berzerkstudio.flash.display.BzkBitmap;
	import flash.display.BitmapData;
	import com.lachhhStarling.OptimizedImage;
	import com.berzerkstudio.flash.display.DisplayObject;

	/**
	 * @author Shayne
	 */
	public class BzkBitmap extends DisplayObjectContainer {
		
		private var _image:OptimizedImage;
		
		public var textureWidth:int = 0;
		public var textureHeight : int = 0;
		
		public function BzkBitmap() {
			super();
		}
		
		public function get image():OptimizedImage{
			return _image;
		}
		
		public function setFromBitmapData(data:BitmapData):void{
			var flashBitmap:flash.display.Bitmap;
			flashBitmap = new flash.display.Bitmap(data);
			_image = OptimizedImage.fromBitmap(flashBitmap);
			textureWidth = _image.texture.width;
			textureHeight = _image.texture.height;
			//data.dispose();
		}
		
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
		
		public override function get isBitmap():Boolean{
			return true;
		}
		
		public static function fromBitmapData(data:BitmapData):BzkBitmap{
			var result:BzkBitmap = new BzkBitmap();
			result.setFromBitmapData(data);
			return result;
		}

		public function destroy() : void {
			_image.texture.dispose();
			
			
		}
	}
}
