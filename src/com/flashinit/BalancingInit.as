package com.flashinit {
	import com.berzerkrpg.io.BerzerkUserAPI;
	import com.berzerkrpg.io.Desktop_AdsController;
	import com.berzerkrpg.io.PlayerIOPaypalPremiumAPI;
	import com.berzerkrpg.io.playerio.ModelExternalPremiumAPIEnum;
	import com.berzerkrpg.meta.ModelPlatformEnum;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.lachhhengine.DataManagerAIR;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.sfx.Jukebox;
	/**
	 * @author LachhhSSD
	 */
	public class BalancingInit extends ReleaseInitDesktop {
		public function BalancingInit() {
			super();
			VersionInfo.isDebugPIO = false;
			VersionInfo.hasDebugShortcut = true;
			VersionInfo.isDebug = true;
			
			VersionInfo.isAdminConnectionOnPIO = true;
			VersionInfo.DEBUG_NoSounds = true;
					
			VersionInfo.DEBUG_NOSave = true;
			
			var berzerkPio:BerzerkUserAPI = new BerzerkUserAPI();
			berzerkPio.Connect(this);
			
			var paypalPremiumAPI:PlayerIOPaypalPremiumAPI = new PlayerIOPaypalPremiumAPI(berzerkPio);
			paypalPremiumAPI.Connect(this);
			
			ExternalAPIManager.premiumAPI = paypalPremiumAPI;
			ExternalAPIManager.pioAccount = berzerkPio;
			
			
			ExternalAPIManager.adsAPI = new Desktop_AdsController();
			VersionInfo.modelExternalAPI = ModelExternalPremiumAPIEnum.BERZERK;
			VersionInfo.modelPlatform = ModelPlatformEnum.DESKTOP_ITCH_IO;
			
			ExternalAPIManager.platformPremiumAPI = paypalPremiumAPI;
			ExternalAPIManager.platformPioAccount = berzerkPio;
			VersionInfo.platformExternalAPI = VersionInfo.modelExternalAPI;
			
			VersionInfo.showDebugScreens = false; 
			VersionInfo.hasNoAds = true;
			
			Jukebox.MUSIC_VOLUME = 0.5;
			Jukebox.SFX_VOLUME = 0.5;
		}

		override public function afterStartLingLoaded() : void {
			super.afterStartLingLoaded();
			DataManagerAIR.loadDefaultBalancing();
		}
	}
}
