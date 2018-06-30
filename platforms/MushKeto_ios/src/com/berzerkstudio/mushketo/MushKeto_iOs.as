package com.berzerkstudio.mushketo {
	import com.berzerkrpg.meta.ModelPlatformEnum;
	import com.flashinit.ReleaseInitMobile;
	import com.lachhh.io.Callback;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.io.trackAPI.GoogleAnalyticController;
	import com.lachhh.lachhhengine.VersionInfo;

	/**
	 * @author LachhhSSD
	 */
	public class MushKeto_iOs extends ReleaseInitMobile {
		public function MushKeto_iOs() {
			VersionInfo.modelPlatform = ModelPlatformEnum.MOBILE_IOS;
						
			ExternalAPIManager.platformPioAccount = ExternalAPIManager.pioAccount;
			ExternalAPIManager.platformPremiumAPI = ExternalAPIManager.premiumAPI;
			VersionInfo.platformExternalAPI = VersionInfo.modelExternalAPI;
			
			super();
		}

		override protected function startGame() : void {
			super.startGame();
		
		}

	}
}
