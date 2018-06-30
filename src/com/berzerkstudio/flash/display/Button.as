package com.berzerkstudio.flash.display {
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.lachhh.utils.Utils;
	import flash.events.MouseEvent;
	public class Button extends MovieClip {
		private var _canGoto:Boolean = true;
		public function Button() {
			super();
			buttonMode = true;
			useHandCursor = true;
			
		}

		override public function LoadFromMeta(m : MetaDisplayObject) : void {
			super.LoadFromMeta(m);
			Init();
		}

		protected function Init() : void {
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver); 
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mouseChildren = false;
			_canGoto = true;  
			gotoUp();
		}
		
		override public function onEnterFrame() : void {
			super.onEnterFrame();
			
		}
		
		public function gotoUp():void {
			gotoAndPlayStr("up");
		}
		
		public function gotoDown():void {
			gotoAndPlayStr("down");
		}
		
		public function gotoOver():void {
			gotoAndPlayStr("over");
		}
		
		public function gotoOut():void {
			gotoAndPlayStr("out");
		}
		
		public function Destroy():void {
			removeEventListener(MouseEvent.ROLL_OVER, onMouseOver); 
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mouseEnabled = mouseChildren = false;
			buttonMode = false;    
		}
		
		public function isOnOverFrame():Boolean {
			return (Utils.isBetweenOrEqual(currentFrame , metaMovieClip.GetFrame("over"), metaMovieClip.GetFrame("out")-1));
		}
		
		public function isOnOutFrame():Boolean {
			var max:int = Math.max(metaMovieClip.GetFrame("selected")-1, totalFrames);
			return (Utils.isBetweenOrEqual(currentFrame , metaMovieClip.GetFrame("out"), max));
		}
		
		public function isPlayingOutFrame():Boolean {
			var max:int = Math.max(metaMovieClip.GetFrame("selected")-1, totalFrames-1);
			return (Utils.isBetweenOrEqual(currentFrame , metaMovieClip.GetFrame("out"), max-2));
		}
		
		private function onMouseOver(e:MouseEvent):void{
			if(!canGoto) return;
		    gotoAndPlayStr("over");
		}
		private function onMouseOut(e:MouseEvent):void{
			if(!canGoto) return;
		    gotoAndPlayStr("out");
		}
	
		private function onMouseDown(e:MouseEvent):void{
			if(!canGoto) return;
			gotoAndPlayStr("down");
		}	
		
		private function onMouseUp(e:MouseEvent):void{
			if(!canGoto) return;
			gotoAndPlayStr("up");
		}	
		
		
		
		public function get canGoto():Boolean {
			return _canGoto;
		}
		
		public function set canGoto(value:Boolean):void {
			_canGoto = value;
			buttonMode = value;
			useHandCursor = value;
		}
	}
	

}
