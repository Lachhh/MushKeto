package com.lachhh.flash.ui {
	import com.berzerkstudio.flash.display.ButtonSelect;
	
	
	/**
	 * @author Simon Lachance
	 */
	public class ButtonSelectGroup {
		private var _btns:Vector.<com.berzerkstudio.flash.display.ButtonSelect> ;
		private var _selectedButton : com.berzerkstudio.flash.display.ButtonSelect ;
		
		public function ButtonSelectGroup() {
			_btns = new Vector.<com.berzerkstudio.flash.display.ButtonSelect>();	
		}
				
		public function clear():void {
			removeAllButton();
		}
		
		public function addButton(b : com.berzerkstudio.flash.display.ButtonSelect) : void {
			var i:int = _btns.indexOf(b) ;
			if(i == -1) _btns.push(b);
		} 
		
		public function removeButton(b : com.berzerkstudio.flash.display.ButtonSelect) : void {
			var i:int = _btns.indexOf(b) ;
			if(i != -1) _btns.splice(i,1);
		}
		
		public function removeAllButton() : void {
			_btns = new Vector.<com.berzerkstudio.flash.display.ButtonSelect>;
		} 
		 
		public function getButton(i : int) : com.berzerkstudio.flash.display.ButtonSelect {
			if(i < 0 || i >= _btns.length) {
				throw new Error("index error : " + i);	
			}
			return _btns[i];
		}

		public function getButtonIndex(b : com.berzerkstudio.flash.display.ButtonSelect) : int {
			for(var i:int = 0 ; i < _btns.length ; i++) {
				if(_btns[i] == b) return i;	
			}	
			return -1;
		}
				
		public function destroy():void {
			while(_btns.length > 0) {
				var b : com.berzerkstudio.flash.display.ButtonSelect = _btns.shift();
				//b.destroy();	
			}
			_btns = null;	
		}
		
		public function deselect():void {
			for(var i:int = 0 ; i < _btns.length ; i++) {
				_btns[i].deselect();	
			}	
			_selectedButton = null;
		}
		
		public function contains(b : com.berzerkstudio.flash.display.ButtonSelect):Boolean {
			
			return (_btns.indexOf(b) != -1);
		}
		
		public function selectButtonFromIndex(i:int):void {
			selectButton(getButton(i));
		}
		
		public function selectButton(b:com.berzerkstudio.flash.display.ButtonSelect):void {
			if(!contains(b)) {
				return ;
			}
			
			if(_selectedButton != null) {
				_selectedButton.deselect();	
			}
			_selectedButton = b;
			_selectedButton.select();
		}
		
		public function selectNext():void {
			if(_selectedButton == null) return ;
			var i:int = (getButtonIndex(_selectedButton)+1);
			if(i >= _btns.length) i = 0;
			selectButton(_btns[(getButtonIndex(_selectedButton)+1)% _btns.length]);
		}
		
		public function selectPrev():void {
			if(_selectedButton == null) return ;
			var i:int = (getButtonIndex(_selectedButton)-1);
			if(i < 0) i = _btns.length-1;
			selectButton(_btns[i]);	
		}
		
		public function get length():int {
			return _btns.length;
		}
		
		public function get selectedButton():com.berzerkstudio.flash.display.ButtonSelect {
			return _selectedButton;
		}
	}
}
