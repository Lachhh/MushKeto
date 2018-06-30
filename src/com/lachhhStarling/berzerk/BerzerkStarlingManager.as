package com.lachhhStarling.berzerk {
	import com.lachhh.io.CallbackGroup;
	import com.berzerkstudio.flash.display.DisplayObject;
	import starling.core.RenderSupport;
	import starling.display.DisplayObjectContainer;

	import com.lachhh.lachhhengine.VersionInfo;
	/**
	 * @author LachhhSSD
	 */
	public class BerzerkStarlingManager extends DisplayObjectContainer {
		private var displayObjectRenderer : BerzerkDisplayObjectRenderer;
		
		public var berzerkStage : BerzerkDefaultStage;
		public var bzkStarlingShapeObjectRenderer : BerzerkShapeObjectRenderer;
		public var bzkStarlingTextFieldRenderer : BerzerkTextFieldRenderer;
		public var bzkMouseCollider : BerzerkMouseCollider;
		static public var berzerkFlaLoader : IBerzerkTextureLoader = new DummyTextureLoader();
		static public var berzerkModelFlaAssetLoader : IBerzerkModelFlaLoader ;
		static public var instance : BerzerkStarlingManager;
		public var lastDrawCount : int;
		
		public var onRenderComplete:CallbackGroup = new CallbackGroup();

		public function BerzerkStarlingManager(pStarlingStage : DisplayObjectContainer) {
			
			if(instance != null) {
				throw new Error("Double instance of BerzerkStarlingManager") ;
			}
			
			pStarlingStage.addChild(this);
			berzerkStage = new BerzerkDefaultStage();
			displayObjectRenderer = new BerzerkDisplayObjectRenderer(this, berzerkStage.stage);
			bzkStarlingShapeObjectRenderer = new BerzerkShapeObjectRenderer();
			bzkStarlingTextFieldRenderer = new BerzerkTextFieldRenderer();
			bzkMouseCollider = new BerzerkMouseCollider();
			instance = this;
		}

		public function update() : void {
			//if(!VersionInfo.starlingReady) return ;
		}
		
		public override function render(support : RenderSupport, parentAlpha : Number):void{
			displayObjectRenderer.reset();
			bzkStarlingShapeObjectRenderer.reset();
			bzkStarlingTextFieldRenderer.reset();
			
			displayObjectRenderer.setUpRenderSupport(support, parentAlpha);
			bzkStarlingShapeObjectRenderer.setUpRenderSupport(support, parentAlpha);
			bzkStarlingTextFieldRenderer.setUpRenderSupport(support, parentAlpha);
			
			DisplayObject.updateDraggedObject();
			
			displayObjectRenderer.draw();
			bzkStarlingShapeObjectRenderer.endBatch();
			//bzkStarlingTextFieldRenderer.drawTextFieldBatch();
			//bzkStarlingTextFieldRenderer.finalizeRender();
			
			bzkMouseCollider.update();
			
			onRenderComplete.call();
			
			lastDrawCount = support.drawCount;
		}
	}
}
