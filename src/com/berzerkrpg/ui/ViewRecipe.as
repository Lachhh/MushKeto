package com.berzerkrpg.ui {
	import com.berzerkrpg.UI_RecipeEdit;
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkrpg.meta.MetaRecipe;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.ui.UIBase;
	import com.lachhh.lachhhengine.ui.views.ViewBase;

	/**
	 * @author Lachhh
	 */
	public class ViewRecipe extends ViewBase {
		public var metaRecipe:MetaRecipe;
		public function ViewRecipe(pScreen : Actor, pVisual : DisplayObject) {
			super(pScreen, pVisual);
			btn1.visible = false;
			UIBase.setNameOfDynamicBtn(btn1, TextFactory.EDIT.getText());
			UIBase.setNameOfDynamicBtn(btn2, TextFactory.EDIT.getText());
			UIBase.setNameOfDynamicBtn(btn3, TextFactory.DELETE.getText());
			
			
			screen.registerClick(btn2, onEdit);
			screen.registerClick(btn3, onDelete);
		}

		private function onEdit() : void {
			screen.destroy();
			new UI_RecipeEdit(metaRecipe);
		}

		private function onDelete() : void {
			UI_PopUp.createYesNo(TextFactory.DELETE_RECIPE.replaceXValue(metaRecipe.name), new Callback(onYes, this, null), null);
		}

		private function onYes() : void {
			MetaGameProgress.instance.metaRecipeGroup.remove(metaRecipe);
			MetaGameProgress.instance.saveToLocal();
			screen.refresh();
		}

		override public function refresh() : void {
			super.refresh();
			if(metaRecipe == null) return;
			if(nameTxt == null) return;
			nameTxt.text = metaRecipe.name;
		}

		public function get nameTxt() : TextField { return visualMc.getChildByName("nameTxt")  as TextField;}
		public function get btn1() : MovieClip {	return visualMc.getChildByName("btn1")  as MovieClip;	}
		public function get btn2() : MovieClip {	return visualMc.getChildByName("btn2")  as MovieClip;	}
		public function get btn3() : MovieClip {	return visualMc.getChildByName("btn3")  as MovieClip;	}
	}
}