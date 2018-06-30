package com.berzerkrpg {
	import com.berzerkrpg.debug.DebugGameProgress;
	import com.berzerkrpg.debug.DebugShortcut;
	import com.berzerkrpg.debug.DebugShowHitArea;
	import com.berzerkrpg.io.BerzerkUserAPI;
	import com.berzerkrpg.io.PlayerIOZombIdleController;
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.scenes.GameSceneManager;
	import com.berzerkrpg.ui.UI_DebugStarlingStats;
	import com.berzerkstudio.ModelFla;
	import com.berzerkstudio.flash.display.Stage;
	import com.flashinit.MobileSplashScreen;
	import com.lachhh.ResolutionManager;
	import com.lachhh.flash.debug.UIFPSCounter;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.sfx.Jukebox;
	import com.lachhh.lachhhengine.ui.UIBase;
	import com.lachhhStarling.ModelFlaEnum;
	import com.lachhhStarling.StarlingAnimationView;
	import com.lachhhStarling.StarlingMain;

	import flash.display.StageQuality;
	import flash.events.Event;

	public class MainGame extends DefaultMainGame {
		static public var instance:MainGame;
		static public var notEnoughCash:int;
		public var gameSceneManager : GameSceneManager = new GameSceneManager();
		
		static public var dummyActor : Actor = new Actor();
		static public var fpsCounter : UIFPSCounter ;
		
		public var debugShortcut : DebugShortcut;
		public var debugSHowhitArea : DebugShowHitArea;

		public function MainGame() {
	
		}
		
		override public function init():void {
			super.init();
			instance = this;
			ResolutionManager.refresh(stage);

			UIBase.manager.add(dummyActor);

			if(VersionInfo.showFPS()) {
				fpsCounter = new UIFPSCounter();
				fpsCounter.show(true);
			}

			if(VersionInfo.DEBUG_NoSounds) {
				Jukebox.MUSIC_VOLUME = 0;
				Jukebox.SFX_VOLUME = 0;
			}

			stage.focus = null;
			TextFactory.init();
			
			stage.quality = StageQuality.LOW;
			stage.frameRate = 60;
			
			BerzerkUserAPI.initInstance();
			
			ExternalAPIManager.trackerAPI.trackView("/berzerkrpg");
			ExternalAPIManager.trackerAPI.trackEvent("Misc.", "NumSession");
			PlayerIOZombIdleController.InitInstance(this, VersionInfo.modelExternalAPI, VersionInfo.isDebugPIO);
			
			
			refreshSmoothing();
			
			if(VersionInfo.showStarlingDrawStats()) {
				new UI_DebugStarlingStats();
			}
			
			if (!VersionInfo.modelPlatform.isMobile() || VersionInfo.modelPlatform.isAmazon()) {
				stage.addEventListener(Event.RESIZE, onResize);
			}
			
			if(VersionInfo.hasDebugShortcut) {
				debugShortcut = DebugShortcut.addToActor(dummyActor);
				debugSHowhitArea = new DebugShowHitArea();
				dummyActor.addComponent(debugSHowhitArea);
			}
		}
		
		private function refreshSmoothing():void {
			if(VersionInfo.smoothEverything || VersionInfo.isHDTexture) {
				ModelFlaEnum.smooothEverything();
			} 
		}
		
		public function refreshBasedOnStageDimension():void {
			ResolutionManager.refresh(stage);
			StarlingMain.refreshResolution();
			UIBase.manager.refresh();
		
			if(gameSceneManager.hasAScene)  {
				gameSceneManager.gameScene.camera.refreshFOV();
				gameSceneManager.gameScene.refreshAll();
			}
		}

		public function onResize(event : Event) : void {
			refreshBasedOnStageDimension();
		}
		
		public function startFromNormal() : void {
			new UI_MainMenu();	
		}

		public function startFromIngame():void {
			
		}
		
		public function startQuickDebug():void {
			VersionInfo.DEBUG_NOSave = true;
			MobileSplashScreen.hide();
			
			MetaGameProgress.instance.loadFromLocal();
			MetaGameProgress.instance.clear();
			DebugGameProgress.setGame1(MetaGameProgress.instance);
			
			onResize(null);
		}
		
		override public function update():void {
			super.update();
			
			gameSceneManager.update();
			KeyManager.update();
			
			ExternalAPIManager.berzerkAnimationManager.update();
		}

		public function startRelease() : void {
			startFromNormal();
		}
	}
}
