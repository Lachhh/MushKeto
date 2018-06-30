package com.lachhh.lachhhengine {
	import com.berzerkrpg.io.playerio.ModelExternalPremiumAPI;
	import com.berzerkrpg.io.playerio.ModelExternalPremiumAPIEnum;
	import com.berzerkrpg.meta.ModelPlatform;
	import com.berzerkrpg.meta.ModelPlatformEnum;
	import com.lachhh.io.Callback;
	import com.lachhh.io.ExternalAPIManager;
	/**
	 * @author LachhhSSD
	 */
	public class VersionInfo {
		static public var relativeFolderForStarling:String = "./";
		static public var isHDTexture:Boolean = false;
		static public var starlingReady:Boolean = false;
		static public var isDebug:Boolean = false;
		static public var isAdminConnectionOnPIO:Boolean = false;
		static public var isThrowErrorOnValidateStarling:Boolean = true;
		
		public static var DEBUG_NoSounds : Boolean = false;
		public static var DEBUG_NOSave : Boolean = false;
		
		static public var showDebugScreens:Boolean = true;
		
		static public var hasDebugShortcut:Boolean = false;
		
		static public var isDebugPIO:Boolean = false;	
		
		static public var modelExternalAPI:ModelExternalPremiumAPI = ModelExternalPremiumAPIEnum.GAMERSAFE;
		static public var platformExternalAPI:ModelExternalPremiumAPI = modelExternalAPI;
		
		static public var modelPlatform:ModelPlatform = ModelPlatformEnum.NULL;
		
		static public var versionInfo:String = "v1.03.050";
		
		
		static public var urlUpdateNow : String = ExternalLinks.ZOMBIDLE_URL;

		static public var timeForAdTimeoutInDevilDeal:int = 5000;
		
		static public var DEBUG_NOTEXTFIELD_STARLING : Boolean = false;
		
		static public var loadFromZipFile : Boolean = false;
		
		static public var showErrorMsgWatchEntireVideoOnCancel: Boolean = false;
		
		static public var showExportingLanguage : Boolean = false;
		
		static public var callbackOnEnterStore : Callback = null;
		static public var callbackOnEnterGame : Callback = null;
		public static var smoothEverything : Boolean = false;
		public static var hasNoAds : Boolean = false;
		public static var URL_BERZERKTV : String = "http://berzerk.tv";
		

		static public function getVersionStr() : String {
			return "Version " + versionInfo; 
		}

		
		static public function showStarlingDrawStats():Boolean {
			if(!showDebugScreens) return false;
			return isDebug && starlingReady ;
		}
		
		static public function showFPS():Boolean {
			if(!showDebugScreens) return false;
			return isDebug ;
		}
		
		static public function haveAccessToShortcutDebug():Boolean {
			return isDebug && hasDebugShortcut;
		}		
		
	}
}
