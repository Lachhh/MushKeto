package com.lachhh.lachhhengine.camera {
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.lachhh.io.ExternalAPIManager;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author LachhhSSD
	 */
	public class CameraFlash extends CameraBase {
		static public var mainCamera:CameraFlash;
		public var gameVisualContainer:CameraFlashContainers ;
		public var visualStaticContainer:DisplayObjectContainer ;
		
		private var mouseInWorld:Point = new Point();
		
		static public var tempRect:Rectangle = new Rectangle();
		private var _main:DisplayObjectContainer;
		
		public function CameraFlash(main:DisplayObjectContainer) {
			super();
			_main = main;
			visualStaticContainer = ExternalAPIManager.berzerkAnimationManager.createEmpty();
			gameVisualContainer = new CameraFlashContainers(ExternalAPIManager.berzerkAnimationManager.createEmpty());
			mainCamera = this;
	
		}
		
		override public function start() : void {
			super.start();
			_main.addChildAt(gameVisualContainer.container, 0);
			_main.addChildAt(visualStaticContainer, 0);
		}
		
		override public function update() : void {
			super.update();
			updateBounds();
			gameVisualContainer.container.scaleX = zoomScale;
			gameVisualContainer.container.scaleY = zoomScale;
			gameVisualContainer.container.x = -boundsFOV.x;
			gameVisualContainer.container.y = -boundsFOV.y;			
		}
				
		public function getMouseInWorldFlash():Point {
			mouseInWorld.x = _main.mouseX + boundsFOV.x;
			mouseInWorld.y = _main.mouseY + boundsFOV.y;
			return mouseInWorld;
		}
		
		
		
		override public function destroy() : void {
			super.destroy();
			_main.removeChild(gameVisualContainer.container);
			_main.removeChild(visualStaticContainer);
		}
	}
}
