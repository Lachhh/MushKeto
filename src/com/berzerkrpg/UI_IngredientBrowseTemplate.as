package com.berzerkrpg {
	import com.lachhh.io.Callback;
	import com.lachhh.flash.FlashUtils;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.ui.UI_PopUp;
	import com.berzerkrpg.meta.MetaIngredientGroup;
	import com.berzerkrpg.meta.MetaIngredient;
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.UIBase;

	/**
	 * @author Lachhh
	 */
	public class UI_IngredientBrowseTemplate extends UIBase {
		private var viewIngredientsGroup : ViewIngredientAllGroup;
		private var viewFilter : ViewIngredientCategoryFilter;
		private var viewFavoriteFilter : ViewFavoriteFilter;
		private var viewNameFilter : ViewNameFilter;
		private var listIngredient:Vector.<MetaIngredient> = new Vector.<MetaIngredient>();
		public function UI_IngredientBrowseTemplate() {
			super(ModelFlashAnimationEnum.UI_INGREDIENTBROWSE_ANIM);
			registerClick(btnX, onX);
			//registerClick(editIngredientList, onEditList);

			viewFilter = new ViewIngredientCategoryFilter(this, foodFilterMc);
			viewFavoriteFilter = new ViewFavoriteFilter(this, favoriteMc);
			viewIngredientsGroup = new ViewIngredientAllGroup(this, ingredientGroupMc);
			viewNameFilter = new ViewNameFilter(this, searchMc);
			
			MetaGameProgress.instance.metaSettings.metaIngradientTemplate.metaIngredientGroup.setAllToAddToFalse();
			viewIngredientsGroup.listIngredients = MetaGameProgress.instance.metaSettings.metaIngradientTemplate.metaIngredientGroup.listIngredients;
			
			refresh();
		}

		private function onEditList() : void {
			destroy();
			new UI_IngredientAddInBatch();
		}

		override public function refresh() : void {
			while(listIngredient.length > 0) listIngredient.pop();
			listIngredient = MetaGameProgress.instance.metaSettings.metaIngradientTemplate.metaIngredientGroup.appendAllOfCategory(viewFilter.getCategorySelected(), listIngredient)  ;
			if(viewFavoriteFilter.isFavOnly()) MetaIngredientGroup.keepFavoriteOnly(listIngredient);
			listIngredient = MetaIngredientGroup.keepWithName(listIngredient, viewNameFilter.getSearch());
			viewIngredientsGroup.listIngredients = listIngredient;
			super.refresh();
		}

		private function onX() : void {
			listIngredient = MetaIngredientGroup.keepToAddOnly(listIngredient);
			if(listIngredient.length > 0 && MetaGameProgress.instance.metaPendingRecipe != null) {
				tryToAddInREcipe();
			} else {
				quitToPendingRecipe();
			}
		}

		private function quitToPendingRecipe() : void {
			destroy();
			new UI_RecipeEdit(MetaGameProgress.instance.metaPendingRecipe);
		}
		
		private function tryToAddInREcipe():void {
			listIngredient = MetaIngredientGroup.keepToAddOnly(listIngredient);
			var msg:String = TextFactory.ADD_IN_RECIPE.replaceXValue(listIngredient.length + "");
			msg = FlashUtils.myReplace(msg, "[y]", MetaGameProgress.instance.metaPendingRecipe.name);
			UI_PopUp.createYesNo(msg, new Callback(onYes, this, null), new Callback(quitToPendingRecipe, this, null));
		}

		private function onYes() : void {
			MetaIngredientGroup.setAllFavorite(listIngredient);
			MetaGameProgress.instance.metaPendingRecipe.metaIngredientsGroup.addBatch(listIngredient);
			MetaGameProgress.instance.metaSettings.metaIngradientTemplate.metaIngredientGroup.setAllToAddToFalse();
			MetaGameProgress.instance.saveToLocal();
			quitToPendingRecipe();
		}
		
		public function get btnX() : MovieClip {	return visual.getChildByName("btnX")  as MovieClip;	}
		public function get ingredientGroupMc() : MovieClip {	return visual.getChildByName("ingredientGroupMc")  as MovieClip;	}
		public function get foodFilterMc() : MovieClip {	return visual.getChildByName("foodFilterMc")  as MovieClip;	}
		public function get editIngredientList() : MovieClip {	return visual.getChildByName("editIngredientList")  as MovieClip;	}
		public function get favoriteMc() : MovieClip {	return visual.getChildByName("favoriteMc")  as MovieClip;	}
		public function get searchMc() : MovieClip {	return visual.getChildByName("searchMc")  as MovieClip;	}
	}
}