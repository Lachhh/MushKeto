package com.berzerkrpg.ui {
	import com.berzerkrpg.DefaultMainGame;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.UIBase;

	/**
	 * @author LachhhSSD
	 */
	public class UI_Loading extends UIBase {
		
		public function UI_Loading() {
			super(ModelFlashAnimationEnum.UI_LOADING);
			renderComponent.animView.addChildOnNewParent(DefaultMainGame.UI_CONTAINER_ABOVE_NO_CLICK);
			centerOnWindow();
		}
		
		public function get msgTxt() : TextField { return visual.getChildByName("msgTxt") as TextField;}
		
		static public function tapToResume():UI_Loading {
			var ui:UI_Loading = show(TextFactory.TAP_TO_RESUME.getText());
			ui.registerClick(ui.renderComponent.animView.anim, UI_Loading.hide);
			ui.enableInput(true);
			return ui;
		}
		
		static public function show(msg:String):UI_Loading {
			var ui:UI_Loading = UIBase.manager.getFirst(UI_Loading) as UI_Loading;
			if(ui == null) {
				ui = new UI_Loading();
			}
			ui.enableInput(false);
			ui.msgTxt.text = msg;
			return ui;
		}
		
		static public function hide():void {
			var ui:UI_Loading = UIBase.manager.getFirst(UI_Loading) as UI_Loading;
			if(ui) {
				ui.destroy();
			}
		}
		
		static public function isShown():Boolean {
			var ui:UI_Loading = UIBase.manager.getFirst(UI_Loading) as UI_Loading;
			if(ui == null) return false;
			return true;
		}
	}
}
