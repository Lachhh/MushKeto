package com.berzerkrpg.ui {
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.components.TweenEaseOutNumberComponent;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhhStarling.berzerk.BerzerkMouseCollider;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author LachhhSSD
	 */
	public class LogicScrollWithWheel extends ActorComponent {
		private var viewScrollBar : ViewScrollBar;
		private var force : TweenEaseOutNumberComponent ;
		private var contentMc : MovieClip;
		public var touchAreaOffset : Rectangle = new Rectangle();
		public var isVertical : Boolean = false;
		public var displayObjectTouch : MovieClip;
		public var ignoreMouseInAreaCheck:Boolean = false;
		
		public var useDoubleWidth:Boolean = false;
		public var touchEnabled:Boolean = true;
		public var deltaWheel : int = 0;
		private var mySprite : Sprite;

		// private var thresholdToStartScroll : Number = 4;
		public function LogicScrollWithWheel(pContentMc : MovieClip, pViewScrollBar : ViewScrollBar) {
			super();
			contentMc = pContentMc;
			viewScrollBar = pViewScrollBar;
			force = new TweenEaseOutNumberComponent();
			force.gotoValue = 0;
			force.minimumStep = 0;
			force.ease = 0.1;
			force.thresholdCallback = 0.001;
			displayObjectTouch = ExternalAPIManager.berzerkAnimationManager.createEmpty();
			deltaWheel = 0;
		}

		override public function start() : void {
			super.start();
			actor.addComponent(force);
			contentMc.parent.addChild(displayObjectTouch);
			
			MainGame.instance.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 100, true);
			
		}

		private function onMouseWheel(event : MouseEvent) : void {
			if(!enabled) return;
			if(!BerzerkMouseCollider.isPointWithinAnim(displayObjectTouch, BerzerkMouseCollider.mousePos) && !ignoreMouseInAreaCheck) return;
			deltaWheel = event.delta * 5;
			moveContent(deltaWheel);
		}

		override public function destroy() : void {
			super.destroy();
			displayObjectTouch.removeFromParent();
			ExternalAPIManager.berzerkAnimationManager.destroyAnimation(displayObjectTouch);
			
			MainGame.instance.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false);
		}

		override public function update() : void {
			super.update();
			
			if (!viewScrollBar.isScrollable()) return;
			updateListeningArea();
			updateMovement();
		}

		private function updateListeningArea() : void {
			if(viewScrollBar.logicScrollWithTouch == null) return;
			displayObjectTouch.hitArea.x = viewScrollBar.logicScrollWithTouch.touchArea.x+viewScrollBar.logicScrollWithTouch.touchAreaOffset.x;
			displayObjectTouch.hitArea.y = viewScrollBar.logicScrollWithTouch.touchArea.y+viewScrollBar.logicScrollWithTouch.touchAreaOffset.y;
			displayObjectTouch.hitArea.width = viewScrollBar.logicScrollWithTouch.touchArea.width+viewScrollBar.logicScrollWithTouch.touchAreaOffset.width;
			displayObjectTouch.hitArea.height = viewScrollBar.logicScrollWithTouch.touchArea.height+viewScrollBar.logicScrollWithTouch.touchAreaOffset.height;
		}
				
		private function updateMovement():void {
			updateMovementWhenFingerUp();
		}
		
		private function updateMovementWhenFingerUp():void {
			viewScrollBar.addPrct(force.value);
		}
		
		private function moveContent(dx:Number):void {
			var contentWidth:int = viewScrollBar.contentWidth-viewScrollBar.viewWidth;
			var prctDelta:Number = dx/contentWidth;
			viewScrollBar.addPrct(-prctDelta);
			
			var newValue:Number = -prctDelta;
			if(newValue < 0) {
				force.value = Math.min(force.value*0.95, newValue);
			} else {
				force.value = Math.max(force.value*0.95, newValue);
			}
		}
		
		
	}
}
