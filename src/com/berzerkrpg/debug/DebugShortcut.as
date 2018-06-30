package com.berzerkrpg.debug {
	import flash.ui.Keyboard;
	import com.lachhh.io.KeyManager;
	import com.berzerkrpg.MainGame;
	import com.lachhh.ResolutionManager;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.lachhhengine.ui.UIBase;
	import com.lachhhStarling.StarlingMain;

	import flash.display.StageDisplayState;
	import flash.geom.Point;

	/**
	 * @author LachhhSSD
	 */
	public class DebugShortcut extends ActorComponent {
		private var tempPoint : Point = new Point();
		public function DebugShortcut() {
			super();
		}

		override public function update() : void {
			super.update();
			if(!VersionInfo.haveAccessToShortcutDebug()) return ;
			
			if(KeyManager.IsKeyPressed(Keyboard.F1)) {
				toggleFullscreen();
			}
		}
		
	
		
		static public function testSize(w:int, h:int):void {
			//MobileSplashScreen.show(MainGame.instance.stage);
			
			//MainGame.instance.stage.nativeWindow.width = w+16;
			//MainGame.instance.stage.nativeWindow.height = h+40;
			
			ResolutionManager.refresh(MainGame.instance.stage);
			StarlingMain.refreshResolution();
			UIBase.manager.refresh();
		}
		
		static public function toggleFullscreen():void {
			if(MainGame.instance.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE) {
				MainGame.instance.stage.displayState = StageDisplayState.NORMAL;
			} else {
				MainGame.instance.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;	
			}	
		}
		
		static public function log(obj:Object):void{
			trace("[DEBUG SHORTCUT] : " + obj.toString());
		}
		
		static public function addToActor(actor: Actor): DebugShortcut {
			var result: DebugShortcut = new DebugShortcut ();
			actor.addComponent(result);
			return result;
		}
	}
}
