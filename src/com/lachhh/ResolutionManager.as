package com.lachhh {
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.meta.resolution.ModelResolution;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.lachhhengine.VersionInfo;

	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author LachhhSSD
	 */
	public class ResolutionManager {
		static public var offsetPoint:Point = new Point();
		static public var scaleMin:Number = 1;
		static public var scaleMax:Number = 1;
		
		static public var windowSize:Rectangle = new Rectangle(0, 0, 960, 640);
		static public var gameSize:Rectangle = new Rectangle(0, 0, 960, 640);
		static public var originalRatioSize:Rectangle = new Rectangle(0, 0, 960, 640);
		static public var scaleRatio:Point = new Point(1,1);
		
		static public var twitchRatio:Point = new Point(1280, 720);
		
		static public function refresh(stage:Stage):void {			
			if(checkForFullscreen()) {
				refreshFrom(stage.fullScreenWidth, stage.fullScreenHeight);
			} else {
				refreshFrom(stage.stageWidth, stage.stageHeight);
			}
		}
		
		static public function refreshFrom(w:int, h:int):void {
			windowSize.width = w;
			windowSize.height = h;
						
			gameSize.width = windowSize.width;
			gameSize.height = windowSize.height;
			  
			if(isHDScreen()) {
				gameSize.width *= 0.5;
				gameSize.height *= 0.5;
			}
			
			if(gameSize.height > 768) {
				resizeFromHeight(768);
			} else if(gameSize.height < 640) {
				resizeFromHeight(640);
			}
			
			scaleRatio.x = gameSize.width/originalRatioSize.width;
			scaleRatio.y = gameSize.height/originalRatioSize.height;
			
			offsetPoint.x = (gameSize.width-originalRatioSize.width);
			offsetPoint.y = (gameSize.height-originalRatioSize.height);
			
			scaleMin = Math.min(scaleRatio.x, scaleRatio.y);
			scaleMax = Math.max(scaleRatio.x, scaleRatio.y);	
		}
		
		static public function getWindowVsGameScaleX():Number{
			return ResolutionManager.windowSize.width / ResolutionManager.gameSize.width;
		}
		
		static public function getWindowVsGameScaleY():Number{
			return ResolutionManager.windowSize.height / ResolutionManager.gameSize.height;
		}
		
		static public function getWindowVsGameScaleMax():Number{
			return Math.max(getWindowVsGameScaleX(), getWindowVsGameScaleY());
		}
		
		static private function checkForFullscreen():Boolean {
			if(!VersionInfo.modelPlatform.isMobile()) return false;
			
			return true; 
		}
		
		static public function getXScale():Number {
			if(gameSize.width < 1024) return 1;
			var result:Number = gameSize.width/1024;
			return result;
		}
		
		static public function resizeFromHeight(h:Number):void {
			var scale:Number = (h/gameSize.height);
			gameSize.width *= scale;  
			gameSize.height *= scale;
		}
		
		static public function getGameWidth():int {
			return gameSize.width;
		}
		
		static public function getGameHeight():int {
			return gameSize.height;
		}
		
		static public function stickDown(mc:MovieClip):void {
			mc.resolutionY = offsetPoint.y; 
		}
		
		static public function stickUp(mc:MovieClip):void {
			//mc.resolutionY = -offsetPoint.y;
		}
		
		static public function stickLeft(mc:MovieClip):void {
			//mc.resolutionX = -offsetPoint.x;
		}
		
		static public function stickRight(mc:MovieClip):void {
			mc.resolutionX = offsetPoint.x;
		}
		
		static public function getScaleMaxFromResolution(w:int, h:int):Number {
			scaleRatio.x = gameSize.width/w;
			scaleRatio.y = gameSize.height/h;
			return Math.max(scaleRatio.x, scaleRatio.y);	
		}
		
		static public function getOffsetPointFromResolution(w:int, h:int, output:Point):Point {
			output.x = (gameSize.width-w);
			output.y = (gameSize.height-h);
			return output;	
		}
		
		public static function scaleCenter(mc : MovieClip) : void {
			
		}
		
		static public function isHDScreen():Boolean {
			 return windowSize.width > 1500 ;	
		}
		
		public static function setFullscreen(b:Boolean):void{
			if(MainGame.instance == null) return;
			if(MainGame.instance.stage == null) return ;
			if(!b) {
				MainGame.instance.stage.displayState = StageDisplayState.NORMAL;
			} else {
				MainGame.instance.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;	
			}	
		}
		
		public static function setResolution(model:ModelResolution):void{
			if(MainGame.instance == null) return;
			if(MainGame.instance.stage == null) return ;
			MainGame.instance.stage.stageHeight = model.height;
			MainGame.instance.stage.stageWidth = model.width;
		}
	}
}
