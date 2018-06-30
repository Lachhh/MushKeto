package com.berzerkrpg {
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.UIBase;

	/**
	 * @author Lachhh
	 */
	public class UI_RecipeBrowse extends UIBase {
		private var viewRecipeGroup : ViewRecipeGroup;

		public function UI_RecipeBrowse() {
			super(ModelFlashAnimationEnum.UI_RECIPEBROWSE_ANIM);
			registerClick(btnX, onX);
			registerClick(btnAddRecipe, onAddRecipe);

			viewRecipeGroup = new ViewRecipeGroup(this, recipeGroupMc);
			viewRecipeGroup.metaRecipeGroup = MetaGameProgress.instance.metaRecipeGroup;
			
			refresh();
		}

		private function onAddRecipe() : void {
			destroy();
			new UI_PopUpAddRecipe();
		}

		private function onX() : void {
			destroy();
			new UI_MainMenu();
		}
		
		public function get btnX() : MovieClip {	return visual.getChildByName("btnX")  as MovieClip;	}
		public function get btnAddRecipe() : MovieClip {	return visual.getChildByName("btnAddRecipe")  as MovieClip;	}
		public function get recipeGroupMc() : MovieClip {	return visual.getChildByName("recipeGroupMc")  as MovieClip;	}
	}
}