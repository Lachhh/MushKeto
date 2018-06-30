package com.berzerkstudio {
	import com.lachhhStarling.berzerk.IBerzerkModelFlaLoader;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhhStarling.ModelFlaEnum;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	/**
	 * @author LachhhSSD
	 */
	public class ModelFlaLoaderLoadFromDisk implements IBerzerkModelFlaLoader{
		
		private var callbackOnEndBatch:Callback ;
		private var callbackOnEndSingle:Callback ;
		
		private var crntModel : ModelFla;
		private var frFile : File;
		private var modelFlaBunchToLoad : Vector.<ModelFla>;

		public function ModelFlaLoaderLoadFromDisk() {
		}

		public function loadAllFlas(pCallbackOnEnd : Callback) : void {
			loadBunch(ModelFlaEnum.ALL.slice(), pCallbackOnEnd);
		}
		
		private function loadNextFla():void {
			
			crntModel = getFirstNonInitInBunch();
			if(crntModel.isNull) {
				callbackOnEndBatch.call();
				return ;
			}
			
			loadModelFlaAsset(crntModel, new Callback(loadNextFla, this, null));
		}
		
		public function loadModelFlaAsset(m:ModelFla, callbackOnFinish:Callback):void {
			ModelFla.registerClassForSerialization();
			callbackOnEndSingle = callbackOnFinish;
			crntModel = m;
			frFile = File.applicationDirectory.resolvePath(VersionInfo.relativeFolderForStarling + "starling/modelFla/" + m.id + ".asset");
			
			if(frFile.exists){
				frFile.addEventListener(Event.COMPLETE, onByteDataLoaded);
				frFile.addEventListener(IOErrorEvent.IO_ERROR, onByteDataFailure);
				frFile.load();
			} else {
				throw new Error("File for ModelFla not found : " + VersionInfo.relativeFolderForStarling + "starling/modelFla/" + m.id + ".asset");
			}
		}

		private function onByteDataLoaded(event : Event) : void {
			frFile.removeEventListener(Event.COMPLETE, onByteDataLoaded);
			crntModel.loadFromByteArray(frFile.data);
			if(callbackOnEndSingle) callbackOnEndSingle.call();
		}
		
		private function onByteDataFailure(event:Event):void{
			throw new Error("Failed loading byte data for: " + crntModel.id + ".asset");
		}

		public function isModelFlaAssetLoaded(model : ModelFla) : Boolean {
			return model.isLoaded;
		}

		private function getFirstNonInitInBunch() : ModelFla {
			return ModelFlaEnum.getFirstNotInitIn(modelFlaBunchToLoad);
		}

		public function loadBunch(m : Vector.<ModelFla>, pCallbackOnEnd : Callback) : void {
			ModelFla.registerClassForSerialization();
			callbackOnEndBatch = pCallbackOnEnd;			
			modelFlaBunchToLoad = m;
			loadNextFla();			
		}

		public function loadAllFlasASync(callback : Callback) : void {
			for (var i : int = 0; i < ModelFlaEnum.ALL.length; i++) {
				var newRequest:ModelFlaLoaderLoadFromDisk = new ModelFlaLoaderLoadFromDisk();
				newRequest.loadModelFlaAsset(ModelFlaEnum.ALL[i], new Callback(checkIfAllDone, this, [callback]));
			}
		}

		private function checkIfAllDone(c:Callback) : void {
			var result:ModelFla = ModelFlaEnum.getFirstNotInit();
			if(!result.isNull) return ;
			if(c) c.call();
		}
	}
}
