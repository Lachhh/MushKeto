package com.berzerkrpg.ui {
	import com.lachhhStarling.SymbolManager;
	import com.lachhh.io.ExternalAPIManager;
	import com.berzerkstudio.ModelFla;
	import com.lachhh.lachhhengine.ui.views.ViewGroupBase;
	import com.lachhhStarling.ModelFlaEnum;

	import flash.display.MovieClip;

	/**
	 * @author LachhhSSD
	 */
	public class ViewDebugModelFlaGroup extends ViewGroupBase {
		public var parent:MovieClip ;
		public function ViewDebugModelFlaGroup(pScreen : UI_DebugStarlingStats, pParent : flash.display.MovieClip) {
			super(pScreen, SymbolManager.getEmptyMovieClip());
			parent = pParent;
			createAllView();
		}
		
		public function createAllView():void {
			for (var i : int = 0; i < ModelFlaEnum.ALL.length; i++) {
				var modelFla:ModelFla = ModelFlaEnum.ALL[i];
				var v : ViewDebugModelFla = new ViewDebugModelFla(actor, parent);
				v.visual.x = 0;
				v.visual.y = i*10;
				v.modelFla = modelFla;
				addView(v); 
			}
		}

		override public function refresh() : void {
			super.refresh();
			refreshAllViews();
		}
	}
}
