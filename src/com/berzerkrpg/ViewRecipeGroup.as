package com.berzerkrpg {
	import com.berzerkrpg.meta.MetaRecipe;
	import com.berzerkrpg.meta.MetaRecipeGroup;
	import com.berzerkrpg.ui.ViewRecipeDynamic;
	import com.berzerkrpg.ui.ViewScrollBar;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.ui.UIBase;
	import com.lachhh.lachhhengine.ui.views.ViewBase;
	import com.lachhh.lachhhengine.ui.views.ViewGroupBase;
	import com.lachhh.utils.Utils;

	import flash.geom.Rectangle;

	/**
	 * @author Lachhh
	 */
	public class ViewRecipeGroup extends ViewGroupBase {		
		private static const DIST_BETWEEN_VIEW : int = 50;
		public var viewScrollBar : ViewScrollBar;
		public var metaRecipeGroup:MetaRecipeGroup;
		
		public function ViewRecipeGroup(pScreen : UIBase, pVisual : MovieClip) {
			super(pScreen, pVisual);
			viewScrollBar = new ViewScrollBar(pScreen, scrollbarMc, contentMc);
			viewScrollBar.callbackOnChange = new Callback(refreshPos, this, null);
			viewScrollBar.setIsVertical(true);
			contentMc.maskRect = new Rectangle(0, 0, 960, 360);
			
			refreshPos();
		}
		
		override public function destroy() : void {
			super.destroy();
			destroyAllViews();
		}
		
		override public function destroyAllViews():void {
			for (var i : int = 0; i < views.length; i++) {
				var crntView:ViewBase = views[i];
				crntView.destroyAndRemoveFromActor();
			}
			views = new Array();
		}
		
		public function refreshPos():void {
			viewScrollBar.contentWidth = getContentWidth();
			contentMc.y = -(getContentWidth()-viewScrollBar.viewWidth)*viewScrollBar.getPrctPostion();
			viewScrollBar.refresh();
			hideViewIfOutsideOfSight();
			
		}
		
		private function hideViewIfOutsideOfSight():void {
			for (var i : int = 0; i < views.length; i++) {
				var v:ViewBase = views[i];
				var isInSightxMin:Number = (-contentMc.y-DIST_BETWEEN_VIEW);
				var isInSightxMax:Number = isInSightxMin + 720;
				
				var isInSight:Boolean = Utils.isBetweenOrEqual(v.visual.y, isInSightxMin, isInSightxMax);
				
				v.visual.visible = isInSight;
			}
			//trace(visualMc.y);
		}
		
		private function getContentWidth():int {
			var result:int = 0;
			for (var i : int = 0; i < views.length; i++) {
				result += DIST_BETWEEN_VIEW;
			}
			return result;
		}
				
		override public function refresh() : void {
			super.refresh();
			recreateAllViews();
			refreshPos();
		}

		override public function addView(v : ViewBase) : void {
			views.push(v);
		}

		private function recreateAllViews() : void {
			destroyAllViews();
			if(metaRecipeGroup == null) return ;
			
			var y:int = 0;
			for (var i : int = 0; i < metaRecipeGroup.listRecipes.length; i++) {
				var metaRecipe : MetaRecipe = metaRecipeGroup.listRecipes[i];
				var newView : ViewRecipeDynamic = new ViewRecipeDynamic(screen, contentMc);
				
				newView.visual.y = y;
				y += DIST_BETWEEN_VIEW;
				newView.metaRecipe = metaRecipe;
				newView.refresh();
				
				addView(newView);
			}
		}
		
		
		public function get scrollbarMc() : MovieClip { return visualMc.getChildByName("vScrollMc") as MovieClip;}
		public function get contentMc() : MovieClip { return visualMc.getChildByName("contentMc") as MovieClip;}
	}
}