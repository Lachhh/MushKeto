package com.berzerkrpg.ui {
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.DefaultMainGame;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.MetaTwitchCmd;
	import com.lachhh.lachhhengine.ui.UIOpenClose;
	import com.lachhh.utils.Utils;

 
/**
 * @author Lachhh
 */
	public class UI_PopUp extends UIOpenClose {
		public var callbackYes:Callback;
		public var callbackOk:Callback;
		public var callbackNo:Callback;

		public var msg:String;
		public var btnOnEnter:MovieClip;

		public function UI_PopUp(pMsg : String) {
			super(ModelFlashAnimationEnum.UI_POPUP, 20, 35);
			renderComponent.animView.addChildOnNewParent(DefaultMainGame.UI_CONTAINER_ABOVE);
			registerClicks();
			yesBtn.visible = true;
			okBtn.visible = true;
			noBtn.visible = true;
			msg = pMsg;
			descTxt.autoFitText = false;
			
			btnOnEnter = null;
			endTextFieldBatchForStarlingMc(visual);
			centerOnWindow();
			
			setNameOfDynamicBtn(yesBtn, TextFactory.YES.getText());
			setNameOfDynamicBtn(noBtn, TextFactory.NO.getText());
			setNameOfDynamicBtn(okBtn, TextFactory.OK.getText());
			
			refresh();
		}

		protected function registerClicks() : void {
			registerClick(yesBtn, onBtn1);
			registerClick(okBtn, onBtn2);
			registerClick(noBtn, onBtn3);
			registerClick(visual.getChildAt(0), onBack);
			registerClick(panel, doNothing);
			
		}
		
		public function onBack() : void {
			if(isOkOnlyBtn()) {
				closeWithCallbackOnEnd(callbackOk);
			} else {
				closeWithCallbackOnEnd(callbackNo);
			}
		}
		
		protected function setAnim(animId:ModelFlashAnimation):void {
			renderComponent.setAnim(animId);
			visual = renderComponent.animView.anim;
			//addOpenCloseCallbacks();
			registerClicks();
		}
		
		public function onYes() : void {
			onBtn1();
		}
		
		private function onBtn1() : void {
			closeWithCallbackOnEnd(callbackYes);
			//SfxFactory.onClickSound();
			doBtnPressAnim(yesBtn);
		}

		private function onBtn2() : void {
			closeWithCallbackOnEnd(callbackOk);
			//SfxFactory.onClickSound();
			doBtnPressAnim(okBtn);
		}

		private function onBtn3() : void {
			closeWithCallbackOnEnd(callbackNo);
			//SfxFactory.onClickSound();
			doBtnPressAnim(noBtn);
		}

		override public function refresh() : void {
			super.refresh();
			descTxt.text = msg;
			Utils.SetMaxSizeOfTxtFieldAnim(descTxt, 12);
		}
		
		
		override public function update() : void {
			super.update();
			/*if(KeyManager.IsKeyPressed(Keyboard.ENTER)) {
				switch(btnOnEnter) {
					case yesBtn : onBtn1(); break;
					case okBtn : onBtn2(); break;
					case noBtn : onBtn3(); break;
				}
			}*/
		}
		
		private function isOkOnlyBtn():Boolean {
			if(yesBtn.visible) return false;
			if(noBtn.visible) return false;
			return true;
		}
		
		public function get yesBtn():MovieClip { return (panel.getChildByName("yesBtn")) as MovieClip;}
		public function get okBtn():MovieClip { return (panel.getChildByName("okBtn")) as MovieClip;}
		public function get noBtn():MovieClip { return (panel.getChildByName("noBtn")) as MovieClip;}
		public function get panel():MovieClip { return (visual.getChildByName("popupMc")) as MovieClip;}
		
		public function get yesMc():MovieClip { return (yesBtn.getChildByName("yesMc")) as MovieClip;}
		public function get yesTxt():TextField{ return (yesMc.getChildByName("yesTxt")) as TextField;}
		
		public function get noMc():MovieClip { return (noBtn.getChildByName("noMc")) as MovieClip;}
		public function get noTxt():TextField{ return (noMc.getChildByName("noTxt")) as TextField;}
		
		
		public function get descTxt() : TextField { return panel.getChildByName("popupTxt") as TextField;}
		
		static public function createOkOnlySimple(msg:String):UI_PopUp {
			return createOkOnly(msg, null);
		}
		
		static public function createOkOnly(msg:String, callback:Callback):UI_PopUp {
			var result:UI_PopUp = new UI_PopUp(msg);
			result.noBtn.visible = false;
			result.yesBtn.visible = false;
			result.callbackOk = callback;
			result.btnOnEnter = result.okBtn;
			//result.setNameOfDynamicBtn(result.btn1, "Yes");
			//result.setNameOfDynamicBtn(result.btn2, "Ok");
			//result.setNameOfDynamicBtn(result.btn3, "No");
			return result; 
		}
		
		static public function createYesNo(msg:String, yes:Callback, no:Callback):UI_PopUp {
			var result:UI_PopUp = new UI_PopUp(msg);
			result.okBtn.visible = false;
			result.callbackYes = yes;
			result.callbackNo = no;
			result.btnOnEnter = result.yesBtn;
			//result.setNameOfDynamicBtn(result.btn1, "Yes");
			//result.setNameOfDynamicBtn(result.btn2, "Ok");
			//result.setNameOfDynamicBtn(result.btn3, "No");
			return result; 
		}
		
		static public function createLoading(msg:String):UI_PopUp {
			var result:UI_PopUp = new UI_PopUp(msg);
			result.yesBtn.visible = false;
			result.okBtn.visible = false;
			result.noBtn.visible = false;
			
			return result; 
		}
	}
}