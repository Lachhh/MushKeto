package com.lachhh.lachhhengine.ui {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.lachhh.io.Callback;

	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * @author LachhhSSD
	 */
	public class MetaCallbackOnClickUI {
		static public var callbackOnClickForAllInstance:Callback ;
		public var callback:Callback ;
		public var visual:DisplayObject;
		public var isEnabled : Boolean;
		public var eventType : String;
	
		public function MetaCallbackOnClickUI(pVisual : DisplayObject, pEventType:String, pCallback : Callback) {
			if(pVisual == null) throw new Error("Visual is null");
			visual = pVisual;
			callback = pCallback;
			eventType = pEventType;
			register();
		}
		
		public function enable(b:Boolean):void {
			if(b) {
				register();
			} else {
				unregister();
			}
		}
		
		public function register():void {
			if(isEnabled) return ;
			if(eventType != MouseEvent.MOUSE_OVER) visual.addEventListener(eventType, onEvent);
			isEnabled = true;
		}
		
		public function unregister():void {
			if(!isEnabled) return ;
			visual.removeEventListener(eventType, onEvent);
			isEnabled = false;
		}
		
		public function call():void {
			callback.call();
			if(eventType == MouseEvent.MOUSE_DOWN) {
				if(callbackOnClickForAllInstance) callbackOnClickForAllInstance.call();
			}
		}
		
		private function onEvent(e:Event):void {
			call();
		}
	}

}
