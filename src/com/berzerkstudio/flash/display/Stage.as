package com.berzerkstudio.flash.display {
	public class Stage extends DisplayObjectContainer {
		static public var instance:Stage ;
		static public var STAGE_WIDTH:int = 480;
		static public var STAGE_HEIGHT : int = 320;

		public function Stage() {
			instance = this;
		}

		private var _stageWidth:int = STAGE_WIDTH;
		private var _stageHeight:int = STAGE_HEIGHT;
		public var frameRate:int = 60;
		public var scaleMode:String = "NO_SCALE";
		
		override public function get width():Number {return _stageWidth ;}
		override public function get height():Number {return _stageHeight ;}
		
		public function get stageWidth():Number{return _stageWidth ;}
		public function get stageHeight():Number{return _stageHeight ;}
		
		public function set stageWidth(value:Number):void {hitArea.width = _stageWidth = value; }
		public function set stageHeight(value:Number):void {hitArea.height = _stageHeight = value;}
		
	}
}