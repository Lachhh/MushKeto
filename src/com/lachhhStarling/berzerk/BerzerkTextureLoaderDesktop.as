package com.lachhhStarling.berzerk {
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import starling.textures.TextureOptions;
	import com.berzerkstudio.flash.display.ShapeObject;
	import com.lachhhStarling.ModelFlaEnum;
	import com.lachhh.io.Callback;
	import starling.utils.AssetManager;

	import com.berzerkstudio.ModelFla;
	import com.lachhh.lachhhengine.VersionInfo;

	import flash.filesystem.File;
	/**
	 * @author LachhhSSD
	 */
	public class BerzerkTextureLoaderDesktop implements IBerzerkTextureLoader {
		public var assetManager : AssetManager;
		public var metaFlas : Vector.<MetaFla> = new Vector.<MetaFla>();		
		
		public function BerzerkTextureLoaderDesktop(pAssetManager : AssetManager) {
			assetManager = pAssetManager;
		}

		public function loadFla(modelFla : ModelFla) : MetaFla {
			var metaFla:MetaFla = getMetaFlaFromModel(modelFla);			
			
			if(!metaFla.canFlaBeLoaded()) return metaFla;
			metaFla.isAtlasLoading = true;

			var appDir:File = File.applicationDirectory;
			
			if(VersionInfo.isHDTexture) {
				assetManager.enqueue(
					appDir.resolvePath(VersionInfo.relativeFolderForStarling + "starlingHD/texturePackerAssets/" + modelFla.docName + modelFla.modelImageFormat.extension),
					appDir.resolvePath(VersionInfo.relativeFolderForStarling + "starlingHD/texturePackerAssets/" + modelFla.docName + ".xml")
				);
			} else {
				assetManager.enqueue(
					appDir.resolvePath(VersionInfo.relativeFolderForStarling + "starling/texturePackerAssets/" + modelFla.docName + modelFla.modelImageFormat.extension),
					appDir.resolvePath(VersionInfo.relativeFolderForStarling + "starling/texturePackerAssets/" + modelFla.docName + ".xml")
				);
			}
			
			assetManager.loadQueue(function(ratio:Number):void {
                if (ratio == 1) onComplete(metaFla);
            });
			return metaFla;
		}
		
		public function getMetaFlaFromModel(model:ModelFla):MetaFla {
			for (var i : int = 0; i < metaFlas.length; i++) {
				var m:MetaFla = metaFlas[i];
				if(m.modelFla.isEquals(model)) return m;
			}

			return createNewMetaFla(model);
		}

		private function createNewMetaFla(pModel : ModelFla) : MetaFla {
			var result:MetaFla = new MetaFla(pModel);
			metaFlas.push(result);
			return result;
		}
		
		private function onComplete(metaFla:MetaFla):void {
			metaFla.triggerLoaded();
		}
		
		public function unloadFla(modelFla : ModelFla) : MetaFla {
			var metaFla:MetaFla = getMetaFlaFromModel(modelFla);
			unloadMetaFla(metaFla);
			return metaFla;
		}
		
		public function unloadMetaFla(metaFla : MetaFla) : void {
			unloadSingularTexturesFromMetaFLA(metaFla);
			if(!metaFla.canFlaBeUnloaded()) return ;
			assetManager.removeTextureAtlas(metaFla.modelFla.docName);
			assetManager.removeXml(metaFla.modelFla.docName);
			metaFla.triggerUnloaded();
		}
		
		public function unloadAll() : void {
			for (var i : int = 0; i < metaFlas.length; i++) {
				var metaFla:MetaFla = metaFlas[i];
				unloadMetaFla(metaFla);
			}
			
			unloadAllSingularTextures();
		}

		public function isAtlasLoaded(modelFla : ModelFla) : Boolean {
			return getMetaFlaFromModel(modelFla).isAtlasLoaded;
		}
		
		public function isSingularTextureLoaded(metaDisplayObject:MetaDisplayObject) : Boolean {
			var metaFla:MetaFla = getMetaFlaFromModel(metaDisplayObject.modelFla);
			var meta:MetaSingularTexture = metaFla.getMetaSingularTextureFromName(metaDisplayObject.textureName);
			return meta.isLoaded;
		}
		
		public function loadSingularTexture(metaDisplayObject:MetaDisplayObject):void {
			var appDir:File = File.applicationDirectory;
			var metaFla:MetaFla = getMetaFlaFromModel(metaDisplayObject.modelFla);
			var modelFla:ModelFla = metaDisplayObject.modelFla;
			var meta:MetaSingularTexture = metaFla.getMetaSingularTextureFromName(metaDisplayObject.textureName);
			var textureName:String = meta.name;
			if(!meta.canBeLoaded()) return ;
			
			meta.triggerLoading();
			trace("SingularTexture Loading : " + textureName);
			
			if(VersionInfo.isHDTexture) {
				assetManager.enqueue(
					appDir.resolvePath(VersionInfo.relativeFolderForStarling + "starlingHD/texturesSingular/" + modelFla.docName + "/" + textureName+ ".png")
				);
			} else {
				assetManager.enqueue(
					appDir.resolvePath(VersionInfo.relativeFolderForStarling + "starling/texturesSingular/" + modelFla.docName + "/" + textureName + ".png")
				);
			}
			
			assetManager.loadQueue(function(ratio:Number):void {
				trace("SingularTexture Loaded : " + textureName);
                if (ratio == 1) meta.triggerLoaded();
            });			
		}
		
		public function unloadSingularTexture(metaDisplayObject:MetaDisplayObject) : void {
			var metaFla:MetaFla = getMetaFlaFromModel(metaDisplayObject.modelFla);
			var meta:MetaSingularTexture = metaFla.getMetaSingularTextureFromName(metaDisplayObject.textureName);
			if(!meta.isLoaded) return ;
			assetManager.removeTexture(meta.name);
			meta.triggerUnloaded();
		}
		
		public function unloadAllSingularTextures() : void {
			for(var i:int = 0; i < metaFlas.length; i++){
				unloadSingularTexturesFromMetaFLA(metaFlas[i]);
			}
		}
		
		public function unloadSingularTexturesFromFLA(modelFla:ModelFla):void{
			var meta:MetaFla = getMetaFlaFromModel(modelFla);
			unloadSingularTexturesFromMetaFLA(meta);
		}
		
		public function unloadSingularTexturesFromMetaFLA(metaFla:MetaFla):void{
			for (var i : int = 0; i < metaFla.singularTexturesLoaded.length; i++) {
				var meta:MetaSingularTexture = metaFla.singularTexturesLoaded[i];
				if(!meta.isLoaded) return ;
				assetManager.removeTexture(meta.name);
				meta.triggerUnloaded();
			}
		}
	}
}
