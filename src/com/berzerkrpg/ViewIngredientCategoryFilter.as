package com.berzerkrpg {
	import com.lachhh.flash.ui.ButtonSelectGroup;
	import com.berzerkrpg.meta.ModelIngredientCategoryEnum;
	import com.lachhh.lachhhengine.ui.views.ViewGroupBase;
	import com.berzerkrpg.meta.ModelIngredientCategory;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.ui.views.ViewBase;

	/**
	 * @author Lachhh
	 */
	public class ViewIngredientCategoryFilter extends ViewGroupBase {
		public var buttonSelect:ButtonSelectGroup = new ButtonSelectGroup();
		
		public function ViewIngredientCategoryFilter(pScreen : Actor, pVisual : DisplayObject) {
			super(pScreen, pVisual);
			createAllViews();
			visualMc.gotoAndStop(1);
		}
		
		public function setNoAll():void {
			visualMc.gotoAndStop(2);
			if(getCategorySelected().isAll()) {
				buttonSelect.selectButtonFromIndex(1);	
			}
		}

		private function createAllViews() : void {
			for (var i : int = 0; i < ModelIngredientCategoryEnum.ALL.length; i++) {
				var modelCategory:ModelIngredientCategory = ModelIngredientCategoryEnum.ALL[i];
				var childVisual : MovieClip = getCategoryVisual(modelCategory);
				var newView : ViewIngredientCategory = new ViewIngredientCategory(screen, childVisual);
				newView.modelCategory = modelCategory;
				newView.refresh();
				buttonSelect.addButton(newView.visualBtn);  
				addView(newView);
				if(i == 0) buttonSelect.selectButton(newView.visualBtn);
			}
		}

		override public function onClickView(v : ViewBase) : void {
			super.onClickView(v);
			buttonSelect.selectButton(v.visualBtn);
			screen.refresh();
		}

		public function getCategoryVisual(m : ModelIngredientCategory) : MovieClip {	
			return visualMc.getChildByName(m.id) as MovieClip;	
		}
		
		public function getViewSelected():ViewIngredientCategory {
			for (var i : int = 0; i < views.length; i++) {
				var v:ViewIngredientCategory = views[i] as ViewIngredientCategory;
				if(v.visualBtn.isSelected) return v;
			}
			return null;
		}
		
		public function getCategorySelected():ModelIngredientCategory {
			var v:ViewIngredientCategory = getViewSelected();
			if(v == null) return ModelIngredientCategoryEnum.NULL;
			return v.modelCategory;
		}
	}
}