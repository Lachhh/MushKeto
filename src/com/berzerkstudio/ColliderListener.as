package com.berzerkstudio {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.actor.Actor;

	import flash.events.MouseEvent;
	import flash.geom.Transform;
	class ColliderListener  {
		static private var _firstActiveCollider:ColliderListener = null;
		//static private var _dict:Hashtable = new Hashtable();
		
		public var displayObj:DisplayObject;
		public var nextCollider:ColliderListener;
		//public var boxCollider:BoxCollider;
		public var go:Actor;
		public var goTransform:Transform;
		
		public var notUsed:Boolean = false;
		private var _wasOver:Boolean = false;
		private var _wasDown:Boolean = false;
			
		function OnMouseDown() {
			if(_wasDown) return ;
			//DoCallback(displayObj.GetAllMouseDownEvent());
			_wasDown = true;
		}
		
		function OnMouseUp() {
			if(!_wasDown) return ;
			//DoCallback(displayObj.GetAllMouseUpEvent());
			_wasDown = false;
		}
		
		function OnMouseOver() {
			if(_wasOver) return ;
			//DoCallback(displayObj.GetAllMouseOverEvent());
			_wasOver = true;
		}
		
		function OnMouseExit() {
			//DoCallback(displayObj.GetAllMouseOutEvent());
			_wasOver = false;
			_wasDown = false;
		}
		
		function OnTouchDown():void {
			if(_wasDown) return ;
			//DoCallback(displayObj.GetAllMouseDownEvent());
			_wasDown = true;
		}
		
		function OnTouchUp():void {
			if(!_wasDown) return ;
			//DoCallback(displayObj.GetAllMouseUpEvent());
			_wasDown = false;
		}
		
		function DoCallback(theArray:Array):void {
			for(var i:int = 0 ; i < theArray.length ; i++) {
				var c:Callback = theArray[i];
				//var e:MouseEvent = new MouseEvent();
				/*e.target = displayObj;
				e.currentTarget = displayObj;
				c.DoCallbackWithParams([e]);*/
			}
		}
		
		static public function GetColliderListener(d:DisplayObject):ColliderListener {
			return null;
		}
		
		static public function CacheAll():void {
			var crnt:ColliderListener = _firstActiveCollider;
			var prev:ColliderListener = null;
	
			
			while(crnt != null) {
				
				if(crnt.notUsed) {
					if(prev != null) {
						prev.nextCollider = crnt.nextCollider;
					}
					
					if(crnt == _firstActiveCollider) {
						_firstActiveCollider = crnt.nextCollider;
					}
					
					crnt.nextCollider = null;
					//crnt.displayObj.colListener = null;
					//_dict.Remove(crnt.displayObj);
					//Destroy(crnt.go);
				} else {
					crnt.notUsed = true;
				}
				prev = crnt;
				crnt = crnt.nextCollider;
			}
		}
	}
}