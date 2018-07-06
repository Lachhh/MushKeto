package com.berzerkrpg {
	import com.berzerkrpg.meta.MetaIngredient;
	import com.berzerkrpg.meta.ModelIngredientCategory;
	import com.berzerkrpg.meta.ModelIngredientCategoryEnum;
	import com.berzerkrpg.ui.ViewIngredientAllDynamic;
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
	public class ViewIngredientAllGroup extends ViewGroupBase {
		private static const DIST_BETWEEN_VIEW : int = 50;
		public var viewScrollBar : ViewScrollBar;
		public var listIngredients : Vector.<MetaIngredient> = new Vector.<MetaIngredient>();
		private var maxViews : Number = 10;

		public function ViewIngredientAllGroup(pScreen : UIBase, pVisual : MovieClip) {
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
			if(viewScrollBar.isViewLargerThanScroll()){
				viewScrollBar.setPrct(0);
			}
			contentMc.y = -(getContentWidth()-viewScrollBar.viewWidth)*viewScrollBar.getPrctPostion();
			viewScrollBar.refresh();
		
			refreshIndexes();
		}

		public function refreshIndexes() : void {
			
			var indexStart:int = (contentMc.y*-1)/DIST_BETWEEN_VIEW;
			for (var i : int = 0; i < views.length; i++) {
				var index:int = indexStart+i;
				var v:ViewIngredientAllDynamic = views[i] as ViewIngredientAllDynamic;
				v.visualMc.y = (indexStart+i)*DIST_BETWEEN_VIEW;
				var newIngredient:MetaIngredient = getIngredientAt(index);
				if(v.metaIngredient == newIngredient) continue; 
				v.metaIngredient = newIngredient;
				v.refresh();
			}
		}
		
		private function getIngredientAt(i:int):MetaIngredient {
			if(i<0) return null;
			if(i >= listIngredients.length) return null;
			return listIngredients[i];
		}

		
		private function getContentWidth():int {
			return listIngredients.length*DIST_BETWEEN_VIEW;
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
			if(listIngredients == null) return ;
			
			var y:int = 0;
			for (var i : int = 0; i < maxViews; i++) {
				var metaIngredient : MetaIngredient = getIngredientAt(i);
				
				var newView : ViewIngredientAllDynamic = new ViewIngredientAllDynamic(screen, contentMc);
				
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