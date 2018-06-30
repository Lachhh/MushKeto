package com.lachhhStarling.berzerk {
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;
	import com.lachhh.lachhhengine.camera.CameraFlash;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhhStarling.StarlingAnimationView;

	import flash.geom.Point;
	

	/**
	 * @author LachhhSSD
	 */
	public class RenderFlashOrDisplay extends ActorComponent {
		
		public var animView : StarlingAnimationView;
		public var xVisualOffset : Number= 0;
		public var yVisualOffset : Number = 0;
		public var updatePosOnRefresh : Boolean = true;
		public var alpha:Number = 1;
		public var visible:Boolean = true;
		static private var pTemp:Point = new Point();
		

		public function RenderFlashOrDisplay(parentView : DisplayObjectContainer) {
			super();
			animView = new StarlingAnimationView(parentView);
		}

		override public function start() : void {
			super.start();
		}

		override public function refresh() : void {
			super.refresh();
			if(!animView.hasAnim()) return ;
			if(updatePosOnRefresh) refreshPos();
			refreshAlpha();
			refreshVisible();
		}
		
		private function refreshPos():void {
			if(!actor) return ;
			animView.anim.x = actor.px + xVisualOffset;
			animView.anim.y = actor.py + yVisualOffset; 
		}
		
		private function refreshAlpha():void{
			if(!actor) return ;
			animView.anim.alpha = alpha;
		}
		
		private function refreshVisible():void{
			if(!actor) return ;
			animView.anim.visible = visible;
		}
		
		public function setAnim(modelAnimation:ModelFlashAnimation):void {
			animView.setAnim(modelAnimation);
			refreshPos();
		}
				
		override public function update() : void {
			super.update();
			refresh();
		}

		override public function destroy() : void {
			super.destroy();
			animView.destroy();
		}

		public function getXRelativeToScreen() : Number {
			if(animView.modelAnim.isNull) return (actor.px + xVisualOffset)-CameraFlash.mainCamera.boundsFOV.x;
			pTemp = animView.anim.getPosOnScreen(pTemp);
			return pTemp.x;
		}
		
		public function getYRelativeToScreen():Number {
			if(animView.modelAnim.isNull) return  (actor.px + xVisualOffset)-CameraFlash.mainCamera.boundsFOV.x;
			pTemp = animView.anim.getPosOnScreen(pTemp);
			return pTemp.y;
		}
		
		static public function addToActor(actor: Actor, parentView:DisplayObjectContainer, modelAnim:ModelFlashAnimation): RenderFlashOrDisplay {
			var result: RenderFlashOrDisplay = new RenderFlashOrDisplay(parentView);
			result.setAnim(modelAnim);
			actor.addComponent(result);
			return result;
		}
	}
}
