package com.berzerkrpg {
	import flash.ui.Keyboard;
	import com.lachhh.io.KeyManager;
	import com.lachhh.io.Callback;
	import com.berzerkrpg.components.StarlingTextInputComponent;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.ui.views.ViewBase;

	/**
	 * @author Lachhh
	 */
	public class ViewNameFilter extends ViewBase {
		public var input:StarlingTextInputComponent;
		public function ViewNameFilter(pScreen : Actor, pVisual : DisplayObject) {
			super(pScreen, pVisual);
			input = StarlingTextInputComponent.addToActor(actor, nameTxt);
			input.setAsSearch();
			input.onEndEditCallback = new Callback(onEdit, this, null);
		}

		private function onEdit() : void {
			screen.refresh();
		}

		override public function update() : void {
			super.update();
			if(KeyManager.IsKeyPressed(Keyboard.ENTER)) {
				onEdit();
			}
		}

		public function get nameTxt() : TextField {
			return visual.getChildByName("nameTxt")  as TextField;
		}

		public function getSearch() : String {
			return input.getText();
		}
	}
}