package com.berzerkstudio {
	import com.berzerkstudio.flash.meta.MetaColorTransform;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimationEnum;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;
	import flash.geom.Rectangle;
	/**
	 * @author LachhhSSD
	 */
	public class MetaAnimation {
		//public var modelAnim:ModelStarlingAnimation = ModelStarlingAnimationEnum.NULL;
		
		/*public var x:Number = 0;
		public var y:Number = 0 ;
		public var scaleX:Number = 1;
		public var scaleY:Number = 1;
		public var rotation:Number = 0;
		public var alpha:Number = 0;
		public var width:Number = 0;
		public var height:Number = 0;
		public var visible:Boolean = true;
		public var cacheAsBitmap : Boolean = false;
		public var mouseX : Number = 0;
		public var mouseY : Number = 0;*/
		
		
		public var fps:Number = 30;
	
		public var isPlaying:Boolean = true;
		public var isLooping:Boolean = true;
		public var loops:int = 0;
		
		public var metaColorTransform:MetaColorTransform = new MetaColorTransform();
		public var bounds : Rectangle = new Rectangle();

		public function MetaAnimation() {
			
		}
	}
}
