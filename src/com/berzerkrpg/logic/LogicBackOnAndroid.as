package com.berzerkrpg.logic {
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.ui.UI_PopUp;
	import com.lachhh.io.Callback;
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.lachhhengine.ui.UIBase;

	import flash.desktop.NativeApplication;
	import flash.ui.Keyboard;

	/**
	 * @author LachhhSSD
	 */
	public class LogicBackOnAndroid extends ActorComponent {
		private var uiQuit:UI_PopUp;
		public var isAskWhenClose:Boolean = false;
		public function LogicBackOnAndroid() {
			super();
		}

		override public function update() : void {
			super.update();
			if (KeyManager.IsKeyPressed(Keyboard.BACK) || KeyManager.IsKeyPressed(Keyboard.ESCAPE)) {
				back();
			}
		}

		private function back() : void {
			var ui:UIBase ;
		
			var uiPopup:UI_PopUp = UIBase.manager.getFirst(UI_PopUp) as UI_PopUp;
		
			
			if(uiQuit) {
				if(uiQuit.destroyed) {
					uiQuit = null;
				} else {
					uiQuit.onBack();
					return ;
				}
			}
			
				
			if(uiPopup) {
				uiPopup.onBack();
				return;
			}
			
			
			if(!isAskWhenClose) {
				quitApplication();
				return ;
			}
			
			
			if(uiQuit == null) {
				uiQuit = UI_PopUp.createYesNo(TextFactory.QUIT_GAME.getText(), new Callback(quitApplication, this, null), null);
			}
		}
		
		private function quitApplication():void {
			NativeApplication.nativeApplication.exit();
		}
	}
}
