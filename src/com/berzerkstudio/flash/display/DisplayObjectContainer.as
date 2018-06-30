package com.berzerkstudio.flash.display {
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	public class DisplayObjectContainer extends DisplayObject {
		public var numChildren:int = 0 ;
		public var numInternalChildren:int = 0 ;
		
		private var _firstChild:DisplayObject ;
		private var _lastChild:DisplayObject ;

		private var _lastInternalToRemove : Vector.<DisplayObject> = null;
		private var _isInternalDirty : Boolean = false;

		public function DisplayObjectContainer() {
			
		}

		override public function LoadFromMeta(m : MetaDisplayObject) : void {
			super.LoadFromMeta(m);
			_lastInternalToRemove = null;
			_isInternalDirty = false;
		}	
		
	    public function addChild(d:DisplayObject):void {
	    	addChildAt(d, numChildren);
	    }
	
	    public function addChildAt(d:DisplayObject, index:int):void {		    	
			/*if(d == this) {
				Debug.LogError("Can't add object to itself");
				return ;
			}	*/
			
			if(d.parent != null) {
				d.parent.removeChild(d);
			}
			
			
			
			if(index >= numChildren) {
				if(numChildren <= 0) {
					_lastChild = d;
					_firstChild = d;
					d.prevSibling = null;
					d.nextSibling = null;
				} else {
					_lastChild.nextSibling = d;
					d.prevSibling = _lastChild;
					_lastChild = d;
				}
				d.childIndex = numChildren;
			} else {
	
				var crntChild:DisplayObject = getChildAt(index);
				
				if(crntChild != _firstChild) {
					crntChild.prevSibling.nextSibling = d;
				} else {
					_firstChild = d;
				}
				
				d.prevSibling = crntChild.prevSibling ;
				d.nextSibling = crntChild;
				crntChild.prevSibling = d;
				d.childIndex = index;
			}
			d.parent = this;
			
			
			numChildren++;
			if(d.isInternal) numInternalChildren++;
			//d.onAdded();
			_isInternalDirty = true;
			/*if(numChildren != debugRealNumChildren) {
				Debug.Log("CACA");
			}*/
	    }
		
		/*public function LoadFromMeta(m:MetaDisplayObject):void {
			//var dc:MetaDisplayObjectContainer = (m as MetaDisplayObjectContainer);
			//_children = new DisplayObject[dc.maxDisplayObjects];
		}*/
		
	    public function removeChild(d:DisplayObject):void {
	        /*if(d == null) {
	            Debug.LogError("child must be non-null");
				return ;
	        }
	        
			if(!contains(d)) {
	            Debug.LogError("DisplayObject must be child");
				return ;
	        }*/
			
			d.parent = null;
			
			/*if(numChildren != debugRealNumChildren) {
				Debug.Log("CACA");
			}*/
			//var oldReal:int = debugRealNumChildren;
			if(d == _firstChild) _firstChild = _firstChild.nextSibling;
			if(d == _lastChild) _lastChild = _lastChild.prevSibling;
			if(d.prevSibling != null) d.prevSibling.nextSibling = d.nextSibling;
			if(d.nextSibling != null) d.nextSibling.prevSibling = d.prevSibling;
			d.prevSibling = null;
			d.nextSibling = null;
			d.childIndex = -1;
			numChildren--;
			if(d.isInternal) {
				numInternalChildren--;
			}
			
			//d.onRemoved();
			_isInternalDirty = true;
			/*
			if(oldReal - debugRealNumChildren != 1) {
				Debug.Log("CACA");
			}
			if(numChildren != debugRealNumChildren) {
				Debug.Log("CACA");
			}*/
	    }
		
		protected function GetInternalToRemove():Vector.<DisplayObject> {
			if(numInternalChildren == 0) return null;
			var index:int = 0 ; 
			var crntChild:DisplayObject = _firstChild;
			
			if(_isInternalDirty) {
				_lastInternalToRemove = new DisplayObject[numInternalChildren];
				for(var i:int = 0 ; i < numChildren ; i++) {
					if(crntChild.isInternal) {
						_lastInternalToRemove[index] = crntChild;
						crntChild.toBeRemovedInternal = true;
						index++;
					}
					crntChild = crntChild.nextSibling;
				}
				_isInternalDirty = false;
			} else {
				for(var j:int = 0 ; j < _lastInternalToRemove.length ; j++) {
					_lastInternalToRemove[j].toBeRemovedInternal = true;
				}
			}
			
			return _lastInternalToRemove;
		}
		
	    public function getChildAt(index:int):DisplayObject {
			var crntChild:DisplayObject = _firstChild ;
			if(index <= 0) return _firstChild;
			if(index >= (numChildren-1)) return _lastChild;
			
			for(var i:int = 0 ; i < index ; i++) {
				crntChild = crntChild.nextSibling; 
			}
	        return crntChild;
	    }
	
	    public function getChildByName(name:String):DisplayObject {
			var crntChild:DisplayObject = _firstChild ;
			for(var i:int = 0 ; i < numChildren ; i++) {
				if (crntChild.name == name) return crntChild;
				crntChild = crntChild.nextSibling; 
			}
	        return null;
	    }
		
		public function getChildWithMaxChildren():DisplayObjectContainer{
			var result:DisplayObjectContainer = null;
			var crntChild:DisplayObject = _firstChild;
			var tempContainer:DisplayObjectContainer;
			var currentMaxChildren:int = 0;
			
			for(var i:int = 0 ; i < numChildren ; i++) {
				tempContainer = crntChild as DisplayObjectContainer;
				if(tempContainer != null){
					if(tempContainer.numChildren > currentMaxChildren){
						currentMaxChildren = tempContainer.numChildren;
						result = tempContainer;
					}
				}
				crntChild = crntChild.nextSibling;
			}
			
			return result;
		}
		
		public function getChildIndex(d:DisplayObject):int {
			return d.childIndex ;
			/*
			if(d.parent != this) {
				Debug.LogError("Object must be child");
				return -1;
			}
			var crntChild:DisplayObject = _firstChild ;
			for(var i:int = 0 ; i < numChildren ; i++) {
				if (crntChild == d) return i;
				crntChild = crntChild.nextSibling; 
			}
	        return -1;
	        */
	    }	
		
		public function contains(d:DisplayObject):Boolean {
			return (d.parent == this);
		}
		
		public function get firstChild():DisplayObject {
			return _firstChild;
		}
		
		public function get lastChild():DisplayObject {
			return _lastChild;
		}
		
		public function GetAllTextField(recursive:Boolean, outTextArray:Vector.<TextField>):void {
			var crntChild:DisplayObject = firstChild;
			var dc:DisplayObjectContainer ;
			while(crntChild != null) {
				if(crntChild.isTextfield) {
					outTextArray.push(crntChild as TextField);
				}
				dc = crntChild as DisplayObjectContainer;
				if(recursive && dc != null) {
					dc.GetAllTextField(true, outTextArray);
				}
				crntChild = crntChild.nextSibling;
			}
		}
		
		public function ReportLanguageChanged():void {
			var t:Vector.<TextField> = new Vector.<TextField>();
			GetAllTextField(true, t);
			
			for(var i:int = 0 ; i < t.length ; i++) {
				t[i].LanguageChanged();
			}
		}
	}
}