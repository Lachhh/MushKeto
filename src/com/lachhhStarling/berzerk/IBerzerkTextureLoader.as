package com.lachhhStarling.berzerk {
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.berzerkstudio.ModelFla;
	/**
	 * @author LachhhSSD
	 */
	public interface IBerzerkTextureLoader {
		function loadFla(modelFla:ModelFla):MetaFla

		function unloadFla(modelFla : ModelFla) : MetaFla
		function getMetaFlaFromModel(modelFla : ModelFla) : MetaFla

		function isAtlasLoaded(modelFla : ModelFla) : Boolean;
		
		function isSingularTextureLoaded(metaDisplayObject:MetaDisplayObject) : Boolean 	
		function loadSingularTexture(metaDisplayObject:MetaDisplayObject):void 
		function unloadSingularTexture(metaDisplayObject:MetaDisplayObject) : void
		function unloadSingularTexturesFromFLA(modelFla:ModelFla):void 
		function unloadAllSingularTextures() : void 
		
	}
}
