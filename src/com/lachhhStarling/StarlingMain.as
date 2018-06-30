package com.lachhhStarling {
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.RenderTexture;
	import starling.utils.AssetManager;
	import starling.utils.SystemUtil;

	import com.lachhh.ResolutionManager;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.VersionInfo;

	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;

	/**
	 * @author LachhhSSD
	 */
	public class StarlingMain {
		static public var starling : Starling;
		static public var starlingAssets : AssetManager;
		static private var callbackOnEndLoad : Callback;
		static public var isReady:Boolean = false;
		
		public function StarlingMain() {
			
		}
		
		static public function initStarling(stage:Stage):void {
			ResolutionManager.refresh(stage);
			
			var screenSize:Rectangle = new Rectangle(0, 0, ResolutionManager.windowSize.width, ResolutionManager.windowSize.height);
			//var profile:String = VersionInfo.isHDTexture ? Context3DProfile.BASELINE_EXTENDED : "auto";
			var profile:String = VersionInfo.isHDTexture ? "baselineExtended" : "auto";
			starling = new Starling(StarlingStage, stage, screenSize, null, "auto", profile);
			
			starling.stage.stageWidth    = ResolutionManager.gameSize.width;  // <- same size on all devices!
            starling.stage.stageHeight   = ResolutionManager.gameSize.height; // <- same size on all devices!
		}
		
		static public function refreshResolution():void {
			if(!isReady) return;
			StarlingMain.starling.viewPort.width = ResolutionManager.windowSize.width ;
			StarlingMain.starling.viewPort.height = ResolutionManager.windowSize.height;
			
			StarlingMain.starling.stage.stageWidth = ResolutionManager.gameSize.width;
			StarlingMain.starling.stage.stageHeight = ResolutionManager.gameSize.height; 
		}
		
		static public function initMobile(stage:Stage, c:Callback, assets:AssetManager):void{
			
			callbackOnEndLoad = c;
			starlingAssets = assets;
			
			var iOS:Boolean = SystemUtil.platform == "IOS";
            
			Starling.multitouchEnabled = true; // for Multitouch Scene
            Starling.handleLostContext = true; // recommended everywhere when using AssetManager
            RenderTexture.optimizePersistentBuffers = iOS; // should be safe on Desktop
			
			initStarling(stage);
						
           	starling.simulateMultitouch = true;
            starling.enableErrorChecking = Capabilities.isDebugger;
						
            starling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
            {
                loadAssetsDesktop(startGame);
            });
			
			starling.start();
		}
		
		static private function onInitError(c:Callback):void {
			if(c) c.call();
		}

		static public function initDesktop(stage:Stage, c:Callback, assets:AssetManager, cCallbackError:Callback):void {
							
			try {
				callbackOnEndLoad = c;
				starlingAssets = assets;
				
				Starling.multitouchEnabled = VersionInfo.isDebug; // for Multitouch Scene
	            Starling.handleLostContext = true; // recommended everywhere when using AssetManager
	            
	            RenderTexture.optimizePersistentBuffers = true; // should be safe on Desktop
				
				initStarling(stage);
				
	           	starling.simulateMultitouch = VersionInfo.isDebug;
	            starling.enableErrorChecking = Capabilities.isDebugger;
				
				starling.addEventListener(starling.events.Event.FATAL_ERROR, function():void
	            {
	                onInitError(cCallbackError);
	            });
				
	            starling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
	            {
	                loadAssetsDesktop(startGame);
					starling.removeEventListeners(starling.events.Event.FATAL_ERROR);
	            });
				
				starling.start();
			} catch (e:Error) {
				if(cCallbackError) cCallbackError.call();
			}
		}
		
		static private function loadAssetsDesktop(onComplete:Function):void
        {	
            starlingAssets.loadQueue(function(ratio:Number):void
            {
               // mProgressBar.ratio = ratio;
                if (ratio == 1) onComplete(starlingAssets);
				
            });
        }
				
		static private function startGame(assets:AssetManager):void
        {
            starlingAssets = assets;
			
			isReady = true;
			if(callbackOnEndLoad) callbackOnEndLoad.call();
			
        }
	}
}
