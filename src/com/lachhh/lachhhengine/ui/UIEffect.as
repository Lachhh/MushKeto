package com.lachhh.lachhhengine.ui {
	import com.lachhh.io.Callback;
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.animation.LogicCallbackOnFrameEnd;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;
	import com.lachhhStarling.berzerk.RenderFlashOrDisplay;

	/**
	 * @author LachhhSSD
	 */
	public class UIEffect extends Actor {
		public function UIEffect() {
			super();
			UIBase.manager.add(this);
		}

		
		override public function start() : void {
			super.start();
			LogicCallbackOnFrameEnd.addEndCallback(this, new Callback(destroy, this, null), renderComponent.animView.anim);
			
		}
		
		static public function createStaticUiFx(animId:ModelFlashAnimation, x:int, y:int):UIEffect {
			var result:UIEffect = new UIEffect();
			result.renderComponent = RenderFlashOrDisplay.addToActor(result, UIBase.defaultUIContainer, animId);
			result.px = x;
			result.py = y;
			result.refresh();
			return result;
		}
		
		static public function createStaticUiFxOnMouseCursor(animId:ModelFlashAnimation):UIEffect {
			return createStaticUiFx(animId, KeyManager.GetMousePos().x, KeyManager.GetMousePos().y);
		}
	}
}
