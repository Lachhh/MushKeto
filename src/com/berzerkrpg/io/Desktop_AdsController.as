package com.berzerkrpg.io {
	import com.berzerkrpg.meta.MetaExternalAdRequest;

	/**
	 * @author Lachhh
	 */
	public class Desktop_AdsController implements IAdsAPI {
		private var request : MetaExternalAdRequest;

		public function Desktop_AdsController() {
	
		}
		
		
		public function loadAds(result : MetaExternalAdRequest) : MetaExternalAdRequest {
			request = result;
			request.triggerLoaded();
			
			return result;
		}

		public function playAds() : void {
			
		}

		
		public function isConnected() : Boolean {
			return true;
		}

		public function isReadyToPlayAd() : Boolean {
			return true;
		}
		
		// ------------------- end IAds API
		

		
		public function canShowScrolls() : Boolean {
			return true;
		}
	}
}
