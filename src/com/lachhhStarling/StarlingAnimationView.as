package com.lachhhStarling {
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	/**
	 * @author LachhhSSD
	 */
	public class StarlingAnimationView {
		static private var NULL_DISPLAY : MovieClip = ExternalAPIManager.berzerkAnimationManager.createEmpty();
		public var anim : MovieClip;
		public var modelAnim : ModelFlashAnimation = ModelFlashAnimationEnum.NULL;
		private var parentView : DisplayObjectContainer;

		public function StarlingAnimationView(pParentView:DisplayObjectContainer) {
			parentView = pParentView;
			anim = NULL_DISPLAY;
		}
		
		public function recurStop():void{
			var m:MovieClip = (anim as MovieClip);
			m.recurStop();
			//Utils.recurStop(anim);
		}

		public function setAnim(pModelAnim : ModelFlashAnimation) : void {
			if(modelAnim.id == pModelAnim.id) return ;
			
			destroyAnimation();		
			if(pModelAnim.isNull) return ;
			modelAnim = pModelAnim;
			anim = ExternalAPIManager.berzerkAnimationManager.createAnimation(modelAnim);
			parentView.addChild(anim);
		}
		
		public function destroyAnimation():void {
			if(anim == NULL_DISPLAY) return ;
			if(!hasAnim()) return ;
			ExternalAPIManager.berzerkAnimationManager.destroyAnimation(anim);
			anim = NULL_DISPLAY;
			modelAnim = ModelFlashAnimationEnum.NULL;
		}
		
		public function destroy():void {
			destroyAnimation();
		}

		public function addChildOnNewParent(newParent : DisplayObjectContainer) : void {
			anim.removeFromParent();
			parentView = newParent;
			parentView.addChild(anim);
		}
		
		public function hasAnim():Boolean {
			return !(modelAnim.isNull);
		}
		
		public function setVisibleIfExist(b:Boolean):void {
			if(!hasAnim()) return ;
			anim.visible = b;
		}
	}
}
