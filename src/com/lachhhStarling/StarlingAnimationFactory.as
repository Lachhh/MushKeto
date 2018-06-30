package com.lachhhStarling {
	import starling.textures.Texture;
	/**
	 * @author LachhhSSD
	 */
	public class StarlingAnimationFactory {
		static public var cachedImg:Vector.<OptimizedImage> = new Vector.<OptimizedImage>(); 
		static public function createImg(id:String):OptimizedImage {
			var t:Texture = StarlingMain.starlingAssets.getTexture(id);
			var result:OptimizedImage = new OptimizedImage(t);
			return result;
		}
		
		static public function getImage(id:String):OptimizedImage {
			 if(cachedImg.length <= 0) return createImg(id);
			 
			 var result:OptimizedImage = cachedImg.pop();
			 result.texture = StarlingMain.starlingAssets.getTexture(id);
			 result.touchable = false;
			 //result.
			 result.readjustSize();
			 return result;
		}
		 
		static public function cacheImage(i:OptimizedImage):void {
			cachedImg.push(i);
		}
		
	}
}
