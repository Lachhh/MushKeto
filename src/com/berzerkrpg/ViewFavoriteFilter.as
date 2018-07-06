package com.berzerkrpg {
	import com.berzerkstudio.flash.display.ButtonSelect;
	import com.lachhh.flash.ui.ButtonSelectGroup;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.ui.views.ViewBase;

	/**
	 * @author Lachhh
	 */
	public class ViewFavoriteFilter extends ViewBase {
		public var buttonGroup:ButtonSelectGroup;
		public function ViewFavoriteFilter(pScreen : Actor, pVisual : DisplayObject) {
			super(pScreen, pVisual);
			buttonGroup = new ButtonSelectGroup();
			buttonGroup.addButton(favOnlyMc);
			buttonGroup.addButton(allMc);
			
			buttonGroup.selectButton(allMc);
			
			screen.registerClick(favOnlyMc, onFav);
			screen.registerClick(allMc, onAll);
		}

		private function onFav() : void {
			buttonGroup.selectButton(favOnlyMc);
			screen.refresh();
		}

		private function onAll() : void {
			buttonGroup.selectButton(allMc);
			screen.refresh();
		}
		
		public function isFavOnly() : Boolean {
			return favOnlyMc.isSelected;
		}
		
		public function get favOnlyMc() : ButtonSelect {	return visualMc.getChildByName("favOnlyMc")  as ButtonSelect;	}
		public function get allMc() : ButtonSelect {return visualMc.getChildByName("allMc")  as ButtonSelect;}

	}
}