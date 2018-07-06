package com.berzerkrpg.ui {
	import com.berzerkrpg.meta.MetaIngredient;
	import com.berzerkrpg.meta.MetaRecipe;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.ui.UIBase;
	import com.lachhh.lachhhengine.ui.views.ViewBase;
	import com.lachhh.lachhhengine.ui.views.ViewGroupBase;
	import com.lachhh.utils.Utils;

	import flash.geom.Rectangle;

	/**
	 * @author mikeducarmesucks
	 */
	public class ViewRecipeIngredientGroup extends ViewGroupBase {
		
		private static const DIST_BETWEEN_VIEW : int = 60;
		public var viewScrollBar : ViewScrollBar;
		public var metaRecipe:MetaRecipe;
		
		public function ViewRecipeIngredientGroup(pScreen : UIBase, pVisual : MovieClip) {
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
				var v:ViewIngredientDynamic = views[i] as ViewIngredientDynamic;
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
			if(metaRecipe == null) return ;
			
			var y:int = 0;
			for (var i : int = 0; i < metaRecipe.metaIngredientsGroup.listIngredients.length; i++) {
				var metaIngredient : MetaIngredient = metaRecipe.metaIngredientsGroup.listIngredients[i];
				var newView : ViewIngredientDynamic = new ViewIngredientDynamic(screen, contentMc);
				
				newView.visual.y = y;
				y += DIST_BETWEEN_VIEW;
				newView.metaIngredient = metaIngredient;
				newView.refresh();
				
				addView(newView);
			}
		}
		
		
		public function get scrollbarMc() : MovieClip { return visualMc.getChildByName("vScrollMc") as MovieClip;}
		public function get contentMc() : MovieClip { return visualMc.getChildByName("contentMc") as MovieClip;}
	}
}
