package com.lachhh.lachhhengine.ui.views {
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;
	import com.lachhhStarling.StarlingAnimationView;

	/**
	 * @author Lachhh
	 */
	public class ViewBaseDynamic extends ViewBase {
		public var flashAnim:StarlingAnimationView ;
		public function ViewBaseDynamic(pScreen : Actor, pParent : DisplayObjectContainer, modelFlash:ModelFlashAnimation) {
			flashAnim = new StarlingAnimationView(pParent);
			flashAnim.setAnim(modelFlash);
			super(pScreen, flashAnim.anim);
		}

		override public function destroy() : void {
			super.destroy();
			flashAnim.destroy();
		}
	}
}