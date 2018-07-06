package com.flashinit {
	import starling.utils.AssetManager;

	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.meta.ModelPlatformEnum;
	import com.berzerkstudio.ModelFla;
	import com.berzerkstudio.ModelFlaLoaderLoadFromDisk;
	import com.lachhh.flash.RightClickMenu;
	import com.lachhh.io.Callback;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.sfx.Jukebox;
	import com.lachhhStarling.BerzerkAnimationManager;
	import com.lachhhStarling.BerzerkTextureLoaderHelper;
	import com.lachhhStarling.ModelFlaEnum;
	import com.lachhhStarling.StarlingMain;
	import com.lachhhStarling.StarlingStage;
	import com.lachhhStarling.berzerk.BerzerkEmbeddedBitmapFonts;
	import com.lachhhStarling.berzerk.BerzerkStarlingManager;
	import com.lachhhStarling.berzerk.BerzerkTextureLoaderDesktop;
	import com.lachhhStarling.berzerk.IBerzerkModelFlaLoader;
	import com.lachhhStarling.berzerk.IBerzerkTextureLoader;
	import com.lachhhStarling.berzerk.ZipAssetManager;

	import flash.display.Sprite;
	/**
	 * @author LachhhSSD
	 */
	public class DebugStarlingInit extends Sprite {
		
		private var modelFlaLoader:IBerzerkModelFlaLoader;
		public var textureLoader:IBerzerkTextureLoader;
		
		private var _lastSoundVolume:Number;
		private var _lastMusicVolume:Number;
		
		public function DebugStarlingInit() {
			VersionInfo.starlingReady = true;
			
			VersionInfo.modelPlatform = ModelPlatformEnum.DESKTOP_ITCH_IO;
			

			VersionInfo.isDebug = true;
			VersionInfo.hasDebugShortcut = true;
			VersionInfo.isDebugPIO = false;
			
			
			Jukebox.MUSIC_VOLUME = 0;
			Jukebox.SFX_VOLUME = 0;
			
			if(!VersionInfo.modelPlatform.isMobile()){
				stage.nativeWindow.x = 138;
				stage.nativeWindow.y = 37;
			}
			
			VersionInfo.DEBUG_NoSounds = true;
			
			var scaleFactor:int = (VersionInfo.isHDTexture ? 2 : 1);
			var assets:AssetManager = new AssetManager(scaleFactor);
			var startLoadingCallback:Callback;
			if(VersionInfo.loadFromZipFile){
				var zipAssetManager:ZipAssetManager = new ZipAssetManager(assets);
				modelFlaLoader = zipAssetManager.modelFlaLoader;
				textureLoader = zipAssetManager.textureLoader;
				startLoadingCallback = new Callback(loadZipFile, this, [zipAssetManager]);
			}
			else{
				modelFlaLoader = new ModelFlaLoaderLoadFromDisk();
				textureLoader = new BerzerkTextureLoaderDesktop(assets);
				startLoadingCallback = new Callback(loadModelFlas, this, null);
			}
			BerzerkStarlingManager.berzerkFlaLoader = textureLoader;
			BerzerkStarlingManager.berzerkModelFlaAssetLoader = modelFlaLoader;
			
			
			if(VersionInfo.modelPlatform.isMobile()){
				StarlingMain.initMobile(stage, startLoadingCallback, assets);
			} else {
				StarlingMain.initDesktop(stage, startLoadingCallback, assets, null);
			}
			
			MobileSplashScreen.show(stage);
			RightClickMenu.addRightClickMenu(this);
			
			/*if(VersionInfo.runNumberBigTest) {
				TestNumberBig.runTest();
			}*/
		}
				
		protected function loadZipFile(pZipManager:ZipAssetManager):void{
			pZipManager.loadZipFile(new Callback(loadModelFlas, this, null));
		}
		
		protected function loadModelFlas():void {
			var array:Vector.<ModelFla> = ModelFlaEnum.ALL_PERSISTENT;
			
			modelFlaLoader.loadBunch(array, new Callback(preloadFlas, this, null));
		}
		
		protected function preloadFlas():void{
			
			BerzerkTextureLoaderHelper.loadBunch(ModelFlaEnum.ALL_PERSISTENT, 
													new Callback(startGame, this, null));
		}
		
		protected function startGame():void {
			ExternalAPIManager.berzerkAnimationManager = new BerzerkAnimationManager(StarlingStage.instance);
			//textureLoader.loadFla(ModelFlaEnum.MK_UI_BERZERK);
			
			BerzerkEmbeddedBitmapFonts.loadFonts();
			
			var m:MainGame = new MainGame();
			stage.addChild(m);
			m.init();
			//TextFactory.importLangFromCSV();
			//GameConstants.getInstance().loadEmbededData();
			//DataManagerAIR.loadDefaultBalancing();
			
			m.startQuickDebug();
			//m.startFromNormal();
			
			MobileSplashScreen.hide();
		}
	}
}
