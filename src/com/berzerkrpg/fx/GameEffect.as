package com.berzerkrpg.fx {
	import com.berzerkrpg.scenes.GameScene;
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;
	import com.lachhhStarling.berzerk.RenderFlashOrDisplay;

	/**
	 * @author LachhhSSD
	 */
	public class GameEffect extends Actor {
		static public var listOfFX:Vector.<GameEffect> = new Vector.<GameEffect>();
		static public var temp:Vector.<GameEffect> = new Vector.<GameEffect>();
		 

		public function GameEffect() {
			super();
			GameScene.instance.fxManager.add(this);
			listOfFX.push(this);
		}

		override public function destroy() : void {
			super.destroy();
			var i:int = listOfFX.indexOf(this);
			if(i != -1) listOfFX.splice(i, 1);
		}
		
		static public function destroyFirstXOfModelAnim(limit:int, modelAnim:ModelFlashAnimation):Boolean {
			var destroyedSome:Boolean = false;
			appendInstanceOfModelAnim(modelAnim, temp);
			for (var i : int = (temp.length-(limit+1)); i >= 0; i--) {
				var view:Actor = temp[i];
				view.destroy();
				destroyedSome = true;
			}
			return destroyedSome;
		}
		
		static public function destroyFirstXOfModelAnims(limit:int, modelAnims:Array):Boolean {
			var destroyedSome:Boolean = false;
			appendInstanceOfModelAnims(modelAnims, temp);
			for (var i : int = (temp.length-(limit+1)); i >= 0; i--) {
				var view:Actor = temp[i];
				view.destroy();
				destroyedSome = true;
			}
			return destroyedSome;
		}
		
		static public function appendInstanceOfModelAnim(modelAnim:ModelFlashAnimation, output:Vector.<GameEffect>):void {
			while(output.length > 0) output.pop();
			for (var i : int = 0; i < listOfFX.length; i++) {
				if(listOfFX[i].isSameAnim(modelAnim)) output.push(listOfFX[i]);
			}
		}
		
		static public function getTempFxOfModelAnims(modelAnims:Array):Vector.<GameEffect> {
			return appendInstanceOfModelAnims(modelAnims, temp);
		}

		static public function appendInstanceOfModelAnims(modelAnims : Array, output : Vector.<GameEffect>) : Vector.<GameEffect> {
			while(output.length > 0) output.pop();
			var modelAnim:ModelFlashAnimation;
			for (var i : int = 0; i < listOfFX.length; i++) {
				for (var j : int = 0; j < modelAnims.length; j++) {
					modelAnim = modelAnims[j];
					if(listOfFX[i].isSameAnim(modelAnim)) {
						output.push(listOfFX[i]);
						break;
					}
				}
			}
			return output;
		}
		
		public function isSameAnim(modelAnim:ModelFlashAnimation):Boolean {
			if(destroyed) return false;
			if(renderComponent == null) return false;
			if(!renderComponent.animView.hasAnim()) return false;
			if(!renderComponent.animView.modelAnim.isEquals(modelAnim)) return false;
			return true;
		}

		static public function createFx(parentAnim : DisplayObjectContainer, modelAnim : ModelFlashAnimation, x : int, y : int) : GameEffect {
			var result:GameEffect = new GameEffect();
			result.renderComponent = RenderFlashOrDisplay.addToActor(result, parentAnim, modelAnim);
			result.px = x;
			result.py = y;
			result.refresh();
			
			return result;
		}
	}
}
