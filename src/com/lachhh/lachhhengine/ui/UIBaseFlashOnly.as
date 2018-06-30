package com.lachhh.lachhhengine.ui {
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.berzerkrpg.MainGame;
	import com.lachhh.lachhhengine.actor.Actor;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	/**
	 * @author LachhhSSD
	 */
	public class UIBaseFlashOnly extends UIBase {
		public var visualRaw : DisplayObject;
		public var visualFlash : MovieClip;

		public function UIBaseFlashOnly(visualClass : Class) {
			super(ModelFlashAnimationEnum.EMPTY);
			UIBase.manager.add(this);
			visualRaw = new visualClass() as DisplayObject;
			visualFlash = visualRaw as MovieClip;
			MainGame.instance.stage.addChild(visualRaw);
		}

		override public function destroy() : void {
			super.destroy();
			if(visualRaw.parent == null) return;
			MainGame.instance.stage.removeChild(visualRaw);
		}
	}
}
