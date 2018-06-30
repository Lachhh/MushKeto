package com.berzerkrpg.effect {
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.berzerkrpg.DefaultMainGame;
	import com.berzerkrpg.MainGame;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.lachhh.io.Callback;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author Lachhh
	 */
	public class EffectFlashColor extends ActorComponent {
		public var prctDelta:Number = 0.1;
		
		public var prct:Number = 0;
		public var color:int = 0xFFFFFF;
		
		public var _sprite:DisplayObject ;
		public var useGameSpeed:Boolean = true;
		public var callback:Callback;
		public var parentOfSprite:DisplayObjectContainer;
		
		public function EffectFlashColor() {
			super();
			_sprite = ExternalAPIManager.berzerkAnimationManager.createAnimation(ModelFlashAnimationEnum.FX_BIGTEXTURE);
			
			parentOfSprite = ExternalAPIManager.berzerkAnimationManager.getStage();
		}

		override public function start() : void {
			super.start();
			
			_sprite.alpha = 1;
			var r:int = (((color >> 16) & 0xFF)+0.0);
			var g:int = (((color >> 8) & 0xFF)+0.0);
			var b:int = (((color >> 0) & 0xFF)+0.0);
			_sprite.setColorAnimViewPrct(r, g, b, 1);
			
			parentOfSprite.addChild(_sprite);
		}
		
		public function setUnderAllUI():void {
			DefaultMainGame.UI_CONTAINER_BELOW.addChildAt(_sprite, 0);
			parentOfSprite = DefaultMainGame.UI_CONTAINER_BELOW;
		}
		
		public function Init():void {
			
		}
		
		override public function update() : void {
			super.update();
			
			prct -= (useGameSpeed ? GameSpeed.getSpeed() : 1) *prctDelta;
			_sprite.alpha = prct;
			if(prct <= 0 || prct > 1) {
				if(callback) callback.call();
				destroyAndRemoveFromActor();
			}	
		}

		
		override public function destroy() : void {
			super.destroy();
			ExternalAPIManager.berzerkAnimationManager.destroyAnimation(_sprite);
			_sprite.removeFromParent();
			_sprite = null;
		}

		static public function create(color:uint, fadeOutTime:int):EffectFlashColor {
			var result:EffectFlashColor = new EffectFlashColor();
			result.prct = 1;
			result.prctDelta = 1/fadeOutTime;
			result.color = color;
			MainGame.dummyActor.addComponent(result);
			return result;
		}
	}
}
