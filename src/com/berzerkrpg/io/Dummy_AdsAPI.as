package com.berzerkrpg.io {
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.effect.CallbackTimerEffect;
	import com.berzerkrpg.meta.MetaExternalAdRequest;
	import com.lachhh.io.Callback;
	import com.lachhh.io.KeyManager;

	import flash.ui.Keyboard;

	/**
	 * @author LachhhSSD
	 */
	public class Dummy_AdsAPI implements IAdsAPI {
		public var metaExternalRequest : MetaExternalAdRequest;
		private var num:int = 0;
		private var numLoadAttempt:int = 0;

		public function Dummy_AdsAPI() {
		}

		public function playAds() : void {
			/*if(num == 0) {
				CallbackTimerEffect.addWaitCallbackToActor(MainGame.dummyActor, new Callback(onCanceledByUser, this, null), 1000*3);
			} else if(num == 1) {
				CallbackTimerEffect.addWaitCallbackToActor(MainGame.dummyActor, new Callback(onError, this, null), 1000*3);
			} else {
				CallbackTimerEffect.addWaitCallbackToActor(MainGame.dummyActor, new Callback(onSuccess, this, null), 1000*3);
			}*/
			if(num < 3) {
				CallbackTimerEffect.addWaitCallbackToActor(MainGame.dummyActor, new Callback(onError, this, null), 250);
			} else {
				CallbackTimerEffect.addWaitCallbackToActor(MainGame.dummyActor, new Callback(onSuccess, this, null), 250*3);
			}
			//CallbackTimerEffect.addWaitCallbackToActor(MainGame.dummyActor, new Callback(onSuccess, this, null), 1000*4);
			
			//Utils.navigateToURLAndRecord(VersionInfo.INFERNAX_ADS);
			num++;
		}
		
		public function loadAds(result : MetaExternalAdRequest) : MetaExternalAdRequest {
			metaExternalRequest = result;
			if(numLoadAttempt < 0) {
				CallbackTimerEffect.addWaitCallbackToActor(MainGame.dummyActor, new Callback(onError, this, null), 250);	
			} else {
				CallbackTimerEffect.addWaitCallbackToActor(MainGame.dummyActor, new Callback(onLoaded, this, null), 250);
			}
			numLoadAttempt++;
			return metaExternalRequest;
		}
		
		public function isConnected() : Boolean {
			return true;
		}
		
		private function onError():void { 
			metaExternalRequest.triggerError("Error!\nStuff");
		}
		
		private function onCanceledByUser():void { 
			metaExternalRequest.triggerCanceledByUser();
			//onError();
		}
			
		private function onSuccess():void {
			metaExternalRequest.triggerSuccess();
		}
		
		private function onLoaded():void {
			metaExternalRequest.triggerLoaded();
		}

		

		public function isReadyToPlayAd() : Boolean {
			if(!metaExternalRequest) return false;
			if(!metaExternalRequest.isAdLoaded) return false;
			if(KeyManager.IsKeyDown(Keyboard.CONTROL)) return false;
			return true;
		}

		public function canShowScrolls() : Boolean {
			return true;
		}
	}
}
