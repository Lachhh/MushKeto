package com.berzerkrpg.ui {
	import com.berzerkrpg.meta.MetaIngredient;
	import com.berzerkrpg.meta.ModelIngredientTrait;
	import com.berzerkrpg.meta.ModelIngredientTraitEnum;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.ui.views.ViewBase;
	/**
	 * @author Lachhh
	 */
	public class ViewIngredientAll extends ViewBase {
		public var metaIngredient : MetaIngredient;
		

		public function ViewIngredientAll(pScreen : Actor, pVisual : DisplayObject) {
			super(pScreen, pVisual);
		}

		

		override public function refresh() : void {
			super.refresh();
			if(metaIngredient == null) return;
			nameTxt.text = metaIngredient.modelIngredient.name;
			
			for (var i : int = 0; i < ModelIngredientTraitEnum.ALL.length; i++) {
				var m:ModelIngredientTrait = ModelIngredientTraitEnum.ALL[i];
				var txt:TextField = getTraitTxt(m);
				if(txt == null) continue;
				txt.text = metaIngredient.getTotalOfTraitStr(m);
			}
		}
		
		public function getTraitTxt(modelTrait:ModelIngredientTrait):TextField {
			return visualMc.getChildByName(modelTrait.id) as TextField;
		}

		public function get nameTxt() : TextField {return visualMc.getChildByName("nameTxt")  as TextField;}
	}
}