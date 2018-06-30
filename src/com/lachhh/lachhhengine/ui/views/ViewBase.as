package com.lachhh.lachhhengine.ui.views {
	import com.berzerkstudio.flash.display.ButtonSelect;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.lachhhengine.ui.UIBase;

	/**
	 * @author LachhhSSD
	 */
	public class ViewBase extends ActorComponent {
		public var screen:UIBase;
		public var visualRaw:DisplayObject;
		public var visual:DisplayObject;
		public var visualMc:MovieClip;
		public var visualTxt:TextField;
		public var visualBtn:ButtonSelect;
		
		public function ViewBase(pScreen : Actor, pVisual:DisplayObject) {
			super();
			if(pVisual == null) throw new Error("Visual must not be null");
			screen = pScreen as UIBase;
			visualRaw = pVisual;
			visual = visualRaw ;
			visualMc = visualRaw as MovieClip ;
			visualTxt = visualRaw as TextField;
			visualBtn = visualRaw as ButtonSelect ;
			
			pScreen.addComponent(this);
		}
		
	}
}
