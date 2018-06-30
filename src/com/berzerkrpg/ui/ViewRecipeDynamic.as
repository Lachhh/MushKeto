package com.berzerkrpg.ui {
	import com.berzerkrpg.meta.MetaRecipe;
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.ui.views.ViewBaseDynamic;

	/**
	 * @author Lachhh
	 */
	public class ViewRecipeDynamic extends ViewBaseDynamic {
		private var viewRecipe : ViewRecipe;

		public function ViewRecipeDynamic(pScreen : Actor, pVisual : DisplayObjectContainer) {
			super(pScreen, pVisual, ModelFlashAnimationEnum.FX_RECIPE_ANIM);
			viewRecipe = new ViewRecipe(pScreen, visualMc);
		}

		override public function refresh() : void {
			super.refresh();
			viewRecipe.refresh();
		}

		public function set metaRecipe(metaRecipe : MetaRecipe) : void { viewRecipe.metaRecipe = metaRecipe; }
		public function get metaRecipe() : MetaRecipe { return viewRecipe.metaRecipe; }
	}
}