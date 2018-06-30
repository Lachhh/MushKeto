package com.lachhh.flash.debug {
	import flash.display.MovieClip;
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.effect.CallbackTimerEffect;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.ui.UIBaseFlashOnly;

	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * @author LachhhSSD
	 */
	public class UIFPSCounter extends UIBaseFlashOnly {
		
		public var tf:TextField = new TextField();

		private var fps:int = 0;
		
		public function UIFPSCounter() {
			super(MovieClip);
			tf.textColor = 0x888888;
			tf.mouseEnabled = false;
			visualFlash.mouseChildren = false;
			visualFlash.mouseEnabled = false;

			visualFlash.addChild(tf);
			visualFlash.mouseChildren = visualFlash.mouseEnabled = false; 
			
			MainGame.instance.addChild(visualFlash);
			
			tick();
		}
		
		public function show(b:Boolean):void {
			enabled = b;
			visualFlash.visible = b;
		}
		
		public function get isShown():Boolean {
			return enabled;
		}

		override public function update() : void {
			super.update();
			fps++;
		}

		private function tick():void {
			CallbackTimerEffect.addWaitCallFctToActor(this, tick, 1000);
			if(!enabled) return ;
			tf.text = " FPS : " + fps ;
			fps = 0;
		}

	}
}
