package com.lachhhStarling.berzerk {
	import starling.core.RenderSupport;

	import com.berzerkstudio.MetaCachedGO;
	import com.berzerkstudio.MetaCachedGOManager;
	import com.berzerkstudio.ModelFla;
	import com.berzerkstudio.flash.display.BzkBitmap;
	import com.berzerkstudio.flash.display.ShapeObject;
	import com.berzerkstudio.flash.geom.ColorTransform;
	import com.lachhhStarling.ModelFlaEnum;
	import com.lachhhStarling.OptimizedImage;
	import com.lachhhStarling.ShaderQuadBatch;

	import flash.geom.Matrix;
	/**
	 * @author LachhhSSD
	 */
	public class BerzerkShapeObjectRenderer { 
		public var flaRenderers:Array = new Array();
		public var lastFlaRenderer:BerzerkFlaRenderer = BerzerkFlaRenderer.NULL;
		
		private var staticQuadBatch:ShaderQuadBatch;
		public var numShapeObject:int;
		
		private var renderSupport:RenderSupport;
		private var parentAlpha:Number;
		
		public var numTextureChanged:int = 0;
		public var numTextureStatic:int = 0;
		
		public function BerzerkShapeObjectRenderer() {
			staticQuadBatch = new ShaderQuadBatch();
			
			for (var i : int = 0; i < ModelFlaEnum.ALL.length; i++) {
				var model:ModelFla = ModelFlaEnum.getFromIndex(i);
				var flaRenderer:BerzerkFlaRenderer = new BerzerkFlaRenderer(model);
				flaRenderers.push(flaRenderer); 
			}	
		}
		
		public function getFlaRendererFromModel(model:ModelFla):BerzerkFlaRenderer {
			for (var i : int = 0; i < flaRenderers.length; i++) {
				var flaRenderer:BerzerkFlaRenderer = flaRenderers[i];
				if(flaRenderer.modelFla.isEquals(model)) return flaRenderer;
			}
			return null;
		}
		
		public function setUpRenderSupport(support:RenderSupport, parentAlpha:Number):void{
			renderSupport = support;
			this.parentAlpha = parentAlpha;
		}

		public function reset() : void {
			renderSupport = null;
			parentAlpha = 0.0;
			
			lastFlaRenderer = BerzerkFlaRenderer.NULL;
			for (var i : int = 0; i < flaRenderers.length; i++) {
				var flaRenderer:BerzerkFlaRenderer = flaRenderers[i];
				flaRenderer.reset();
			}
			numShapeObject = 0;
			numTextureStatic = 0;
			numTextureChanged = 0;
		}

		public function endBatch():void {
			//addToMasterQuadBatch();
			
			renderSupport.loadIdentity();
			
			staticQuadBatch.render(renderSupport, parentAlpha);
			
			staticQuadBatch.reset();
		}
		
		public function drawSingleBitmap(bitmap:BzkBitmap, matrix:Matrix, color:ColorTransform):void{
			endBatch();
			staticQuadBatch.addImageWithColorData(bitmap.image, color, matrix, parentAlpha);
			endBatch();
		}
		
		public function drawShapeObject(s:ShapeObject, matrix:Matrix, color:ColorTransform):void {
			numShapeObject++;
			
			//updateCurrentFlaRenderer(s);
			
			//checkIfNeedToLoadFla();
			
			if(s.metaDisplayObject.isSingularTexture) {
				var textureName:String = s.metaDisplayObject.textureName; 
				if(!BerzerkStarlingManager.berzerkFlaLoader.isSingularTextureLoaded(s.metaDisplayObject)) {
					s.transform._isDirty = true;
					s.transform.mustUpdateConcatened = true;
					BerzerkStarlingManager.berzerkFlaLoader.loadSingularTexture(s.metaDisplayObject);
					return ;
				} else {
					//trace("Trying to draw : " + textureName);
					endBatch();
				}
			}
			
			
			if(!BerzerkStarlingManager.berzerkFlaLoader.isAtlasLoaded(s.modelFla)) {
				s.transform._isDirty = true;
				s.transform.mustUpdateConcatened = true;
				BerzerkStarlingManager.berzerkFlaLoader.loadFla(s.modelFla);
				return;
			}
			
			var metaCachedGO:MetaCachedGO = MetaCachedGOManager.getMetaCachedGO(s);
			var img:OptimizedImage = metaCachedGO.getImage();
			
			if(staticQuadBatch.isStateChange(color.isTinted || img.tinted, parentAlpha, img.texture, img.smoothing, img.blendMode)) {
				endBatch();
			}
			
			if(s.needToRefreshVertexData) {
				s.needToRefreshVertexData = false;
				numTextureChanged++;
			} else {
				numTextureStatic++;
			}
			
			staticQuadBatch.addImageWithColorData(img, color, matrix, parentAlpha);
		}
		
		public function countFlaQuadbatches():int{
			var count:int = 0;
			
			for each(var flaRenderer:BerzerkFlaRenderer in flaRenderers){
				count += flaRenderer.quadBatchs.length;
			}
			
			return count;
		}
		
		private function updateCurrentFlaRenderer(s:ShapeObject):void{
			if(s.modelFla.id == lastFlaRenderer.modelFla.id) return;
			lastFlaRenderer = getFlaRendererFromModel(s.modelFla);
			staticQuadBatch.forceTinted = s.modelFla.forceTinting;
			staticQuadBatch.mBlendMode =  s.modelFla.blendMode;
		}
		
		private function checkIfNeedToLoadFla():void {
			var metaFla:MetaFla = BerzerkStarlingManager.berzerkFlaLoader.getMetaFlaFromModel(lastFlaRenderer.modelFla);
			
			if(metaFla.isAtlasLoaded) return ;
			if(metaFla.isAtlasLoading) return ;
			BerzerkStarlingManager.berzerkFlaLoader.loadFla(metaFla.modelFla);
		}
		
		public function getQuadBatchFromShapeObject(s:ShapeObject):ShaderQuadBatch {
			if(s.modelFla.id == lastFlaRenderer.modelFla.id) return lastFlaRenderer.getQuadBatch();
			//addToMasterQuadBatch();
			lastFlaRenderer = getFlaRendererFromModel(s.modelFla);
			lastFlaRenderer.setNewBatch();
			return lastFlaRenderer.getQuadBatch();
		}
		
		private function addToMasterQuadBatch():void {
			if(lastFlaRenderer.modelFla.isNull) return ;
			var qb:ShaderQuadBatch = lastFlaRenderer.getQuadBatch();
			//if(qb.parent != null) return ;
			
			// don't add child in future - add to a master displayObject list in the DisplayObjectRenderer class
			// keeping this comment here as a note
			//shapeObjectContainer.addChild(lastFlaRenderer.getQuadBatch());
		}
	}
}
