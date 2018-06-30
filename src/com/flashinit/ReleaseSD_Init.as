package com.flashinit {
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.io.BerzerkUserAPI;
	import com.berzerkrpg.io.Desktop_AdsAPI;
	import com.berzerkrpg.io.PlayerIOPaypalPremiumAPI;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.sfx.Jukebox;
	/**
	 * @author LachhhSSD
	 */
	public class ReleaseSD_Init extends ReleaseInitDesktop {
		public function ReleaseSD_Init() {
			super();
			//VersionInfo.isDebug = true;
			//VersionInfo.hasDebugShortcut = true;
			//VersionInfo.isKizi = true;
			//VersionInfo.DEBUG_AUTO_Click = true;
						

			var berzerkPio:BerzerkUserAPI = new BerzerkUserAPI();
			berzerkPio.Connect(this);
			
			var paypalPremiumAPI:PlayerIOPaypalPremiumAPI = new PlayerIOPaypalPremiumAPI(berzerkPio);
			paypalPremiumAPI.Connect(this);
			
			ExternalAPIManager.premiumAPI = paypalPremiumAPI;
			
			ExternalAPIManager.pioAccount = berzerkPio;
			
			
			VersionInfo.hasNoAds = true;
			ExternalAPIManager.adsAPI = new Desktop_AdsAPI();
			
			VersionInfo.showDebugScreens = false; 
			
			Jukebox.MUSIC_VOLUME = 0.5;
			Jukebox.SFX_VOLUME = 0.5;
		}

	
	}
}
