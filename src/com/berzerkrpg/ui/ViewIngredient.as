package com.berzerkrpg.ui {
	import starling.utils.VAlign;

	import com.berzerkrpg.UI_RecipeEdit;
	import com.berzerkrpg.components.StarlingTextInputComponent;
	import com.berzerkrpg.meta.MetaIngredient;
	import com.berzerkrpg.meta.ModelIngredientTrait;
	import com.berzerkrpg.meta.ModelIngredientTraitEnum;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.flash.FlashUtils;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.ui.views.ViewBase;
	/**
	 * @author Lachhh
	 */
	public class ViewIngredient extends ViewBase {
		public var metaIngredient : MetaIngredient;
		private var inputQty : StarlingTextInputComponent;

		public function ViewIngredient(pScreen : Actor, pVisual : DisplayObject) {
			super(pScreen, pVisual);
			
			inputQty = StarlingTextInputComponent.addToActor(actor, qtyTxt);
			inputQty.setQty();
			inputQty.showStarling();
			inputQty.onEndEditCallback = new Callback(onEditQty, this, null);
			
			screen.registerClick(qtyTxt, onQty);
		}

		private function onQty() : void {
			inputQty.showFlash();
			inputQty.showKeyboard();
		}

		override public function destroy() : void {
			super.destroy();
			inputQty.destroyAndRemoveFromActor();
		}

		private function onEditQty() : void {
			var n:int =  FlashUtils.myParseFloat(inputQty.getText());
			
			if(isNaN(n) || n == 0) {
				inputQty.showStarling();
				refresh();
				return;
			}
			
			metaIngredient.qty = n;
			inputQty.showStarling();
			(screen as UI_RecipeEdit).viewRecipeTotal.refresh();
			refresh();
		}

		override public function refresh() : void {
			super.refresh();
			if(metaIngredient == null) return;
			inputQty.setText(metaIngredient.qtyStr());
			nameTxt.text = metaIngredient.name;
			nameTxt.vAlign = VAlign.CENTER;
			nameTxt.autoFitText = false;
			
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
		public function get qtyTxt() : TextField {	return visualMc.getChildByName("qtyTxt")  as TextField;	}
	}
}