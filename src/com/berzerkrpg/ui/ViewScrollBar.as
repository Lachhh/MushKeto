package com.berzerkrpg.ui {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.io.Callback;
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.ui.MetaTwitchCmd;
	import com.lachhh.lachhhengine.ui.UIBase;
	import com.lachhh.lachhhengine.ui.views.ViewBase;
	import com.lachhh.utils.Utils;
	import com.lachhhStarling.berzerk.BerzerkMouseCollider;

	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author LachhhSSD
	 */
	public class ViewScrollBar extends ViewBase {
		public var scrollbarWidth:Number = 1280;
		public var contentWidth:Number = 8000;
		public var viewWidth:Number = 1280;
		public var minTrackWidth:Number = 100;
		private var positionPrct:Number = 0;
		public var callbackOnChange:Callback;
		private var isEditing : Boolean ;
		private var isVertical : Boolean;
		public var logicScrollWithTouch : LogicScrollWithTouch;
		public var logicScrollWithWheel : LogicScrollWithWheel;

		public function ViewScrollBar(pScreen : UIBase, pVisual : MovieClip, contentMc : MovieClip) {
			super(pScreen, pVisual);
			pScreen.registerEvent(scrollTrack, MouseEvent.MOUSE_DOWN, onClickScroll);
			pScreen.registerClick(scrollBack, onClickBack);
			pScreen.registerClick(prevMc, onClickPrev);
			pScreen.registerClick(nextMc, onClickNext);

			positionPrct = 0;
			scrollbarWidth = scrollBack.width-20;
			viewWidth = scrollBack.width-20;
			
			//if (!canShowScrollbar()) {
				logicScrollWithTouch = new LogicScrollWithTouch(contentMc, this);
				actor.addComponent(logicScrollWithTouch);
			//}
			
			if(VersionInfo.modelPlatform.isWebOrDesktop()) {
				logicScrollWithWheel = new LogicScrollWithWheel(contentMc, this);
				actor.addComponent(logicScrollWithWheel);
			}
			

		}
		
		public function forceUseScrollWheel():void{
			if(logicScrollWithWheel == null) return;
			logicScrollWithWheel.ignoreMouseInAreaCheck = true;
		}
		
		public function setWheelScrollEnabled(b:Boolean):void{
			if(logicScrollWithWheel == null) return;
			logicScrollWithWheel.enabled = b;
		}
		
		public function setWidthToDouble():void{
			if(logicScrollWithTouch == null) return;
			logicScrollWithTouch.useDoubleWidth = true;
		}
		
		private function onClickPrev() : void {
			setPrct(positionPrct-0.1);
		}

		private function onClickNext() : void {
			setPrct(positionPrct+0.1);
		}

		private function onClickBack() : void {
			if(visual.mouseX < scrollTrack.x) setPrct(positionPrct-0.1);
			if(visual.mouseX > scrollTrack.x+scrollTrack.width) setPrct(positionPrct+0.1);
			refresh();
		}

		private function onClickScroll() : void {
			scrollTrack.startDrag(false, new Rectangle(0, 0, scrollWidthMinusTrackWidth(), 0));
			isEditing = true;
			BerzerkMouseCollider.blockInput = true;
		}

		override public function refresh() : void {
			super.refresh();
			if(isScrollable()) {
				visual.visible = canShowScrollbar();
				refreshWidth();
				refreshPosition();
			} else {
				visual.visible = false;
				positionPrct = 0;
			}
		}
		
		public function canShowScrollbar():Boolean {
			if(VersionInfo.modelPlatform.isMobile()) return false;
			return true;
		}
		
		private function refreshWidth():void {
			middle.width = (scrollTrackWidth()-10);
			middle.x = 4;
			edgeRight.x = middle.width+7; 
			scrollTrack.hitArea.width = scrollTrackWidth();
		}
		
		private function refreshPosition():void {
			var x:int = scrollWidthMinusTrackWidth()*positionPrct;
			scrollTrack.x = x;
		}
		
		private function isMouseOverScrolltrack():Boolean{
			return BerzerkMouseCollider.isPointWithinAnim(scrollTrack, BerzerkMouseCollider.mousePos);
		}
		
		override public function update() : void {
			super.update();
			if(isMouseOverScrolltrack() && KeyManager.IsMouseDown() && !isEditing){
				onClickScroll();
			}
			if(isEditing) {
				if(!KeyManager.IsMouseDown()) {
					isEditing = false;
					scrollTrack.endDrag();
					BerzerkMouseCollider.blockInput = false;
				}
				setPrctFromX(scrollTrack.x);
				refresh();
			}
		}
		
		public function getPrctPostion():Number {
			return positionPrct;
		}
		
		protected function setPrctFromX(x:int):void {
			setPrct(x/scrollWidthMinusTrackWidth());
		}
		
		public function addPrct(prct:Number):void {
			if(prct == 0) return ;
			setPrct(positionPrct + prct);
		}
		
		public function setPrct(prct:Number):void {
			if(prct == positionPrct) return ;
			positionPrct = Utils.minMax(prct, 0, 1);
			if(callbackOnChange) callbackOnChange.call();
		}
		
		public function scrollTrackWidth():Number {
			var widthOfScrollBar:Number = getPrctView()*scrollbarWidth;
			if(widthOfScrollBar < minTrackWidth) widthOfScrollBar = minTrackWidth;
			return widthOfScrollBar;
		}
		
		public function scrollWidthMinusTrackWidth():Number {
			return scrollbarWidth-scrollTrackWidth();
		}
		
		public function isViewLargerThanScroll():Boolean {
			return (viewWidth > contentWidth);
		}
		
		public function isScrollable():Boolean {
			if(isViewLargerThanScroll()) return false;
			if(contentWidth == 0) return false;
			return true;
		}
		
		public function getPrctView():Number {
			return (viewWidth / contentWidth);
		}
		
		public function isDragging():Boolean{
			return isEditing;
		}
				
		public function get scrollTrack() : MovieClip { return visualMc.getChildByName("scrollTrack") as MovieClip;}
		public function get scrollBack() : DisplayObject { return visualMc.getChildByName("scrollBack") as DisplayObject;}
		
		public function get prevMc() : MovieClip { return visualMc.getChildByName("prevMc") as MovieClip;}
		public function get nextMc() : MovieClip { return visualMc.getChildByName("nextMc") as MovieClip;}
		
		public function get middle() : DisplayObject { return trackMc.getChildByName("middle") as DisplayObject;}
		public function get edgeRight() : DisplayObject { return trackMc.getChildByName("edgeRight") as DisplayObject;}
		public function get edgeLeft() : DisplayObject { return trackMc.getChildByName("edgeLeft") as DisplayObject;}
		
		public function get trackMc() : MovieClip {
			return scrollTrack.getChildByName("trackMc") as MovieClip;
		}

		public function setIsVertical(value : Boolean) : void {
			isVertical = value;
			if(logicScrollWithTouch) {
				logicScrollWithTouch.isVertical = value;
			}
		}
		
	}
}
