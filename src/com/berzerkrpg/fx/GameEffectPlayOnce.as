package com.berzerkrpg.fx {
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.animation.LogicCallbackOnFrameEnd;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;
	import com.lachhhStarling.berzerk.RenderFlashOrDisplay;

	/**
	 * @author LachhhSSD
	 */
	public class GameEffectPlayOnce extends GameEffect {
		override public function start() : void {
			super.start();
			
			LogicCallbackOnFrameEnd.addEndCallback(this, new Callback(destroy, this, null), renderComponent.animView.anim);
		}

		override public function update() : void {
			super.update();
			
		}
		
		static public function createStaticFx(parentContainer:DisplayObjectContainer, modelAnim:ModelFlashAnimation, x:int, y:int):GameEffectPlayOnce {
			var result:GameEffectPlayOnce = new GameEffectPlayOnce();
			result.renderComponent = new RenderFlashOrDisplay(parentContainer);
			result.addComponent(result.renderComponent); 
			result.renderComponent.setAnim(modelAnim) ;
			result.px = x;
			result.py = y;
			result.refresh();
			return result;
		}
	}
}
