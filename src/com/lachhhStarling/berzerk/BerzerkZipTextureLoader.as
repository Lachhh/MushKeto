package com.lachhhStarling.berzerk {
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.lachhh.io.Callback;
	import deng.fzip.FZipFile;

	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	import com.berzerkstudio.ModelFla;

	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display3D.Context3DTextureFormat;
	import flash.events.Event;
	/**
	 * @author Shayne
	 */
	public class BerzerkZipTextureLoader implements IBerzerkTextureLoader{
		public var assetManager : AssetManager;	
		public var metaFlas : Vector.<MetaFla> = new Vector.<MetaFla>();
		
		public var zipManager:ZipAssetManager;
		
		private var _helperTexture:Texture;
		private var _helperTextureAtlas:TextureAtlas;
		
		
		public function BerzerkZipTextureLoader(pZipManager:ZipAssetManager, pAssetManager:AssetManager){
			assetManager = pAssetManager;
			this.zipManager = pZipManager;
			
			//bitmapLoader = new Loader();
		}
		
		private var _helperZipFile:FZipFile;
		
		public function loadFla(modelFla : ModelFla) : MetaFla {
			var metaFla:MetaFla = getMetaFlaFromModel(modelFla);
			if(!metaFla.canFlaBeLoaded()) return metaFla;
			if(zipManager.isLoading) return metaFla;
			if(assetManager.getTextureAtlas(modelFla.docName) != null) return metaFla;
			
			
			metaFla.isAtlasLoading = true;
			
			var flaFileName:String = "texturePackerAssets/" + modelFla.docName;
			var extension:String = modelFla.modelImageFormat.extension;
			
			_helperZipFile = zipManager.fZip.getFileByName(flaFileName + extension);
			
			if(metaFla.modelFla.modelImageFormat.isATF()){
				loadATF(_helperZipFile, metaFla);
			} else {
				var loadTexture : BerzerkZipTextureLoaderRequest = new BerzerkZipTextureLoaderRequest(metaFla);
				loadTexture.textureName = modelFla.docName + extension;
				loadTexture.onLoaded = new Callback(onMetaFlaLoaded, this, [loadTexture]);
				
				loadTexture.load(_helperZipFile);
			}
			return metaFla;
		}
		
	
		
		private function onMetaFlaLoaded(request:BerzerkZipTextureLoaderRequest):void{
			var textureFormat:String = Context3DTextureFormat.BGRA;
			_helperTexture = Texture.fromBitmapData(request.helperBitmapData, false, false, 1, textureFormat, false);
			
			var flaFileName:String = "texturePackerAssets/" + request.metaFla.modelFla.docName;
			
			_helperZipFile = zipManager.fZip.getFileByName(flaFileName + ".xml");
			
			var xml:XML = new XML(_helperZipFile.getContentAsString(false));
			
			assetManager.addXml(request.metaFla.modelFla.docName, xml);
			
			_helperTextureAtlas = new TextureAtlas(_helperTexture, xml);

			assetManager.addTextureAtlas(request.metaFla.modelFla.docName, _helperTextureAtlas);
			
			// Don't dispose TextureAtlas!
			request.helperBitmapData.dispose();
			
			assetManager.loadQueue(function(ratio:Number):void
            {
                if (ratio == 1) onComplete(request.metaFla);
            });
		}
		
		private function loadATF(data:FZipFile, metaFla:MetaFla):void{
			_helperTexture = Texture.fromAtfData(data.content, 1, false, function(result:Texture):void{
				var flaFileName:String = "texturePackerAssets/" + metaFla.modelFla.docName;
				_helperZipFile = zipManager.fZip.getFileByName(flaFileName + ".xml");
				var xml:XML = new XML(_helperZipFile.getContentAsString(false));
				assetManager.addXml(metaFla.modelFla.docName, xml);
				_helperTextureAtlas = new TextureAtlas(result, xml);
				assetManager.addTextureAtlas(metaFla.modelFla.docName, _helperTextureAtlas);
				assetManager.loadQueue(function(ratio:Number):void
            	{
            	    if (ratio == 1) onComplete(metaFla);
            	});
			}, false);
			
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

		public function isAtlasLoaded(modelFla : ModelFla) : Boolean {
			return getMetaFlaFromModel(modelFla).isAtlasLoaded;
		}

		public function isSingularTextureLoaded(metaDisplayObject:MetaDisplayObject) : Boolean {
			var metaFla:MetaFla = getMetaFlaFromModel(metaDisplayObject.modelFla);
			var meta:MetaSingularTexture = metaFla.getMetaSingularTextureFromName(metaDisplayObject.textureName);
			return meta.isLoaded;
		}

		public function loadSingularTexture(metaDisplayObject:MetaDisplayObject) : void {
			if(zipManager.isLoading) return;
			var metaFla:MetaFla = getMetaFlaFromModel(metaDisplayObject.modelFla);
			var modelFla:ModelFla = metaDisplayObject.modelFla;
			var meta:MetaSingularTexture = metaFla.getMetaSingularTextureFromName(metaDisplayObject.textureName);
			var textureName:String = meta.name;
			if(!meta.canBeLoaded()) return ;
			
			meta.triggerLoading();
			trace("SingularTexture Loading : " + textureName);
			var fileName:String = "texturesSingular/" + modelFla.docName + "/" + textureName + ".png";
			_helperZipFile = zipManager.fZip.getFileByName(fileName);
			var loadTexture : BerzerkZipTextureLoaderRequest = new BerzerkZipTextureLoaderRequest(metaFla);
			loadTexture.textureName = textureName;
			loadTexture.onLoaded = new Callback(onSingularTextureLoaded, this, [loadTexture, meta]);	
			loadTexture.load(_helperZipFile);
		}
		
		private function onSingularTextureLoaded(request:BerzerkZipTextureLoaderRequest, metaSingularTexture:MetaSingularTexture):void{
			var textureFormat:String = Context3DTextureFormat.BGRA;
			_helperTexture = Texture.fromBitmapData(request.helperBitmapData, false, false, 1, textureFormat, false);
			assetManager.addTexture(request.textureName, _helperTexture);
			metaSingularTexture.triggerLoaded();
			
			// Don't dispose Texture!
			request.helperBitmapData.dispose();
			trace("SingularTexture Loaded : " + request.textureName);
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
