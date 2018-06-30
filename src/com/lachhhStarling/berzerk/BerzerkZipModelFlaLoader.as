package com.lachhhStarling.berzerk {
	import deng.fzip.FZipFile;

	import com.berzerkstudio.ModelFla;
	import com.lachhh.io.Callback;
	import com.lachhhStarling.ModelFlaEnum;

	/**
	 * @author Shayne
	 */
	public class BerzerkZipModelFlaLoader implements IBerzerkModelFlaLoader {
		
		private var zipManager:ZipAssetManager;
		
		private var callbackOnEnd:Callback ;
		
		private var crntModel : ModelFla;
		private var frFile : FZipFile;
		private var modelFlaBunch : Vector.<ModelFla>;

		public function BerzerkZipModelFlaLoader(pZipManager : ZipAssetManager) {
			zipManager = pZipManager;
		}
		
		public function loadAllFlas(onEndCallback : Callback) : void {
			loadBunch(ModelFlaEnum.ALL.slice(), onEndCallback);
		}
		
		private function loadNextFla() : void {
			crntModel = getFirstNotInit();
			if (crntModel.isNull) {
				if(callbackOnEnd) callbackOnEnd.call();
				return ;
			}
			
			frFile = zipManager.fZip.getFileByName("modelFla/" + crntModel.id + ".asset");
			
			if(frFile != null){
				crntModel.loadFromByteArray(frFile.content);
				loadNextFla();
			}
			else{
				throw new Error("File for ModelFla not found in ZIP file: " + "modelFla/" + crntModel.id + ".asset");
			}
		}

		private function getFirstNotInit() : ModelFla {
			return ModelFlaEnum.getFirstNotInitIn(modelFlaBunch) ;
		}

		public function loadModelFlaAsset(m : ModelFla, onEndCallback : Callback) : void {
			var array:Vector.<ModelFla> = new Vector.<ModelFla>();
			array.push(m);
			loadBunch(array, onEndCallback);
		}

		public function loadBunch(m : Vector.<ModelFla>, onEndCallback : Callback) : void {
			ModelFla.registerClassForSerialization();
			callbackOnEnd = onEndCallback;
			modelFlaBunch = m;
			loadNextFla();
		}

		public function isModelFlaAssetLoaded(model : ModelFla) : Boolean {
			return model.isLoaded;
		}
	}
}
