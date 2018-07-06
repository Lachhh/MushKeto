package com.berzerkrpg.ui {
	import com.berzerkstudio.flash.display.ButtonSelect;
	import starling.utils.VAlign;

	import com.berzerkrpg.meta.MetaIngredient;
	import com.berzerkrpg.meta.ModelIngredientTrait;
	import com.berzerkrpg.meta.ModelIngredientTraitEnum;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.ui.views.ViewBase;
	/**
	 * @author Lachhh
	 */
	public class ViewIngredientAll extends ViewBase {
		private static const EMPTY : String = "";
		public var metaIngredient : MetaIngredient;

		public function ViewIngredientAll(pScreen : Actor, pVisual : DisplayObject) {
			super(pScreen, pVisual);
			screen.registerClick(starMc, onStar);
			screen.registerClick(addMc, onAdd);
		}

		private function onStar() : void {
			metaIngredient.isFavorite = !metaIngredient.isFavorite;
			refresh();
		}

		private function onAdd() : void {
			metaIngredient.toAddInRecipe = !metaIngredient.toAddInRecipe;
			refresh();
		}


		override public function refresh() : void {
			super.refresh();
			//visual.visible = false;
			if(nameTxt == null) return;
			if (metaIngredient == null) {
				refreshEmpty();
				return;
			}
			
			//visual.visible = true;
			nameTxt.text = metaIngredient.name;
			nameTxt.vAlign = VAlign.CENTER;
			nameTxt.autoFitText = false;
			starMc.selectIfBoolean(metaIngredient.isFavorite);
			addMc.selectIfBoolean(metaIngredient.toAddInRecipe);
			
			for (var i : int = 0; i < ModelIngredientTraitEnum.ALL.length; i++) {
				var m:ModelIngredientTrait = ModelIngredientTraitEnum.ALL[i];
				var txt:TextField = getTraitTxt(m);
				if(txt == null) continue;
				txt.text = metaIngredient.getTotalOfTraitStr(m);
			}
			categoryMc.gotoAndStop(metaIngredient.modelCategory.getFrame());
			
			categoryMc.visible = true;
			addMc.visible = true;
			starMc.visible = true;
		}

		private function refreshEmpty() : void {
			
			nameTxt.text = EMPTY;
			for (var i : int = 0; i < ModelIngredientTraitEnum.ALL.length; i++) {
				var m:ModelIngredientTrait = ModelIngredientTraitEnum.ALL[i];
				var txt:TextField = getTraitTxt(m);
				if(txt == null) continue;
				txt.text = EMPTY;
			}
			
			categoryMc.visible = false;
			addMc.visible = false;
			starMc.visible = false;
		}
		
		public function getTraitTxt(modelTrait:ModelIngredientTrait):TextField {
			return visualMc.getChildByName(modelTrait.id) as TextField;
		}

		public function get nameTxt() : TextField {return visualMc.getChildByName("nameTxt")  as TextField;}
		public function get categoryMc() : MovieClip {	return visual.getChildByName("categoryMc")  as MovieClip;	}
		public function get addMc() : ButtonSelect {	return visual.getChildByName("addMc")  as ButtonSelect;	}
		public function get starMc() : ButtonSelect {	return visual.getChildByName("starMc")  as ButtonSelect;	}
	}
}