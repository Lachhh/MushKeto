package com.berzerkrpg {
	import com.berzerkrpg.meta.MetaRecipe;
	import com.berzerkrpg.meta.ModelIngredientTrait;
	import com.berzerkrpg.meta.ModelIngredientTraitEnum;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.ui.views.ViewBase;

	/**
	 * @author Lachhh
	 */
	public class ViewRecipeTotal extends ViewBase {
		public var metaRecipe:MetaRecipe;
		public function ViewRecipeTotal(pScreen : Actor, pVisual : DisplayObject) {
			super(pScreen, pVisual);
		}

		override public function refresh() : void {
			super.refresh();
		
			for (var i : int = 0; i < ModelIngredientTraitEnum.ALL.length; i++) {
				var m:ModelIngredientTrait = ModelIngredientTraitEnum.ALL[i];
				var txt:TextField = getTraitTxt(m);
				if(txt == null) continue;
				txt.text = metaRecipe.getTotalOfTraitStr(m);
			}
			labelTxt.text = TextFactory.TOTAL.getText();
		}
		
		public function getTraitTxt(modelTrait:ModelIngredientTrait):TextField {
			return visualMc.getChildByName(modelTrait.id) as TextField;
		}
		
		public function get labelTxt() : TextField {	return visualMc.getChildByName("labelTxt")  as TextField;	}
	}
}