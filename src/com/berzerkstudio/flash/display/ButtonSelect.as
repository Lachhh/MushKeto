package com.berzerkstudio.flash.display {
	import flash.events.MouseEvent;
	/**
	 * @author LachhhSSD
	 */
	public class ButtonSelect extends Button{
		private var _isSelected:Boolean = false;
		private var _toggleButtonMode:Boolean = false;
		public function ButtonSelect() {
			super();
		}

		override public function Destroy() : void {
			super.Destroy();
			removeEventListener(MouseEvent.MOUSE_DOWN, onToggleDown);
		}

		override protected function Init() : void {
			super.Init();
			_isSelected = false;
			_toggleButtonMode = false;
		}

		public function Select() : void {
			_isSelected = true;
			canGoto = false;
			gotoAndPlayStr("selected");
		}
		
		public function Deselect():void {
			_isSelected = false;
			canGoto = true;
			gotoUp();
		}
		
		public function get isSelected():Boolean {
			return _isSelected;
		}
		
		public function get toggleButtonMode():Boolean {
			return _toggleButtonMode;
		}
		
		public function Toggle():void {
			if(_isSelected) {
				Deselect();
			} else {
				Select();	
			}
		}
		
		private function onToggleDown(e:MouseEvent):void {
			Toggle();
		}
		
		public function set toggleButtonMode(value:Boolean):void {
			_toggleButtonMode = value;
			if(_toggleButtonMode) {
				addEventListener(MouseEvent.MOUSE_DOWN, onToggleDown);
			} else {
				removeEventListener(MouseEvent.MOUSE_DOWN, onToggleDown);
			}
		}
	}


}
