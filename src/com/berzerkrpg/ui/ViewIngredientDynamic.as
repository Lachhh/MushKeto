package com.berzerkrpg.ui {
	import com.berzerkrpg.meta.MetaIngredient;
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.views.ViewBaseDynamic;

	/**
	 * @author Lachhh
	 */
	public class ViewIngredientDynamic extends ViewBaseDynamic {
		private var viewIngredient : ViewIngredient;
		
		public function ViewIngredientDynamic(pScreen : Actor, pVisual : DisplayObjectContainer) {
			super(pScreen, pVisual, ModelFlashAnimationEnum.FX_INGREDIENT_ANIM);
			viewIngredient = new ViewIngredient(pScreen, visualMc);
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