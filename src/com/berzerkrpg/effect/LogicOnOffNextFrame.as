package com.berzerkrpg.effect {
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class LogicOnOffNextFrame extends ActorComponent {
		public var isOn:Boolean = false;
		public var visualToToggle:MovieClip;
		public var invisibleOnFirstFrame:Boolean = true;
		
		public function LogicOnOffNextFrame(pVisualToToggle:MovieClip) {
			super();
			visualToToggle = pVisualToToggle;
		}

		override public function update() : void {
			super.update();
			if(isOn) {
				visualToToggle.nextFrame();
			} else {
				visualToToggle.prevFrame();
			}
			if(invisibleOnFirstFrame) visualToToggle.visible = (visualToToggle.currentFrame > 1);	
		}
		
		public function setOnOff(b:Boolean):void {
			isOn = b;
		}
		
		public function gotoFirstFrame():void {
			visualToToggle.gotoAndStop(1);
		}
		
		public function get isIdle():Boolean{
			if(isOnFirstFrame && !isOn) return true;
			if(isOnLastFrame && isOn) return true;
			return false;
		}
		
		public function get isOnLastFrame():Boolean{
			return (visualToToggle.currentFrame == visualToToggle.totalFrames);
		}
		
		public function get isOnFirstFrame():Boolean{
			return (visualToToggle.currentFrame == 1);
		}
		
		public function gotoLastframe():void {
			visualToToggle.gotoAndStop(visualToToggle.totalFrames);
		}
	}
}
