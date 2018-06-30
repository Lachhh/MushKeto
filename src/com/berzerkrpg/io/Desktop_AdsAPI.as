package com.berzerkrpg.io {
	import com.berzerkrpg.meta.MetaExternalAdRequest;
	/**
	 * @author LachhhSSD
	 */
	public class Desktop_AdsAPI implements IAdsAPI {
		public function Desktop_AdsAPI() {
		}

		public function playAds() : void {
	
		}
		
		public function loadAds(result : MetaExternalAdRequest) : MetaExternalAdRequest {
			result.triggerLoaded();
			return result;
		}
		
		public function isConnected() : Boolean {
			return true;
		}
		
		public function isReadyToPlayAd() : Boolean {
			return true;
		}

		public function canShowScrolls() : Boolean {
			return true;
		}
	}
}
