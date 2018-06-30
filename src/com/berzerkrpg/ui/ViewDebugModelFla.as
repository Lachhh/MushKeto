package com.berzerkrpg.ui {
	import com.animation.exported.DEBUG_TXT;
	import com.berzerkstudio.ModelFla;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.ui.views.ViewBase;
	import com.lachhhStarling.SymbolManager;
	import com.lachhhStarling.berzerk.BerzerkStarlingManager;

	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * @author LachhhSSD
	 */
	public class ViewDebugModelFla extends ViewBase {
		public var modelFla:ModelFla;
		public var visualFlash:MovieClip ;
		public function ViewDebugModelFla(pScreen : Actor, pParent: MovieClip) {
			super(pScreen, SymbolManager.getEmptyMovieClip());
			visualFlash = new DEBUG_TXT();
			pParent.addChild(visualFlash);
		}

		override public function refresh() : void {
			super.refresh();
			if(modelFla == null) return;
			var isLoaded:Boolean = BerzerkStarlingManager.berzerkFlaLoader.isAtlasLoaded(modelFla);
			txt.textColor = (isLoaded ? 0x00FF00 : 0xFF0000);
			txt.text = modelFla.id ; 
		}

		public function get txt() : TextField {return visualFlash.getChildByName("txt") as TextField;}
		
	}
}
