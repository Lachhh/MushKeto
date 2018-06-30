package com.lachhhStarling.berzerk {
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.lachhh.io.CallbackGroup;
	import com.berzerkstudio.ModelFla;
	/**
	 * @author LachhhSSD
	 */
	public class MetaFla {
		public var modelFla : ModelFla;
		public var isAtlasLoaded:Boolean = false;
		public var isAtlasLoading:Boolean = false;
		
		public var isModelFlaAssetLoaded:Boolean = false;
		public var isModelFlaAssetLoading:Boolean = false;
		public var callbacksOnLoaded:CallbackGroup = new CallbackGroup();
		public var callbacksOnUnloaded:CallbackGroup = new CallbackGroup();
		
		public var singularTexturesLoaded:Vector.<MetaSingularTexture> = new Vector.<MetaSingularTexture>();
		
		public function MetaFla(pModel:ModelFla) {
			modelFla = pModel;
		}
		
		public function getMetaSingularTextureFromName(name:String):MetaSingularTexture{
			for (var i : int = 0; i < singularTexturesLoaded.length; i++) {
				if(singularTexturesLoaded[i].name == name) return singularTexturesLoaded[i]; 
			}
			var result:MetaSingularTexture = new MetaSingularTexture(name);
			singularTexturesLoaded.push(result);
			return result;
		}
		
		public function canFlaBeLoaded():Boolean {
			if(isAtlasLoaded) return false;
			if(isAtlasLoading) return false;
			if(modelFla.isNull) return false;
			return true;
		}
		
		public function canFlaBeUnloaded():Boolean {
			if(!isAtlasLoaded) return false;
			if(isAtlasLoading) return false;
			if(modelFla.isNull) return false;
			return true;
		}
		
		public function triggerLoaded():void {
			isAtlasLoaded = true;
			modelFla.isTextureLoaded = true;
			isAtlasLoading = false;
			callbacksOnLoaded.call();
			callbacksOnLoaded.clear();
		}
		
		public function triggerUnloaded():void {
			isAtlasLoaded = false;
			isAtlasLoading = false;
			modelFla.isTextureLoaded = false;
			callbacksOnUnloaded.call();
			callbacksOnUnloaded.clear();
		}
		
		public function triggerModelFlaAssetLoaded():void {
			isModelFlaAssetLoaded = true;
			isModelFlaAssetLoading = false;
		}
		
		public function triggerModelFlaAssetUnloaded():void {
			isModelFlaAssetLoaded = false;
			isModelFlaAssetLoading = false;
		}
		
	}
}
