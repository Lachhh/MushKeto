package com.flashinit {
	import com.berzerkstudio.ModelFlaLoaderCreateAsset;
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.io.DummyPremiumAPI;
	import com.berzerkrpg.io.Dummy_AdsAPI;
	import com.berzerkrpg.logic.LogicBackOnAndroid;
	import com.berzerkrpg.multilingual.CrowdinAPI;
	import com.berzerkrpg.multilingual.ModelLanguageEnum;
	import com.berzerkrpg.multilingual.ModelLanguageExporter;
	import com.berzerkrpg.multilingual.ModelLanguageImporter;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkstudio.ModelFlaLoaderCreateAssetDirtyOnly;
	import com.lachhh.io.Callback;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.ui.UIBase;

	/**
	 * @author LachhhSSD
	 */
	public class DebugStarlingInitClean extends DebugStarlingInit {
		public function DebugStarlingInitClean() {
			
			super();
			ExternalAPIManager.adsAPI = new Dummy_AdsAPI();
			ExternalAPIManager.premiumAPI = new DummyPremiumAPI();
			VersionInfo.smoothEverything = false;
			
		}
		
		override protected function loadModelFlas():void {
			//ModelFlaLoaderCreateAssetDirtyOnly.loadAllFlas(new Callback(preloadFlas, this, null));
			ModelFlaLoaderCreateAsset.loadAllFlas(new Callback(preloadFlas, this, null));
		}
		
		private function loadCrowdinTranslations():void{
			TextFactory.importLangFromCSV();
			CrowdinAPI.downloadSupportedLanguages(new Callback(exportLanguages, this, null));
		}

		override protected function startGame() : void {
			super.startGame();
			
			//loadCrowdinTranslations();
			
			//var encoded:String = ModelLanguageEnum.ENGLISH.ExportInCSV();
			//CrowdinAPI.uploadEnglishCSVData(encoded, null);
			
			var l:LogicBackOnAndroid = MainGame.dummyActor.addComponent(new LogicBackOnAndroid()) as LogicBackOnAndroid;
			l.isAskWhenClose = true;  
			
			
		}
		
		private function exportLanguages():void{
			ModelLanguageExporter.exportAlLanguageToByteArray(new Callback(onEndExport, this, null));
		}

		private function onEndExport() : void {
			ModelLanguageImporter.loadAllLanguages(new Callback(onLoadComplete, this, null));
		}
		
		private function onLoadComplete():void {
			UIBase.manager.refresh();
		}
	}
}
