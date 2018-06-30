package com.lachhhStarling {
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.effect.CallbackTimerEffect;
	import com.berzerkstudio.ModelFla;
	import com.lachhh.io.Callback;
	import com.lachhh.io.CallbackGroup;
	import com.lachhhStarling.berzerk.BerzerkStarlingManager;
	import com.lachhhStarling.berzerk.MetaFla;
	/**
	 * @author LachhhSSD
	 */
	public class BerzerkTextureLoaderHelper {
		public var listModelFla:Vector.<ModelFla>;
		public var isProcessStarted : Boolean = false;
		public var isProcessFinished : Boolean = false;
		
		private var index:int = -1;
		
		private var callbacks : CallbackGroup = new CallbackGroup();

		public function BerzerkTextureLoaderHelper(pListModelFla : Vector.<ModelFla>) {
			listModelFla = pListModelFla;
			
		}
		
		public function startUnloading():void {
			if(isProcessStarted) return ;
			isProcessStarted = true;
			unloadNext();
		}
		
		private function unloadNext():void {
			index++ ;
			if (index >= listModelFla.length) {
				endProcess();
				return;
			}
			
			var model:ModelFla = listModelFla[index];
			if(!BerzerkStarlingManager.berzerkFlaLoader.isAtlasLoaded(model)) {
				unloadNext();
				return ;
			}
			
			
			var m:MetaFla = BerzerkStarlingManager.berzerkFlaLoader.unloadFla(model);
			unloadNext();
		}
		
		public function startLoading():void {
			if(isProcessStarted) return ;
			isProcessStarted = true;
			if(flasAllLoaded(listModelFla)) {
				CallbackTimerEffect.addWaitCallFctToActor(MainGame.dummyActor, endProcess, 25);
				return ;
			}
			loadNext();
		}
		
		private function loadNext():void {
			index++;
			if (index >= listModelFla.length) {
				endProcess();
				return;
			}
			
			var model:ModelFla = listModelFla[index];
			if(model.isNull){
				loadNext();
				return;
			}
			var isTextureLoaded:Boolean = BerzerkStarlingManager.berzerkFlaLoader.isAtlasLoaded(model);
			var isModelAssetLoaded:Boolean = BerzerkStarlingManager.berzerkModelFlaAssetLoader.isModelFlaAssetLoaded(model); 
			if(isTextureLoaded && isModelAssetLoaded) {
				loadNext();
				return ;
			}
			
			if(!isModelAssetLoaded) {
				index--;
				BerzerkStarlingManager.berzerkModelFlaAssetLoader.loadModelFlaAsset(model, new Callback(loadNext, this, null));
				return ;
			}
			
			if(!isTextureLoaded) {
				var m:MetaFla = BerzerkStarlingManager.berzerkFlaLoader.loadFla(model);
				m.callbacksOnLoaded.addCallback(new Callback(loadNext, this, null));
				return ;
			}
		}

		private function endProcess() : void {
			if(isProcessFinished) return ;
			isProcessFinished = true;
			callbacks.call();
		}
		
		static public function flasAllLoaded(listModelFla : Vector.<ModelFla>) : Boolean {
			for (var i : int = 0; i < listModelFla.length; i++) {
				var modelFla:ModelFla = listModelFla[i];
				if(!BerzerkStarlingManager.berzerkFlaLoader.isAtlasLoaded(modelFla)) return false;
				if(!BerzerkStarlingManager.berzerkModelFlaAssetLoader.isModelFlaAssetLoaded(modelFla)) return false; 
			}
			return true;
		}
		

		static public function loadBunch(listModelFla : Vector.<ModelFla>, c:Callback) : BerzerkTextureLoaderHelper {
			if(listModelFla.length <= 0) throw new Error("List cannot be empty");
			var result:BerzerkTextureLoaderHelper = new BerzerkTextureLoaderHelper(listModelFla);
			if(c) result.callbacks.addCallback(c);
			result.startLoading();
			return result;
		}
		
		static public function unloadBunch(listModelFla : Vector.<ModelFla>) : BerzerkTextureLoaderHelper {
			 var result:BerzerkTextureLoaderHelper = new BerzerkTextureLoaderHelper(listModelFla);
			 result.startUnloading();
			 return result;
		}
	}
}
