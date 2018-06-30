package com.lachhh.lachhhengine.ui.views {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.actor.Actor;

	import flash.events.MouseEvent;


	/**
	 * @author LachhhSSD
	 */
	public class ViewGroupBase extends ViewBase {
		public var views:Array = new Array();
		public var viewSelected:ViewBase;
		public function ViewGroupBase(pScreen : Actor, pVisual : DisplayObject) {
			super(pScreen, pVisual);
		}
		
		public function selectFirst():void {
			if(views.length <= 0) return ;
			selectView(views[0] as ViewBase); 
		}
		
		public function addView(v:ViewBase):void {
			screen.registerClickWithCallback(v.visual, new Callback(onClickView, this, [v]));
			screen.registerEventWithCallback(v.visual, MouseEvent.MOUSE_OVER, new Callback(onRollOverView, this, [v]));
			views.push(v);
		}

		public function onRollOverView(v:ViewBase) : void {
			
		}

		public function onClickView(v:ViewBase) : void {
			selectView(v);	
		}
		
		public function selectView(v:ViewBase):void {
			viewSelected = v;
		}
		
		public function refreshAllViews():void {
			for (var i : int = 0; i < views.length; i++) {
				var crntView:ViewBase = views[i];
				crntView.refresh();
			}
		}
		
		public function destroyAllViews():void {
			for (var i : int = 0; i < views.length; i++) {
				var crntView:ViewBase = views[i];
				crntView.destroy();
			}
			views = new Array();
		}
		
		public function getViewAt(i:int):ViewBase {
			if(i < 0) return null;
			if(i >= views.length) return null;
			return views[i];
		}
		
		
		public function getViewFromVisual(d:DisplayObject):ViewBase {
			for (var i : int = 0; i < views.length; i++) {
				var crntView:ViewBase = views[i];
				if(crntView.visual == d) return crntView;
			}
			return null;
		}
	}
}
