package com.flashinit {
	import starling.utils.AssetManager;

	import com.animation.exported.BTN_GETFLASH;
	import com.animation.exported.UI_STARLING_PROBLEM_DESKTOP;
	import com.animation.exported.UI_WMODE;
	import com.berzerkrpg.LogicNotificationMobile;
	import com.berzerkrpg.LogicOnPauseApp;
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.constants.GameConstants;
	import com.berzerkrpg.io.playerio.ModelExternalPremiumAPIEnum;
	import com.berzerkrpg.logic.LogicBackOnAndroid;
	import com.berzerkrpg.meta.ModelPlatformEnum;
	import com.berzerkrpg.multilingual.ModelLanguageImporter;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.ui.UI_LoadingVecto;
	import com.berzerkstudio.ModelFlaLoaderLoadFromDisk;
	import com.lachhh.ResolutionManager;
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

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.ui.Keyboard;
	/**
	 * @author LachhhSSD
	 */
	public class ReleaseInitDesktop extends Sprite {
		public var logicOnPause : LogicOnPauseApp;
		public var logicNotifications : LogicNotificationMobile;
		static private var _sharedObject:SharedObject = SharedObject.getLocal("HD_TEXTURE");
		
		public function ReleaseInitDesktop() {
			VersionInfo.starlingReady = true;
			VersionInfo.smoothEverything = true;
			VersionInfo.isHDTexture = isHDTexture();

			// VersionInfo.versionInfo = "v1.03.021";
			Jukebox.MUSIC_VOLUME = 0.5;
			Jukebox.SFX_VOLUME = 0.5;
			
			VersionInfo.modelExternalAPI = ModelExternalPremiumAPIEnum.BERZERK;
			VersionInfo.modelPlatform = ModelPlatformEnum.DESKTOP_ITCH_IO;
			
			MobileSplashScreen.show(stage);
					
			var scaleFactor:int = (VersionInfo.isHDTexture ? 2 : 1);
			var assets : AssetManager = new AssetManager(scaleFactor);
			StarlingMain.initDesktop(stage, new Callback(loadModelFlas, this, null), assets, new Callback(onStarlingError, this, null));
			stage.addEventListener(KeyboardEvent.KEY_DOWN, stopesc);
		}

		private function onStarlingError() : void {
			_sharedObject.data["isHdTexture"] = "false";
			_sharedObject.flush();
			
			MobileSplashScreen.hide();
			UI_LoadingVecto.hide();
			var ui:UI_STARLING_PROBLEM_DESKTOP = new UI_STARLING_PROBLEM_DESKTOP();
			ui.x = ResolutionManager.getGameWidth() * 0.5;
			ui.y = ResolutionManager.getGameHeight() * 0.5;
			stage.addChild(ui);
		}

		private function isHDTexture() : Boolean {
			if(_sharedObject.data["isHdTexture"] == "false") return false;
			return true;
		}
		 
		private function stopesc(e:KeyboardEvent): void
		{
			if( e.keyCode == Keyboard.ESCAPE ) {
				e.preventDefault();
			}
		}
		
		protected function loadModelFlas():void {
			 
			var flaLoader:ModelFlaLoaderLoadFromDisk = new ModelFlaLoaderLoadFromDisk();
			//flaLoader.loadAllFlas(new Callback(afterStartLingLoaded, this, null));
			BerzerkStarlingManager.berzerkModelFlaAssetLoader = flaLoader;
			flaLoader.loadBunch(ModelFlaEnum.ALL_PERSISTENT, new Callback(afterStartLingLoaded, this, null));
		}
		
		public function afterStartLingLoaded():void {
			var flaLoader:BerzerkTextureLoaderDesktop = new BerzerkTextureLoaderDesktop(StarlingMain.starlingAssets);
			var bzkAnim:BerzerkAnimationManager = new BerzerkAnimationManager(StarlingStage.instance);
			ExternalAPIManager.berzerkAnimationManager = bzkAnim;
			BerzerkStarlingManager.berzerkFlaLoader = flaLoader;
			BerzerkEmbeddedBitmapFonts.loadFonts();
			
			//GameConstants.getInstance().loadEmbededData();
			
			BerzerkTextureLoaderHelper.loadBunch(ModelFlaEnum.ALL_PERSISTENT, new Callback(afterFirstFlaLoaded, this, null));
		}
		
		protected function afterFirstFlaLoaded():void {
			MobileSplashScreen.hide();
			startGame();
			addEventListener(Event.ENTER_FRAME, wait1Frame);
		}

		private function wait1Frame(event : Event) : void {
			removeEventListener(Event.ENTER_FRAME, wait1Frame);
		}
		
		protected function startGame():void {
			var m:MainGame = new MainGame();
			stage.addChild(m);
			m.init();
			TextFactory.importLangFromCSV();
			ModelLanguageImporter.loadAllLanguages(null);
			m.startFromNormal();
			
			logicOnPause = new LogicOnPauseApp();
			logicNotifications = new LogicNotificationMobile();
			
			//if(VersionInfo.isAndroid) {
				var l:LogicBackOnAndroid = MainGame.dummyActor.addComponent(new LogicBackOnAndroid()) as LogicBackOnAndroid;
				l.isAskWhenClose = true; 
			//}
		}
	}
}
