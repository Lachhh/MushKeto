package com.berzerkrpg.debug {
	import starling.events.Touch;

	import com.berzerkstudio.flash.display.DisplayObject;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.utils.Utils;
	import com.lachhhStarling.berzerk.BerzerkMouseCollider;

	/**
	 * @author Lachhh
	 */
	public class LogicPinchZoom_NOTWORKINGYET extends ActorComponent {
		private var isPinching:Boolean = false;
		private var newPinchPoint : PinchPoint = new PinchPoint();
		private var pinchPoint : PinchPoint = new PinchPoint();
		private var startPinchPoint : PinchPoint = new PinchPoint();
		public var scaleMin : Number = 0;
		public var scaleMax : Number = 0;
		private var startScale:Number = 1;
		private var touchDown : Vector.<Touch>;
		private var t1 : Touch;
		private var t2 : Touch;
		
		private var visual : DisplayObject;
		public function LogicPinchZoom_NOTWORKINGYET(pVisual:DisplayObject) {
			super();
			visual = pVisual;
		}

		override public function update() : void {
			super.update();
			touchDown = BerzerkMouseCollider.lastTouchesHover;
			
			if(touchDown.length < 2) {
				isPinching = false;
			} else {
				if(!isPinching) {
					startPinch();
				} else {
					updatePinch();
				}
			}
		}

		private function updatePinch() : void {
			var newT1 : Touch = getTouch(t1.id);
			var newT2 : Touch = getTouch(t2.id);
			
			if(newT1 == null) return ;
			if(newT2 == null) return ;

			newPinchPoint.calculate(newT1, newT2);
			move(newPinchPoint.pivot.x-pinchPoint.pivot.x, newPinchPoint.pivot.y-pinchPoint.pivot.y);
			var newScale:Number = startScale*(newPinchPoint.radius/startPinchPoint.radius);
			
			newScale = Utils.minMax(newScale, scaleMin, scaleMax);
			var dScale:Number = newScale/visual.scaleX; 
			scale(newScale);
			
			var dx:Number = newPinchPoint.pivot.x-visual.x;
			var dy:Number = newPinchPoint.pivot.y-visual.y;
			
			dx *= dScale;
			dy *= dScale;
			
			move(-dx, -dy);
			
			pinchPoint.calculate(newT1, newT2);
		}

		private function getTouch(id : int) : Touch {
			for (var i : int = 0; i < BerzerkMouseCollider.lastTouchesHover.length; i++) {
				var t:Touch = BerzerkMouseCollider.lastTouchesHover[i];
				if(t.id == id) return t;
			}
			return null;
		}
		
		private function move(x:int, y:int):void {
			visual.x += x;
			visual.y += y;
		}
		
		private function scale(scale:Number):void {
			visual.scaleX = scale;
			visual.scaleY = scale;
		}

		private function startPinch() : void {
			isPinching = true;
			//pinchPoint.scale = visual.scaleX;
			t1 = touchDown[0];
			t2 = touchDown[1];
			
			startPinchPoint.calculate(touchDown[0], touchDown[1]);
			pinchPoint.calculate(touchDown[0], touchDown[1]);
			startScale = visual.scaleX;
		}
	
	}
}