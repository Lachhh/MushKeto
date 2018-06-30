package com.berzerkstudio.flash.geom {
	import com.berzerkstudio.flash.meta.MetaColorTransform;
	public class ColorTransform {
			
		public var color:Color = new Color(0,0,0,0);
		public var concatColor:Color = new Color(0,0,0,0);
		
		public function ColorTransform() {
			
		}

		public function Concat(parent : ColorTransform) : void {
			concatColor.copy(color);
			concatColor.concat(parent.concatColor);
		}	
	
		public function LoadFromColorTransform(metaColor:MetaColorTransform):void {
			color.SetTint(metaColor.r, metaColor.g, metaColor.b, metaColor.a);
			color.alphaMultiplier = metaColor.alpha;
		}
				
		public function LoadFromString(s:String):void {
			if(s == null) {
				Dispose();
				return;
			}
		}
		
		public function Dispose():void {
			color.clear();
			concatColor.clear();
		}
		
		public function get isTinted():Boolean{
			return concatColor.isTinted();
		}
		
		public function transformColor(color:uint):uint{
			var r:Number, b:Number, g:Number, result:uint;
			r = Color.extractRed(color);
			g = Color.extractGreen(color);
			b = Color.extractBlue(color);
			r *= concatColor.redMultiplier;
			g *= concatColor.greenMultiplier;
			b *= concatColor.blueMultiplier;
			result = Color.combineRGB(r, g, b);
			result += concatColor.OffsetToUint();
			if(result > 0xffffff){
				result = 0xffffff;
			}
			if(result < 0x000000){
				result = 0x000000;
			}
			return result;
		}
		
		public static function isColorEqual(color1:ColorTransform, color2:ColorTransform):Boolean{
			if(color1 == null && color2 == null) return true;
			if(color1 == null || color2 == null) return false;
			
			var c1:Color = color1.concatColor;
			var c2:Color = color2.concatColor;
			
			return (c1.OffsetToUint() == c2.OffsetToUint() &&
					c1.MultiplierToUint() == c2.MultiplierToUint() &&
					c1.alphaMultiplier == c2.alphaMultiplier &&
					c1.alphaOffset == c2.alphaOffset);
		}
	}

}