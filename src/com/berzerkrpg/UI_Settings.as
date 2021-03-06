package com.berzerkrpg {
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.UIBase;

	/**
	 * @author Lachhh
	 */
	public class UI_Settings extends UIBase {
		public function UI_Settings() {
			super(ModelFlashAnimationEnum.UI_SETTINGS_ANIM);
			registerClick(btnX, onX);
			registerClick(editIngredientList, onEdit);
		}

		private function onEdit() : void {
			destroy();
			new UI_IngredientAddInBatch();
		}

		private function onX() : void {
			destroy();
			new UI_MainMenu();
		}
		
		public function get btnX() : MovieClip {	return visual.getChildByName("btnX")  as MovieClip;	}
		public function get editIngredientList() : MovieClip {	return visual.getChildByName("editIngredientList")  as MovieClip;	}
	}
}