package com.berzerkrpg {
	import com.berzerkrpg.meta.ModelIngredientCategory;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.ui.views.ViewBase;

	/**
	 * @author Lachhh
	 */
	public class ViewIngredientCategory extends ViewBase {
		public var modelCategory : ModelIngredientCategory;

		public function ViewIngredientCategory(pScreen : Actor, pVisual : DisplayObject) {
			super(pScreen, pVisual);
		}

		override public function refresh() : void {
			super.refresh();
			foodIcon.gotoAndStop(modelCategory.getFrame());
		}
		
		public function get foodIcon() : MovieClip {	return visualMc.getChildByName("foodIcon")  as MovieClip;	}
	}
}