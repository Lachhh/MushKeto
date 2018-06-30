package com.berzerkrpg {
	import starling.utils.AssetManager;

	import com.animation.exported.BTN_GETFLASH;
	import com.animation.exported.UI_WMODE;
	import com.berzerkrpg.constants.GameConstants;
	import com.berzerkrpg.effect.CallbackWaitEffect;
	import com.berzerkrpg.ui.UI_LoadingVecto;
	import com.flashinit.MobileSplashScreen;
	import com.lachhh.ResolutionManager;
	import com.lachhh.flash.RightClickMenuWeb;
	import com.lachhh.io.Callback;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.ui.UIBase;
	import com.lachhh.utils.Utils;
	import com.lachhhStarling.BerzerkAnimationManager;
	import com.lachhhStarling.BerzerkTextureLoaderHelper;
	import com.lachhhStarling.ModelFlaEnum;
	import com.lachhhStarling.StarlingMain;
	import com.lachhhStarling.StarlingStage;
	import com.lachhhStarling.berzerk.BerzerkEmbeddedBitmapFonts;
	import com.lachhhStarling.berzerk.BerzerkStarlingManager;
	import com.lachhhStarling.berzerk.BerzerkZipLanguageLoader;
	import com.lachhhStarling.berzerk.BerzerkZipModelFlaLoader;
	import com.lachhhStarling.berzerk.BerzerkZipTextureLoader;
	import com.lachhhStarling.berzerk.ZipAssetManager;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	/**
	 * @author LachhhSSD
	 */
	public class MainGameWebStarling extends Sprite{
		private var modelFlaLoader : BerzerkZipModelFlaLoader;
		private var textureLoader : BerzerkZipTextureLoader;
		private var languageLoader : BerzerkZipLanguageLoader;
		
		[Embed(source="../../../bin/starling.zip", mimeType="application/octet-stream") ]
		static private const embedZIP:Class;
		
		public function MainGameWebStarling() {
			
		}
		
		public function init():void {
			VersionInfo.starlingReady = true;
			var assets:AssetManager = new AssetManager();
			var startLoadingCallback:Callback;
			
			var zipAssetManager:ZipAssetManager = new ZipAssetManager(assets);
			modelFlaLoader = zipAssetManager.modelFlaLoader;
			textureLoader = zipAssetManager.textureLoader;
			languageLoader = zipAssetManager.languageLoader;
			startLoadingCallback = new Callback(loadZipFile, this, [zipAssetManager]);
			
			MobileSplashScreen.show(stage);
			UI_LoadingVecto.show(stage, "Unzipping stuff...");
						
			StarlingMain.initDesktop(stage, startLoadingCallback, assets, new Callback(onStarlingError, this, null));
		}
		
		private function onStarlingError():void {
			MobileSplashScreen.hide();
			UI_LoadingVecto.hide();
			var ui:UI_WMODE = new UI_WMODE();
			var btn : DisplayObject = ui.getChildByName("downloadMc") as DisplayObject;
			btn.addEventListener(MouseEvent.CLICK, onClickGetFlash);
			var b:BTN_GETFLASH;
			stage.addChild(ui);
		}

		private function onClickGetFlash(event : MouseEvent) : void {
			Utils.navigateToURLAndRecord("https://get.adobe.com/flashplayer/");
		}
		
		protected function loadZipFile(pZipManager:ZipAssetManager):void {
			var bytes:ByteArray = new embedZIP() as ByteArray;
			

			pZipManager.loadZipWithBytes(bytes);
			loadModelFlas();
		}
		
		protected function loadModelFlas():void {
			UI_LoadingVecto.show(stage, "Loading ModelFla...");
			modelFlaLoader.loadAllFlas(new Callback(preloadFirst, this, null));
			
		}
		
		protected function preloadFirst():void {
			UI_LoadingVecto.show(stage, "Preloading stuff...");
			ExternalAPIManager.berzerkAnimationManager = new BerzerkAnimationManager(StarlingStage.instance);
			BerzerkStarlingManager.berzerkFlaLoader = textureLoader;
			BerzerkStarlingManager.berzerkModelFlaAssetLoader = modelFlaLoader;
			BerzerkEmbeddedBitmapFonts.loadFonts();
			
			BerzerkTextureLoaderHelper.loadBunch(ModelFlaEnum.ALL_PERSISTENT, new Callback(startGame, this, null));
			
		}
		
		protected function startGame():void {

			ResolutionManager.refresh(stage);
			var m:MainGame = new MainGame();
			
			stage.addChild(m);
			m.init();
			languageLoader.loadAllLanguages(null);
			
			
			if(VersionInfo.isDebug) {
				m.startFromNormal(); 
			} else {
				m.startFromNormal();
			}
			
			
			if(parent) parent.removeChild(this);
			CallbackWaitEffect.addWaitCallFctToActor(MainGame.dummyActor, hideMobileShowUI, 1);
			
			RightClickMenuWeb.addRightClickMenu(m);
			RightClickMenuWeb.addAllContextMenuItem();
			
			m.refreshBasedOnStageDimension();
		}
		
		private function hideMobileShowUI():void {
			MobileSplashScreen.hide();
			UI_LoadingVecto.hide();
			UIBase.manager.refresh();
		}
		
	}
}
