package com.berzerkrpg.logic {
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.IAnimationProxy;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class LogicGotoFrame extends ActorComponent {
		public var frame:int;
		public var visualMc:MovieClip;
		public var invisibleOnLastFrame : Boolean = false;
		public var spd:int = 1;

		public function LogicGotoFrame(pFrame:int, pVisualMc:MovieClip) {
			super();
			frame = pFrame;
			visualMc = pVisualMc;
		}

		override public function update() : void {
			super.update();
			if(visualMc == null) return ;
			var i : int = 0;
			if(visualMc.currentFrame < frame) {
				for (i = 0; i < spd; i++) 				
					visualMc.nextFrame();
			} else if(visualMc.currentFrame > frame) {
				for (i = 0; i < spd; i++)
					visualMc.prevFrame();
			}
			if(invisibleOnLastFrame) {
				visualMc.visible = (visualMc.currentFrame < visualMc.totalFrames); 
			}
		}
	}
}
