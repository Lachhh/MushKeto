package com.berzerkrpg {
	import flash.ui.Keyboard;
	import com.lachhh.io.KeyManager;
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkrpg.meta.MetaRecipe;
	import com.berzerkrpg.components.StarlingTextInputComponent;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.UIOpenClose;

	/**
	 * @author Lachhh
	 */
	public class UI_PopUpAddRecipe extends UIOpenClose {
		private var textInputUser : StarlingTextInputComponent;

		public function UI_PopUpAddRecipe() {
			super(ModelFlashAnimationEnum.UI_POPUPINSERT_ANIM, 20, 35);
			registerClick(btn1, onCancel);
			registerClick(btn3, onConfirm);

			btn2.visible = false;
			setNameOfDynamicBtn(btn1, TextFactory.CANCEL.getText());
			setNameOfDynamicBtn(btn3, TextFactory.CONFIRM.getText());
			
			textInputUser = StarlingTextInputComponent.addToActor(this, urlTxt);
			textInputUser.setRecipeName();
		}

		private function onConfirm() : void {
			closeWithCallbackOnEnd(new Callback(addToEditRecipe, this, null));
		}

		private function addToEditRecipe() : void {
			destroy();
			var result:MetaRecipe = new MetaRecipe();
			result.name = textInputUser.getText();
			MetaGameProgress.instance.metaRecipeGroup.add(result);
			MetaGameProgress.instance.saveToLocal();
			new UI_RecipeEdit(result);
		}

		private function onCancel() : void {
			closeWithCallbackOnEnd(new Callback(backToMain, this, null));
		}

		private function backToMain() : void {
			destroy();
			new UI_MainMenu();
		}

		override public function update() : void {
			super.update();
			if(!isListeningToInput) return ;
			if(KeyManager.IsKeyPressed(Keyboard.ENTER)) {
				onConfirm();
			}
		}

		public function get panel() : MovieClip {
			return visual.getChildByName("panel")  as MovieClip;
		}
		public function get urlTxt() : TextField {	return panel.getChildByName("urlTxt")  as TextField;	}
		public function get btn1() : MovieClip {	return panel.getChildByName("btn1")  as MovieClip;	}
		public function get btn2() : MovieClip {	return panel.getChildByName("btn2")  as MovieClip;	}
		public function get btn3() : MovieClip {	return panel.getChildByName("btn3")  as MovieClip;	}
	}
}