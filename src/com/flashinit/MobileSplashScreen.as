package com.flashinit {
	import com.animation.exported.UI_SPLASHSCREEN_AS_PNG;
	import com.animation.exported.UI_SPLASHSCREEN_AS_PNG_HD;
	import com.lachhh.ResolutionManager;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * @author LachhhSSD
	 */
	public class MobileSplashScreen {
		public var splash : MovieClip;
		private var stage : Stage;
		private var berzerkPos : Point = new Point();
		private var titlePos : Point = new Point();
		static public var instance:MobileSplashScreen;

		public function MobileSplashScreen(pSstage:Stage) {
			stage = pSstage;
			ResolutionManager.refresh(stage);
			if(ResolutionManager.isHDScreen()) {
				splash = new UI_SPLASHSCREEN_AS_PNG_HD();
			} else {
				splash = new UI_SPLASHSCREEN_AS_PNG();
			}
			
			stage.addChild(splash);
			instance = this;
			if(berzerkMc) {
				berzerkPos.x = berzerkMc.x;
				berzerkPos.y = berzerkMc.y;
			}
			
			if(titleMc) {
				titlePos.x = titleMc.x;
				titlePos.y = titleMc.y;
			}
			
			stage.addEventListener(Event.RESIZE, onResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			splash.x = ResolutionManager.windowSize.width*0.5;
			splash.y = ResolutionManager.windowSize.height*0.5;
			recurGotoStop1(splash);
			
			refresh();
		}
		
		public function recurGotoStop1(mc:MovieClip):void {
			for (var i:int = 0 ; i < mc.numChildren ; i++)	 {
				var m:MovieClip = mc.getChildAt(i) as MovieClip;
				if(m) {
					recurGotoStop1(m);
					m.gotoAndStop(1);
				}	
			}
		}
		
		public function refresh():void {
			
			var w:Number = ResolutionManager.windowSize.width;
			var h:Number = ResolutionManager.windowSize.height;
			if(ResolutionManager.isHDScreen()) {
				w *= 0.5;
				h *= 0.5;
			}
									
			var p:Point = new Point();
			p.x = (w-ResolutionManager.originalRatioSize.width);
			p.y = (h-ResolutionManager.originalRatioSize.height);
			
			var ratio:Point = new Point();
			ratio.x = (w/ResolutionManager.originalRatioSize.width);
			ratio.y = (h/ResolutionManager.originalRatioSize.height);
			
			backMc.scaleX = Math.max(ratio.x, ratio.y);
			backMc.scaleY = backMc.scaleX;
			
			//backMc.y = ((backMc.height) - ResolutionManager.windowSize.height) / 2;
			
			if(berzerkMc) {
				berzerkMc.x = berzerkPos.x + p.x*0.5;
				berzerkMc.y = berzerkPos.y + p.y*0.5;
				berzerkMc.visible = false;
			}
			
			snapTitleToRight(p);
			// snapTitleToLeft(p);
			
		}
		
		private function snapTitleToRight(p:Point):void {
			if(titleMc == null) return;
			titleMc.x = titlePos.x + p.x*0.5;
			titleMc.y = titlePos.y - p.y*0.5;
		}
		
		private function snapTitleToLeft(p:Point):void {
			if(titleMc == null) return;
			titleMc.x = titlePos.x - p.x*0.5;
			titleMc.y = titlePos.y - p.y*0.5;
		}
		
		private function onResize(event : Event) : void {
			ResolutionManager.refresh(stage);
			refresh();
		}
	
		public function destroy() : void {
			if(stage == null) return;
			stage.removeEventListener(Event.RESIZE, onResize);
			stage.removeChild(splash);
			stage = null;
			splash = null;
			instance = null;
		}

		static public function show(pSstage : Stage) : MobileSplashScreen {
			if(instance) return instance;
			var result:MobileSplashScreen = new MobileSplashScreen(pSstage);
			return result;
		}
		
		static public function isVisible() : Boolean {
			return (instance != null);
		}
		
		static public function hide() : void {
			if(instance == null) return ;
			instance.destroy();
		}
		
		
		public function get backMc() : DisplayObject { return splash.getChildByName("backMc") as DisplayObject;}
		public function get berzerkMc() : DisplayObject { return splash.getChildByName("berzerkMc") as DisplayObject;}
		public function get titleMc() : DisplayObject {return splash.getChildByName("titleMc") as DisplayObject;}
		
	}
}
