package com.berzerkrpg.ui {
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkrpg.components.TweenEaseOutNumberComponent;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhhStarling.berzerk.BerzerkMouseCollider;

	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author LachhhSSD
	 */
	public class LogicScrollWithTouch extends ActorComponent {
		private var viewScrollBar : ViewScrollBar;
		private var isDragging : Boolean = false;
		private var hasClickedOnArea : Boolean = false;
		private var force : TweenEaseOutNumberComponent ;
		private var contentMc : MovieClip;
		public var touchArea : Rectangle = new Rectangle();
		public var touchAreaOffset : Rectangle = new Rectangle();
		public var isVertical : Boolean = false;
		public var displayObjectTouch : MovieClip;
		private var thresholdToStartScroll : Number = 4;
		private var deltaSinceTouch:Number = 0;
		public var useDoubleWidth:Boolean = false;
		public var touchEnabled:Boolean = true;
		//private var thresholdToStartScroll : Number = 4;

		public function LogicScrollWithTouch(pContentMc : MovieClip, pViewScrollBar : ViewScrollBar) {
			super();
			contentMc = pContentMc;
			viewScrollBar = pViewScrollBar;
			force = new TweenEaseOutNumberComponent();
			force.gotoValue = 0;
			force.minimumStep = 0;
			force.ease = 0.1;
			force.thresholdCallback = 0.001;
			displayObjectTouch = ExternalAPIManager.berzerkAnimationManager.createEmpty();
		}

		override public function start() : void {
			super.start();
			actor.addComponent(force);
			contentMc.parent.addChild(displayObjectTouch);
			//displayObjectTouch.x = contentMc.x;
			//displayObjectTouch.y = contentMc.y;
			displayObjectTouch.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			//(displayObjectTouch as BerzerkAnimationProxy).animRaw.blockInputOnTouch = true;
			
		}

		private function onMouseDown(event : MouseEvent) : void {
			if(viewScrollBar.canShowScrollbar()){
				var contains:Boolean = BerzerkMouseCollider.isPointWithinAnim(viewScrollBar.scrollTrack, BerzerkMouseCollider.mousePos);
				if(contains) return;
			}
			hasClickedOnArea = true;
		}

		override public function destroy() : void {
			super.destroy();
			displayObjectTouch.removeFromParent();
			ExternalAPIManager.berzerkAnimationManager.destroyAnimation(displayObjectTouch);
		}

		override public function update() : void {
			super.update();
			
			if(!viewScrollBar.isScrollable()){
				stopDragging();
				return;
			}
			
			refreshTouchArea();
			updateIsDragging();
			updateMovement();
		}
		
		private function updateIsDragging():void {
			if(hasClickedOnArea) {
				if(!KeyManager.IsMouseDown()) {
					stopDragging();
				}
			}
		}
		
		private function stopDragging():void {
			hasClickedOnArea = false;
			isDragging = false;
			BerzerkMouseCollider.blockInput = false;
			deltaSinceTouch = 0;
		}
		
		private function updateMovement():void {
			
			if(hasClickedOnArea && !isDragging) {
				updateMovementWhenFingerDown();
			} else if(isDragging){
				updateMovementWhenFingerMoveEnough();
			} else {
				updateMovementWhenFingerUp();
			}	
		}
		
		private function updateMovementWhenFingerDown():void {
			
			var dx:Number = isVertical ? KeyManager.GetMouseMove().y : KeyManager.GetMouseMove().x;
			deltaSinceTouch += dx;
			if(Math.abs(deltaSinceTouch) > thresholdToStartScroll) {
				isDragging = true;
				moveContent(deltaSinceTouch);
				BerzerkMouseCollider.blockInput = true;
			}
		}
		
		private function updateMovementWhenFingerMoveEnough():void {
			var dx:Number = isVertical ? KeyManager.GetMouseMove().y : KeyManager.GetMouseMove().x;
			moveContent(dx);
		}
		
		private function updateMovementWhenFingerUp():void {
			var contentWidth:int = viewScrollBar.contentWidth-viewScrollBar.viewWidth;
			viewScrollBar.addPrct(force.value/contentWidth);
		}
		
		private function moveContent(dx:Number):void {
			var contentWidth:int = viewScrollBar.contentWidth-viewScrollBar.viewWidth;
			var prctDelta:Number = dx/contentWidth;
			viewScrollBar.addPrct(-prctDelta);
		
			force.value = -dx;
		}
		
		private function refreshTouchArea():void {
			if(isVertical) {
				touchArea.x = contentMc.x;
				touchArea.y = 0;
				touchArea.width = viewScrollBar.visual.x-contentMc.x;
				touchArea.height = viewScrollBar.viewWidth+20;
				if(useDoubleWidth) touchArea.height *= 2;
			} else {
				touchArea.x = 0;
				touchArea.y = contentMc.y;
				touchArea.width = viewScrollBar.viewWidth+20;
				if(useDoubleWidth) touchArea.width *= 2;
				touchArea.height = viewScrollBar.visual.y-contentMc.y;
			} 
			
			if(touchEnabled){
				displayObjectTouch.hitArea.x = touchArea.x+touchAreaOffset.x;
				displayObjectTouch.hitArea.y = touchArea.y+touchAreaOffset.y;
				displayObjectTouch.hitArea.width = touchArea.width+touchAreaOffset.width;
				displayObjectTouch.hitArea.height = touchArea.height+touchAreaOffset.height;
			} else {
				displayObjectTouch.hitArea.x = 0;
				displayObjectTouch.hitArea.y = 0;
				displayObjectTouch.hitArea.width = 0;
				displayObjectTouch.hitArea.height = 0;
			}
		}
	}
}
