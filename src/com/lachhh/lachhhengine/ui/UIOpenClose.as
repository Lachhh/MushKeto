package com.lachhh.lachhhengine.ui {
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.animation.LogicCallbackOnFrame;
	import com.lachhh.lachhhengine.animation.LogicCallbackOnFrameEnd;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;

	/**
	 * @author LachhhSSD
	 */
	public class UIOpenClose extends UIBase {
		
		public var closeStartFrame:int;
		public var callbackOnClose:Callback;
		public var idleCallback:LogicCallbackOnFrame;
		
		public function UIOpenClose(visualId : ModelFlashAnimation, pIdleFrame:int, pCloseStartFrame:int) {
			super(visualId);
			idleCallback = LogicCallbackOnFrame.addCallbackOnFrameRepeat(this, new Callback(onIdle, this, null), pIdleFrame, true, visual);
			LogicCallbackOnFrameEnd.addEndCallback(this, new Callback(onLastFrame, this, null), visual);

			idleCallback.frame = pIdleFrame;
			closeStartFrame = pCloseStartFrame ; 
		}

		protected function onIdle() : void {
			renderComponent.animView.anim.stop();
		}
		
		public function close():void {
			enableInput(false);
			renderComponent.animView.anim.gotoAndPlay(closeStartFrame);
			renderComponent.animView.anim.play();
		}
		
		public function closeWithCallbackOnEnd(callback:Callback):void {
			close();
			LogicCallbackOnFrame.addCallbackOnFrame(this, callback, visual.totalFrames -1, visual);
		}
		
		protected function onLastFrame() : void {
			if(callbackOnClose) callbackOnClose.call();
			destroy();
		}
		
		public function isOnIdleFrame():Boolean {
			if(destroyed) return false;
			return renderComponent.animView.anim.currentFrame == idleCallback.frame;
		}
	}
}
