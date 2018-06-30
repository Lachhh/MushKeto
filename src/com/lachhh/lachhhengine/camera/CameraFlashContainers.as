package com.lachhh.lachhhengine.camera {
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	/**
	 * @author LachhhSSD
	 */
	public class CameraFlashContainers {
		static public var instance:CameraFlashContainers;
		public var allLayerVisual:Vector.<DisplayObjectContainer> = new Vector.<DisplayObjectContainer>();
		public var container:DisplayObjectContainer;
		
		public var flatBackVisual : DisplayObjectContainer ;
		public var levelPartBackVisual : DisplayObjectContainer ;
		public var levelPartVisual : DisplayObjectContainer ;
		public var fake3dVisual : DisplayObjectContainer ;
		public var backFxVisual : DisplayObjectContainer ;
		public var deathVisual : DisplayObjectContainer ;
		public var deathFxVisual : DisplayObjectContainer ;
		public var heroVisual : DisplayObjectContainer ;
		public var enemyVisual : DisplayObjectContainer ;
		public var itemVisual : DisplayObjectContainer ;
		public var ammoVisual : DisplayObjectContainer ;
		public var foreFxVisual : DisplayObjectContainer ;
		public var debugVisual : DisplayObjectContainer ;
		

		public function CameraFlashContainers(pContainer:DisplayObjectContainer) {
			container = pContainer;
			
			flatBackVisual = createLayerVisual();
			levelPartBackVisual = createLayerVisual();
			levelPartVisual = createLayerVisual();
			fake3dVisual = createLayerVisual();
			backFxVisual = createLayerVisual();
			ammoVisual = createLayerVisual();
			enemyVisual = createLayerVisual();
			heroVisual = createLayerVisual();
			itemVisual = createLayerVisual();
			foreFxVisual = createLayerVisual();
			deathVisual = createLayerVisual();
			deathFxVisual = createLayerVisual();
			debugVisual = createLayerVisual();
			instance = this;
		}


		private function createLayerVisual() : DisplayObjectContainer {
			var result : MovieClip = ExternalAPIManager.berzerkAnimationManager.createAnimation(ModelFlashAnimationEnum.EMPTY) as MovieClip;
			allLayerVisual.push(result);
			container.addChild(result);
			
			return result;
		}
		
		public function destroy():void {
			for (var i : int = 0; i < allLayerVisual.length; i++) {
				var d:DisplayObjectContainer = allLayerVisual[i];
				container.removeChild(d);
				ExternalAPIManager.berzerkAnimationManager.destroyAnimation(d);
			}
			allLayerVisual = new Vector.<DisplayObjectContainer>();
			container = null; 
		}
	}
}
