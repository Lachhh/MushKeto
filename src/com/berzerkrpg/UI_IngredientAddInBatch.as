package com.berzerkrpg {
	import com.berzerkrpg.meta.ModelIngredientCategory;
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.lachhh.io.Callback;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.Clipboard;
	import com.lachhh.flash.FlashUtils;
	import com.berzerkrpg.ui.UI_PopUp;
	import com.berzerkrpg.meta.MetaIngredient;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.components.StarlingTextInputComponent;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.UIBase;

	/**
	 * @author Lachhh
	 */
	public class UI_IngredientAddInBatch extends UIBase {
		public var viewFilter : ViewIngredientCategoryFilter;
		private var input : StarlingTextInputComponent;

		public function UI_IngredientAddInBatch() {
			super(ModelFlashAnimationEnum.UI_INGREDIENTSTEMPLATES_ANIM);
			viewFilter = new ViewIngredientCategoryFilter(this, foodFilterMc);
			viewFilter.setNoAll();
			
			registerClick(btnX, onX);
			registerClick(addIngredient, onAddIngredient);
			registerClick(inputTxt, onFocusText);

			input = StarlingTextInputComponent.addToActor(this, inputTxt);
			input.setListOfIngredients();
			
			setNameOfDynamicBtn(addIngredient, TextFactory.CONFIRM.getText());
		}

		private function onFocusText() : void {
			input.showFlash();
		}

		private function onAddIngredient() : void {
			//input.setText("");
			input.showStarling();
			var modelCategory:ModelIngredientCategory = viewFilter.getCategorySelected();
			var txt:String = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT) as String;
			var list:Vector.<MetaIngredient> = MetaIngredient.createListFromStr(modelCategory, txt);
			var msg:String = TextFactory.REPLACE_CATEGORY.replaceXValue(list.length.toFixed());
			msg = FlashUtils.myReplace(msg, "[y]", modelCategory.name.getText());

			UI_PopUp.createYesNo(msg, new Callback(onYes, this, [list]), null);
		}

		private function onYes(list:Vector.<MetaIngredient>) : void {
			MetaGameProgress.instance.metaSettings.metaIngradientTemplate.metaIngredientGroup.replaceCategory(viewFilter.getCategorySelected(), list);
			MetaGameProgress.instance.saveToLocal();
			input.setText("");
			UI_PopUp.createOkOnly(TextFactory.ADD_IN_BATCH_SUCCESS.getText(), new Callback(onConfirmOk, this, null));
		}

		private function onConfirmOk() : void {
			input.showFlash();
			input.setText("< Copy paste ingredients here >");
		}

		private function onX() : void {
			destroy();
			new UI_MainMenu();
		}
		
		public function get foodFilterMc() : MovieClip {	return visual.getChildByName("foodFilterMc")  as MovieClip;	}
		public function get btnX() : MovieClip {	return visual.getChildByName("btnX")  as MovieClip;	}
		public function get addIngredient() : MovieClip {	return visual.getChildByName("addIngredient")  as MovieClip;	}
		public function get inputTxt() : TextField {	return visual.getChildByName("inputTxt")  as TextField;	}	
	}
}