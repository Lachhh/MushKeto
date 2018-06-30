package com.berzerkstudio.flash.geom {

	/**
	 * @author LachhhSSD
	 */
	public class Color {
		static public var white:Color = new Color(1, 1, 1, 1);
		public var r:Number ;
		public var g:Number ;
		public var b:Number ;
		public var a:Number ;
		
		public var redOffset:Number = 0;
		public var redMultiplier:Number = 0;
		public var greenOffset:Number = 0;
		public var greenMultiplier:Number = 0;
		public var blueOffset:Number = 0;
		public var blueMultiplier:Number = 0;
		
		public var alphaOffset:Number = 0;
		public var alphaMultiplier:Number = 1;
		public function Color(r:Number, g:Number, b:Number, a:Number) {
			SetTint(r, g, b, a);
			alphaOffset = 0;
			alphaMultiplier = 1;
		}
		
		/**
		 * Sets the tint!
		 * RGB values are 0-255, a is from 0-1.
		 */	
		public function SetTint(r:Number, g:Number, b:Number, a:Number):void{
			redMultiplier = 1.0 - a;
			greenMultiplier = 1.0 - a;
			blueMultiplier = 1.0 - a;
			redOffset = a * r;
			greenOffset = a * g;
			blueOffset = a * b;
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
		}
		
		public function copy(c:Color):void {
			SetTint(c.r, c.g, c.b, c.a);
			alphaMultiplier = c.alphaMultiplier;
			alphaOffset = c.alphaOffset;
		}
		
		public function concat(c:Color):void {
			redMultiplier *= c.redMultiplier;
			greenMultiplier *= c.greenMultiplier;
			blueMultiplier *= c.blueMultiplier;	
			redOffset += c.redOffset;
			greenOffset += c.greenOffset;
			blueOffset += c.blueOffset;
			
			alphaMultiplier *= c.alphaMultiplier;
		}
		
		public function clear():void {
			SetTint(0, 0, 0, 0);
			alphaOffset = 0;
			alphaMultiplier = 1;
		}
		
		public static function extractRed(c:uint):uint {
			return (( c >> 16 ) & 0xFF);
		}
		 
		public static function extractGreen(c:uint):uint {
			return ( (c >> 8) & 0xFF );
		}
		 
		public static function extractBlue(c:uint):uint {
			return ( c & 0xFF );
		}
		
		public static function combineRGB(r:uint, g:uint, b:int):uint{
			return ( (r << 16) | (g << 8) | b );
		}
		
		public function OffsetToUint():uint{
			return combineRGB(redOffset, greenOffset, blueOffset);
		}
		
		public function MultiplierToUint():uint{
			return combineRGB(redMultiplier * 255, greenMultiplier * 255, blueMultiplier * 255);
		}
		
		public function isTinted():Boolean {
			if(redOffset != 0) return true;
			if(greenOffset != 0) return true;
			if(blueOffset != 0) return true;
			if(alphaOffset != 0) return true;
			if(redMultiplier != 1) return true;
			if(greenMultiplier != 1) return true;
			if(blueMultiplier != 1) return true;
			if(alphaMultiplier != 1) return true;
			return false;

			/*!(MultiplierToUint() == 0xffffff && OffsetToUint() == 0x000000 && alphaMultiplier == 1.0 && alphaOffset == 0.0);*/
		}
	}
}
