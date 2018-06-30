package com.berzerkrpg {
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkrpg.meta.ModelIngredientEnum;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.UIBase;

	/**
	 * @author Lachhh
	 */
	public class UI_RecipeAddIngredient extends UIBase {
		private var viewIngredientsGroup : ViewIngredientAllGroup;

		public function UI_RecipeAddIngredient() {
			super(ModelFlashAnimationEnum.UI_INGREDIENTBROWSE_ANIM);
			registerClick(btnX, onX);

			viewIngredientsGroup = new ViewIngredientAllGroup(this, ingredientGroupMc);
			viewIngredientsGroup.listIngredients = ModelIngredientEnum.ALL_METAS;
			
			refresh();
		}

		private function onX() : void {
			destroy();
			new UI_RecipeEdit(MetaGameProgress.instance.metaPendingRecipe);
		}
		
		public function get btnX() : MovieClip {	return visual.getChildByName("btnX")  as MovieClip;	}
		public function get ingredientGroupMc() : MovieClip {	return visual.getChildByName("ingredientGroupMc")  as MovieClip;	}
	}
}