package com.lachhhStarling.berzerk {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.lachhh.io.Callback;

	import flash.events.MouseEvent;
	/**
	 * @author LachhhSSD
	 */
	public class MetaBerzerkCollider {
		static private var mouseOverEventArray:Array = [new MouseEvent(MouseEvent.ROLL_OVER)];
		static private var mouseOutEventArray:Array = [new MouseEvent(MouseEvent.ROLL_OUT)];
		static private var mouseUpEventArray:Array = [new MouseEvent(MouseEvent.MOUSE_UP)];
		static private var mouseDownEventArray:Array = [new MouseEvent(MouseEvent.MOUSE_DOWN)];
		
		public var displayObj:DisplayObject;
		public var isMouseOver:Boolean = false;
		public function MetaBerzerkCollider(d:DisplayObject) {
			displayObj = d;
		}
		
		
		public function setMouseOver(b:Boolean):void {
			if(isMouseOver && !b) {
				callEvents(displayObj.GetAllMouseOutEvent() , mouseOutEventArray);
			} else if(!isMouseOver && b) {
				callEvents(displayObj.GetAllMouseOverEvent() , mouseOverEventArray);
			}
			
			isMouseOver = b;
		}
		
		public function setTouched():void {
			callEvents(displayObj.GetAllMouseDownEvent() , mouseDownEventArray);
		}
		
		public function setTouchEnded():void {
			callEvents(displayObj.GetAllMouseUpEvent() , mouseUpEventArray);
		}
		
		
		private function callEvents(a:Array, params:Array):void {
			for (var i : int = 0; i < a.length; i++) {
				var c:Callback = a[i];
				if(c) c.callWithParams(params);
			}
		}

		public static function GetColliderListener(d : DisplayObject) : MetaBerzerkCollider {
			if(d.metaCollider != null) return d.metaCollider;
			d.metaCollider = new MetaBerzerkCollider(d);
			return d.metaCollider;
		}
	}
}
