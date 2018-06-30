package com.berzerkstudio.flash.display {
	import com.berzerkstudio.MetaCachedGO;
	import com.berzerkstudio.ModelFla;
	import com.berzerkstudio.flash.geom.ColorTransform;
	import com.berzerkstudio.flash.geom.Transform2D;
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.lachhh.io.Callback;
	import com.lachhh.io.KeyManager;
	import com.lachhh.utils.Utils;
	import com.lachhhStarling.berzerk.MetaBerzerkCollider;

	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	public class DisplayObject {
		private var _metaDisplayObject:MetaDisplayObject;
		public var classId:int;
		public var className:String;
		public var modelFla:ModelFla;
		public var parent:DisplayObjectContainer = null ;
		//public var finalMatrix:Matrix4x4;
		public var name:String = "instance";
		public var transform:Transform2D ;
		
		public var nextSibling : DisplayObject ;
		public var prevSibling : DisplayObject ;
		public var isInternal : Boolean = false; // Costruit auto par l'ordi ou non
		public var toBeRemovedInternal:Boolean = false; 
		public var visible:Boolean = true; 
		
		public var mouseEnabled:Boolean = true;
		public var mouseChildren:Boolean = true;
		public var buttonMode:Boolean = false;
		public var useHandCursor : Boolean = false;
		public var mouseX : Number;
		public var mouseY : Number;
		public var childIndex:int;
		
		public var tempNext:DisplayObject;
		
		public var metaGo:MetaCachedGO = null;
		public var metaCollider:MetaBerzerkCollider;
		
		public var hitArea:Rectangle = new Rectangle();
		
		public var hasMouseEvent:Boolean = false;
		public var blockInputOnTouch:Boolean = false;
		public var isCached:Boolean = false;
		
		
		public var endTextFieldBatchBeforeRendering : Boolean = false ;
		
		private var _callbackEvents : Dictionary = new Dictionary();
		
		private var _isBeingDragged:Boolean = false;
		private var _dragConstrantRect : Rectangle;
		private var _deltaDrag : Point = new Point();
		static private var _draggedDisplayObject : Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		public var maskRect:Rectangle;
		public var stopMask:Boolean = false;

		public function DisplayObject() {
			transform = new Transform2D();
		}
		
		public function onEnterFrame():void
		{
			
		}
		
		/*protected function onAdded():void {
			
		}
		
		protected function onRemoved():void {
			
		}*/
		
		public function onDraw():void {
			
		}
		
		
		public function LoadFromMeta(m:MetaDisplayObject):void {
			for (var index : String in _callbackEvents) {
				var child:Array = _callbackEvents[index] as Array;
				Utils.ClearArray(child);
			}
			
			prevSibling = null;
			nextSibling = null;
			hitArea.x = 0;
			hitArea.y = 0;
			hitArea.width = 0;
			hitArea.height = 0;
			
			//startTextFieldBatch = false;
			endTextFieldBatchBeforeRendering = false;
			hasMouseEvent = false;
			visible = true;
			mouseEnabled = true;
			mouseChildren = true;
			buttonMode = false;
			useHandCursor = false;
			mouseX = 0;
			mouseY = 0;
			childIndex = 0;
			tempNext = null ;
			metaGo = null;
			parent = null;
			blockInputOnTouch = false;
			name = m.name;
			classId = m.theClassId;
			className = m.theClassName;
			modelFla = m.modelFla;
			transform.LoadFromTransform(m.transform);
			_metaDisplayObject = m;
			maskRect = null;
			stopMask = false;
			
			isInternal = false; 
			toBeRemovedInternal = false; 
			
			
		}
		
		public function getBounds(mc:DisplayObject):Rectangle {
			return null;
		}
		
		public function addEventListener(e:String, fct:Function):void {
			var c:Callback = new Callback(fct, this, null);
			var theArray:Array = GetEventCallbackArray(e) ;
			if(theArray != null) {
				theArray.push(c);
			}		
			hasMouseEvent = CheckIfHasMouseEvent();
		}
		
		
		public function removeEventListener(e:String, fct:Function):void {
			var theArray:Array = GetEventCallbackArray(e) ;
			if(theArray != null) {
				var c:Callback;
				for(var i:int ; i < theArray.length ; i++) {
					c = theArray[i];
					if(c.fct == fct) {
						theArray.splice(i, 1);
						return;
					}
				}
			}	
			hasMouseEvent = CheckIfHasMouseEvent();
		}

		
		public function CheckIfHasMouseEvent():Boolean {
			if(!mouseEnabled) return false;
			if(hasEvent(MouseEvent.MOUSE_DOWN)) return true;
			if(hasEvent(MouseEvent.ROLL_OVER)) return true;
			if(hasEvent(MouseEvent.ROLL_OUT)) return true;
			if(hasEvent(MouseEvent.MOUSE_UP)) return true;
			return false;
		}
		
		public function hasEvent(eventType:String):Boolean {
			if(_callbackEvents[eventType] == null) return false;
			if((_callbackEvents[eventType] as Array).length <= 0) return false;
			return true;
		}
		
		public function updateDrag():void{
			if(!_isBeingDragged) return;
			
			if(_dragConstrantRect){
				var dx:Number = KeyManager.GetMousePos().x - (transform.concatenedMatrix2D.tx+_deltaDrag.x);
				var dy:Number = KeyManager.GetMousePos().y - (transform.concatenedMatrix2D.ty+_deltaDrag.y);
				var newX:Number = x + dx;
				var newY:Number = y + dy;
				if(parent && parent.rotation == 90) {
					newX = x + dy;
					newY = x + dx;
				}
				
				_dragConstrantRect.topLeft.setTo(this.parent.x, this.parent.y);
				x = Utils.minMax(newX, _dragConstrantRect.left, _dragConstrantRect.right);
				y = Utils.minMax(newY, _dragConstrantRect.top, _dragConstrantRect.bottom);
				
			} else {
				x = _deltaDrag.x;
				y = _deltaDrag.y;
			}
		}
		
		public function startDrag(lockCenter:Boolean, constraintBounds:Rectangle):void{
			_draggedDisplayObject.push(this);
			_isBeingDragged = true;
			_dragConstrantRect = constraintBounds;
			if(lockCenter){
				throw new Error("Not implemented");
			} else {
				_deltaDrag.x = KeyManager.GetMousePos().x-transform.concatenedMatrix2D.tx;
				_deltaDrag.y = KeyManager.GetMousePos().y-transform.concatenedMatrix2D.ty;
			}
			
		}
		
		public function endDrag():void{
			_isBeingDragged = false;
			var i:int = _draggedDisplayObject.indexOf(this);
			_draggedDisplayObject.splice(i, 1);
		}
		
		//public function set metaDisplayObject(value:MetaDisplayObject):void{_metaDisplayObject =value;}
		public function get metaDisplayObject():MetaDisplayObject{return _metaDisplayObject ;}
		
		
		public function set alpha(value:Number):void{ transform.colorTransform.color.alphaMultiplier = value;}
		public function get alpha():Number{return transform.colorTransform.color.alphaMultiplier ;}
		
		public function set x(value:Number):void{transform.x = value;}
		public function get x():Number{return transform.x ;}
		
		public function set y(value:Number):void{transform.y = value;}
		public function get y():Number{return transform.y ;}
		
		public function set scaleX(value:Number):void{transform.scaleX = value;}
		public function get scaleX():Number{return transform.scaleX ;}
		
		public function set scaleY(value:Number):void{transform.scaleY = value;}
		public function get scaleY():Number{return transform.scaleY ;}
		
		public function set rotation(value:Number):void{transform.rotation = value;}
		public function get rotation():Number{return transform.rotation ;}
		
		public function set width(value:Number):void{}
		public function get width():Number{return 0 ;}
		
		public function set height(value:Number):void{}
		public function get height():Number{return 0 ;}
		
		public function get regX():Number{return 0 ;}
		public function get regY():Number{return 0 ;}
				
		public function GetEventCallbackArray(id:String):Array {
			if(id == "") return null;
			if(_callbackEvents[id] == null) _callbackEvents[id] = new Array();
			return _callbackEvents[id];
		}
		
		public function GetAllMouseDownEvent():Array {
			return GetEventCallbackArray(MouseEvent.MOUSE_DOWN);
		}
		
		public function GetAllMouseUpEvent():Array {
			return GetEventCallbackArray(MouseEvent.MOUSE_UP);
		}
		
		public function GetAllMouseOverEvent():Array {
			return GetEventCallbackArray(MouseEvent.ROLL_OVER);
		}
		
		public function GetAllMouseOutEvent():Array {
			return GetEventCallbackArray(MouseEvent.ROLL_OUT);
		}
			
		public function localToGlobal(p:Point):Point {
			return p;
		}	
		
		public function get stage():Stage {
			var crntParent:DisplayObjectContainer = parent;
			while(crntParent != null && !(crntParent as Stage)) {
				crntParent = crntParent.parent;
			}
			return crntParent as Stage;
		}
		
		public function get isShape() : Boolean {
			return false ;
		}
		
		public function get isBitmap():Boolean {
			return false;
		}

		public function get isTextfield() : Boolean {
			return false ;
		}
		
		public static function anyObjectsBeingDragged():Boolean{;
			return _draggedDisplayObject.length > 0;
		}
		
		public static function updateDraggedObject() : void {
			for (var i : int = 0; i < _draggedDisplayObject.length; i++) {
				var d:DisplayObject = _draggedDisplayObject[i];
				d.updateDrag();
			}
		}

		public function removeFromParent() : void {
			if(parent == null) return;
			parent.removeChild(this);
		}
		
		public function getPosOnScreen(output : Point) : Point {
			output.x = transform.concatenedMatrix2D.tx;
			output.y = transform.concatenedMatrix2D.ty;
			return output;
		}
		
		
		public function setColorAnimViewAdvanced(r : Number, g : Number, b : Number, a : Number, rm : Number, gm : Number, bm : Number, am : Number) : void {
			setColorAnimViewPrct(r, g, b, a);
		}

		public function setColorAnimViewPrct( r : Number, g : Number, b : Number, prct : Number) : void {
			var ct:ColorTransform = transform.colorTransform ;
			ct.color.SetTint(r, g, b, prct);
			transform.colorTransform = ct;
		}

		public function setColorAnimView( color : uint) : void {
			var r:int = (((color >> 16) & 0xFF)+0.0);
			var g:int = (((color >> 8) & 0xFF)+0.0);
			var b:int = (((color >> 0) & 0xFF)+0.0);
			setColorAnimViewPrct(r, g, b, 1);
		}

		public function resetColor() : void {
			setColorAnimViewAdvanced(0, 0, 0, 0, 1, 1, 1, 1);
		}
		
		public function get resolutionX() : Number { return transform.resolutionOffsetX;}
		public function get resolutionY() : Number { return transform.resolutionOffsetY;}
		public function set resolutionX(value:Number):void { transform.resolutionOffsetX = value;}
		public function set resolutionY(value:Number):void { transform.resolutionOffsetY = value;}
		
		public function get resolutionScaleX() : Number {return transform.resolutionOffsetScaleX;}
		public function get resolutionScaleY() : Number {return transform.resolutionOffsetScaleY;}

		public function set resolutionScaleX(value : Number) : void {transform.resolutionOffsetScaleX = value;}
		public function set resolutionScaleY(value : Number) : void {transform.resolutionOffsetScaleY = value; }
	}
}