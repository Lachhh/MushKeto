package com.berzerkrpg.ui {
	import com.berzerkrpg.meta.MetaIngredient;
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.views.ViewBaseDynamic;

	/**
	 * @author Lachhh
	 */
	public class ViewIngredientAllDynamic extends ViewBaseDynamic {
		private var viewIngredient : ViewIngredientAll;
		
		public function ViewIngredientAllDynamic(pScreen : Actor, pVisual : DisplayObjectContainer) {
			super(pScreen, pVisual, ModelFlashAnimationEnum.FX_INGREDIENT_ALL_ANIM);
			viewIngredient = new ViewIngredientAll(pScreen, visualMc);
		}

		override public function refresh() : void {
			super.refresh();
			viewIngredient.refresh();
		}

		public function get metaIngredient() : MetaIngredient {
			return viewIngredient.metaIngredient;
		}
		public function set metaIngredient(metaIngredient : MetaIngredient) : void { viewIngredient.metaIngredient = metaIngredient; }
	}
}