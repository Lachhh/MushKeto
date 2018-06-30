package com.berzerkrpg {
	import com.berzerkrpg.components.StarlingTextInputComponent;
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkrpg.meta.MetaRecipe;
	import com.berzerkrpg.ui.ViewRecipeIngredientGroup;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.UIBase;

	/**
	 * @author Lachhh
	 */
	public class UI_RecipeEdit extends UIBase {
		public var viewIngredientsGroup : ViewRecipeIngredientGroup;
		public var viewRecipeTotal : ViewRecipeTotal;
		private var metaRecipe : MetaRecipe;
		private var starlingTxt : StarlingTextInputComponent;
		private var viewRecipeGoal : ViewRecipeGoal;

		public function UI_RecipeEdit(metaRecipe : MetaRecipe) {
			super(ModelFlashAnimationEnum.UI_RECIPEEDIT_ANIM);
			this.metaRecipe = metaRecipe;
			
			viewIngredientsGroup = new ViewRecipeIngredientGroup(this, ingredientsGroupMc);
			viewIngredientsGroup.metaRecipe = metaRecipe;
			
			viewRecipeTotal = new ViewRecipeTotal(this, totalMc);
			viewRecipeTotal.metaRecipe = metaRecipe;

			viewRecipeGoal = new ViewRecipeGoal(this, goalMc);
			viewRecipeGoal.metaGoal = MetaGameProgress.instance.metaSettings.metaGoal;
			
			registerClick(btnX, onX);
			registerClick(addIngredient, onAddIngredient);
			
			MetaGameProgress.instance.metaPendingRecipe = metaRecipe;
			
			starlingTxt = StarlingTextInputComponent.addToActor(this, recipeNameTxt);
			starlingTxt.setRecipeName();
			
			refresh();
		}

		override public function destroy() : void {
			super.destroy();
			metaRecipe.name = starlingTxt.getText();
		}

		private function onAddIngredient() : void {
			destroy();
			new UI_RecipeAddIngredient();
		}

		private function onX() : void {
			destroy();
			new UI_MainMenu();
		}

		override public function refresh() : void {
			super.refresh();
			starlingTxt.setText(metaRecipe.name);
		}

		public function get btnX() : MovieClip { return visual.getChildByName("btnX")  as MovieClip; }
		public function get recipeTotal() : MovieClip {	return visual.getChildByName("recipeTotal")  as MovieClip;	}
		public function get totalMc() : MovieClip {	return recipeTotal.getChildByName("totalMc")  as MovieClip;	}
		public function get goalMc() : MovieClip {	return recipeTotal.getChildByName("goalMc")  as MovieClip;	}
		
		public function get addIngredient() : MovieClip {	return visual.getChildByName("addIngredient")  as MovieClip;	}
		public function get ingredientsGroupMc() : MovieClip {	return visual.getChildByName("ingredientsGroupMc")  as MovieClip;	}
		public function get recipeNameTxt() : TextField {	return visual.getChildByName("recipeNameTxt")  as TextField;	}
	}
}