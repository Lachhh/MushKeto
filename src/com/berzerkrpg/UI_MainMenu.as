package com.berzerkrpg {
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.UIBase;

	/**
	 * @author Lachhh
	 */
	public class UI_MainMenu extends UIBase {
		public function UI_MainMenu() {
			super(ModelFlashAnimationEnum.UI_MAINMENU_ANIM);
			

			registerClick(addRecipe, onAddRecipe);
			registerClick(viewRecipe, onViewRecipe);
			registerClick(settings, onSettings);
		}

		private function onAddRecipe() : void {
			destroy();
			new UI_PopUpAddRecipe();
		}

		private function onViewRecipe() : void {
			destroy();
			new UI_RecipeBrowse();
		}

		private function onSettings() : void {
			destroy();
			new UI_Settings();
		}
		
		public function get addRecipe() : MovieClip {	return visual.getChildByName("addRecipe")  as MovieClip;	}
		public function get viewRecipe() : MovieClip {	return visual.getChildByName("viewRecipe")  as MovieClip;	}
		public function get settings() : MovieClip {	return visual.getChildByName("settings")  as MovieClip;	}
	}
}