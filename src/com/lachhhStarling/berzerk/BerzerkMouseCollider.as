package com.lachhhStarling.berzerk {
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.VersionInfo;

	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author LachhhSSD
	 */
	public class BerzerkMouseCollider {
		static private var _tempVecSE : Point = new Point();
		static private var _tempVecNW : Point = new Point();
		
		public var starlingStage:starling.display.DisplayObjectContainer;
		
		static public var lastTouchesDown:Vector.<Touch> = new Vector.<Touch>();
		static public var lastTouchesHover:Vector.<Touch> = new Vector.<Touch>();
		static public var lastTouchesUp:Vector.<Touch> = new Vector.<Touch>();
		
		static private var touchesDown:Vector.<Touch> = new Vector.<Touch>();
		static private var touchesHover:Vector.<Touch> = new Vector.<Touch>();
		static private var touchesUp:Vector.<Touch> = new Vector.<Touch>();
		static public var temp:Vector.<Touch> = new Vector.<Touch>();
		
		static public var tempRect : Rectangle = new Rectangle();
		static public var colliderOnThisFrame : Vector.<MetaBerzerkCollider> = new Vector.<MetaBerzerkCollider>();
		static public var mousePos : Point = new Point();
		static public var mousePosDelta : Point = new Point();
		static public var hasTouchDown:Boolean = false;
		static public var blockInput:Boolean = false;
		
		private var DEBUGTrace : Boolean;

		public function BerzerkMouseCollider() {
			//starlingStage = pStarlingStage;
			starlingStage = Starling.current.stage;
			starlingStage.addEventListener(TouchEvent.TOUCH, onTouch);
			DEBUGTrace = false;
		}

		private function onTouch(e : TouchEvent) : void {
			//var touch:Touch = e.getTouches(StarlingStage.instance, null, touches);
			touchesHover = e.getTouches(starlingStage, TouchPhase.MOVED, touchesHover);
			touchesDown = e.getTouches(starlingStage, TouchPhase.BEGAN, touchesDown);
			touchesHover = e.getTouches(starlingStage, TouchPhase.HOVER, touchesHover);
			touchesUp = e.getTouches(starlingStage, TouchPhase.ENDED, touchesUp);
		}
		
		public function update():void {
			checkForInputs();
			bypassKeyManagerInfo();
			
			while(lastTouchesDown.length > 0) lastTouchesDown.pop();
			while(lastTouchesHover.length > 0) lastTouchesHover.pop();
			while(lastTouchesUp.length > 0) lastTouchesUp.pop();
			
			while(touchesDown.length > 0) lastTouchesDown.push(touchesDown.pop());
			while(touchesHover.length > 0) lastTouchesHover.push(touchesHover.pop());
			while(touchesUp.length > 0) lastTouchesUp.push(touchesUp.pop());
			while(colliderOnThisFrame.length > 0) colliderOnThisFrame.pop();
		}
		
		private static function transformRectToDisplayObject(rect:Rectangle, d:DisplayObject):void{
			var x:Number = 0;
			var y:Number = 0;
			
			var w:Number = 0;
			var h:Number = 0;
			x = d.hitArea.x;
			y = d.hitArea.y;
				
			if(d.hitArea.x == 0) x = -d.regX+d.hitArea.x;
			if(d.hitArea.y == 0) y = -d.regY+d.hitArea.y;
			
			w = d.hitArea.width;
			h = d.hitArea.height;
			
			if(!VersionInfo.modelPlatform.isMobile()) {
				_tempVecNW.x = x;
				_tempVecNW.y = y; 
				
				_tempVecSE.x = x+w;
				_tempVecSE.y = y+h;
				
				_tempVecSE = d.transform.concatenedMatrix2D.transformPoint(_tempVecSE);
				_tempVecNW = d.transform.concatenedMatrix2D.transformPoint(_tempVecNW);
				
				var newW:int = (_tempVecSE.x - _tempVecNW.x);
				var newH:int = (_tempVecSE.y - _tempVecNW.y);
				rect.x = _tempVecNW.x;
				rect.y = _tempVecNW.y;
				rect.width = newW;
				rect.height = newH;
				
			} else {
				_tempVecSE.x = d.transform.concatenedMatrix2D.tx;
				_tempVecSE.y = d.transform.concatenedMatrix2D.ty;
			
				rect.x = d.hitArea.x + _tempVecSE.x;
				rect.y = d.hitArea.y + _tempVecSE.y;
				rect.width = d.hitArea.width;
				rect.height = d.hitArea.height;
				if(d.hitArea.x == 0) rect.x += -d.regX;
				if(d.hitArea.y == 0) rect.y += -d.regY;
			}
			
			if(rect.width < 0) {
				rect.width *= -1;
				rect.x -= rect.width;
			}
			if(rect.height < 0) {
				rect.height *= -1;
				rect.y -= rect.height;
			}
		}
		
		public static function isPointWithinAnim(anim:MovieClip, p:Point):Boolean{
			
			var d:DisplayObject = anim;
			if(d == null) throw new Error("COULD NOT CAST AS DISPLAY OBJECT!");
			transformRectToDisplayObject(tempRect, d);
			return tempRect.containsPoint(p);
		}
		
		private function checkForInputs():void {
			if(hasNoTouches()) return ;
			if(blockInput) return ;
			var d:DisplayObject;
			var x:Number = 0;
			var y:Number = 0;
			
			var w:Number = 0;
			var h:Number = 0;
			var collider:MetaBerzerkCollider;
			
			for (var i : int = colliderOnThisFrame.length-1; i >= 0; i--) {
				collider = colliderOnThisFrame[i];
				d = collider.displayObj;
				x = d.hitArea.x;
				y = d.hitArea.y;
				
				if(d.hitArea.x == 0) x = -d.regX+d.hitArea.x;
				if(d.hitArea.y == 0) y = -d.regY+d.hitArea.y;
			
				w = d.hitArea.width;
				h = d.hitArea.height;
				
				if(!VersionInfo.modelPlatform.isMobile()) {
					_tempVecNW.x = x;
					_tempVecNW.y = y; 
					
					_tempVecSE.x = x+w;
					_tempVecSE.y = y+h;
					
					_tempVecSE = d.transform.concatenedMatrix2D.transformPoint(_tempVecSE);
					_tempVecNW = d.transform.concatenedMatrix2D.transformPoint(_tempVecNW);
					
					var newW:int = (_tempVecSE.x - _tempVecNW.x);
					var newH:int = (_tempVecSE.y - _tempVecNW.y);
					tempRect.x = _tempVecNW.x;
					tempRect.y = _tempVecNW.y;
					tempRect.width = newW;
					tempRect.height = newH;
					
				} else {
					_tempVecSE.x = d.transform.concatenedMatrix2D.tx;
					_tempVecSE.y = d.transform.concatenedMatrix2D.ty;
				
					tempRect.x = d.hitArea.x + _tempVecSE.x;
					tempRect.y = d.hitArea.y + _tempVecSE.y;
					tempRect.width = d.hitArea.width;
					tempRect.height = d.hitArea.height;
					if(d.hitArea.x == 0) tempRect.x += -d.regX;
					if(d.hitArea.y == 0) tempRect.y += -d.regY;
				}
				
				if(tempRect.width < 0) {
					tempRect.width *= -1;
					tempRect.x -= tempRect.width;
				}
				
				if(tempRect.height < 0) {
					tempRect.height *= -1;
					tempRect.y -= tempRect.height;
				}
				
				DEBUGTrace = false;

				if(!VersionInfo.modelPlatform.isMobile() && touchesHover.length > 0) {		
					var isHoveringOnTopOfDisplayObject:Boolean = collideWithTouch(tempRect, touchesHover, d);
					if(isHoveringOnTopOfDisplayObject) {
						collider.setMouseOver(true);
					} else if(isHovering()){
						collider.setMouseOver(false);
					}
				}
				
				if(!blockInput)  {
					var hasTouchedDisplayObject:Boolean = collideWithTouch(tempRect, touchesDown, d);
					if(collider.displayObj.hasEvent(MouseEvent.MOUSE_DOWN) && hasTouchedDisplayObject) {
						collider.setTouched();
						return ;
					}
					
					DEBUGTrace = false;
					var hasReleasedDisplayObject:Boolean = collideWithTouch(tempRect, touchesUp, d);
					if(collider.displayObj.hasEvent(MouseEvent.MOUSE_UP) && hasReleasedDisplayObject) {
						collider.setTouchEnded();
						return ;
					}
				}
			}
		}
		
		public function isInsideOfMask(d:DisplayObject):Boolean {
			var mask:Rectangle = getMask(d);
			if(mask == null) return true;
			
			return true;
		}
		
		public function getMask(d:DisplayObject):Rectangle {
			
			while(d) {
				if(d.maskRect) return d.transform.maskConcatened;
				d = d.parent;
			}
			return null;
		}
		

		public function AddMouseCollider(d : com.berzerkstudio.flash.display.DisplayObject, matrix : Matrix) : void {
			var collider : MetaBerzerkCollider = MetaBerzerkCollider.GetColliderListener(d);
			colliderOnThisFrame.push(collider);
		}
		
		private function bypassKeyManagerInfo():void{
			var t:Touch = getFirstTouch();
			if(t == null){
				mousePosDelta.setTo(0, 0);
			} else {
				mousePos.setTo(t.globalX, t.globalY);
				t.getMovement(starlingStage, mousePosDelta);
			}
			
			if(touchesUp.length > 0) hasTouchDown = false;
			if(touchesDown.length > 0) hasTouchDown = true;
			
			if(VersionInfo.modelPlatform.isMobile()){
				KeyManager.setMouseDown(hasTouchDown);
			}
			KeyManager.setMouseMove(mousePosDelta);
			KeyManager.setMousePos(mousePos);
		}
		
		private function getFirstTouch():Touch {
			if(touchesDown.length > 0) return touchesDown[0];
			if(touchesHover.length > 0) return touchesHover[0];
			return null;
		}
			
		private function isHovering():Boolean {
			return (touchesHover.length > 0);
		}
		
		private function collideWithTouch(rect:Rectangle, touches:Vector.<Touch>, d:DisplayObject):Boolean {
			var t:Touch;
			
			for (var i : int = 0; i < touches.length; i++) {
				t = touches[i];			
				if(rect.contains(t.globalX, t.globalY)) {
					var mask:Rectangle = getMask(d);
					if(mask == null) return true; 
					return mask.contains(t.globalX, t.globalY);
				}
			}
			return false;
		}
		
		private function hasNoTouches():Boolean {
			if(touchesDown.length > 0) return false;
			if(touchesHover.length > 0) return false;
			if(touchesUp.length > 0) return false;
			return true;
		}
	}
}
