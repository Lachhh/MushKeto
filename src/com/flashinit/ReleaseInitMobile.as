package com.flashinit {
	import starling.utils.AssetManager;

	import com.berzerkrpg.LogicNotificationMobile;
	import com.berzerkrpg.LogicOnPauseApp;
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.constants.GameConstants;
	import com.berzerkrpg.logic.LogicBackOnAndroid;
	import com.berzerkrpg.multilingual.ModelLanguageImporter;
	import com.berzerkstudio.ModelFlaLoaderLoadFromDisk;
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

	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * @author LachhhSSD
	 */
	public class ReleaseInitMobile extends Sprite {
		public var logicOnPause : LogicOnPauseApp;
		public var logicNotifications : LogicNotificationMobile;

		public function ReleaseInitMobile() {
			VersionInfo.starlingReady = true;
			
			Jukebox.MUSIC_VOLUME = 0.5;
			Jukebox.SFX_VOLUME = 0.5;

			MobileSplashScreen.show(stage);
					
			var assets:AssetManager = new AssetManager();
			StarlingMain.initMobile(stage, new Callback(loadModelFlas, this, null), assets);
		}

		protected function loadModelFlas():void {
			var flaLoader:ModelFlaLoaderLoadFromDisk = new ModelFlaLoaderLoadFromDisk();
			BerzerkStarlingManager.berzerkModelFlaAssetLoader = flaLoader;
			flaLoader.loadBunch(ModelFlaEnum.ALL_PERSISTENT, new Callback(afterStartLingLoaded, this, null));
			
		}
		
		private function afterStartLingLoaded():void {
			var flaLoader:BerzerkTextureLoaderDesktop = new BerzerkTextureLoaderDesktop(StarlingMain.starlingAssets);
			var bzkAnim:BerzerkAnimationManager = new BerzerkAnimationManager(StarlingStage.instance);
			ExternalAPIManager.berzerkAnimationManager = bzkAnim;
			BerzerkStarlingManager.berzerkFlaLoader = flaLoader;
			BerzerkEmbeddedBitmapFonts.loadFonts();
			
			//GameConstants.getInstance().loadEmbededData();
			BerzerkTextureLoaderHelper.loadBunch(ModelFlaEnum.ALL_PERSISTENT, new Callback(afterFirstFlaLoaded, this, null));
		}
		
		private function afterFirstFlaLoaded():void {
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
			
			logicOnPause = new LogicOnPauseApp();
			logicOnPause.callbackOnPause.addCallback(new Callback(StarlingMain.starling.stop, this, [true]));
			logicOnPause.callbackOnUnpause.addCallback(new Callback(StarlingMain.starling.start, this, null));
			
			logicNotifications = new LogicNotificationMobile();
			
			if(VersionInfo.modelPlatform.isAndroid()) {
				MainGame.dummyActor.addComponent(new LogicBackOnAndroid()); 
			}
			
			ModelLanguageImporter.loadAllLanguages(new Callback(languagesLoaded, this, null));
		}
		
		protected function languagesLoaded():void {
			MobileSplashScreen.hide();
			MainGame.instance.startFromNormal();
		}
	}
}
