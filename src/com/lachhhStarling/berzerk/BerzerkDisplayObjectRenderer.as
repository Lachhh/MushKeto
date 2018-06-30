package com.lachhhStarling.berzerk {
	import starling.core.RenderSupport;

	import com.berzerkstudio.flash.display.BzkBitmap;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.berzerkstudio.flash.display.ShapeObject;
	import com.berzerkstudio.flash.display.TextField;
	import com.berzerkstudio.flash.geom.Color;
	import com.berzerkstudio.flash.geom.ColorTransform;
	import com.berzerkstudio.flash.geom.Transform2D;
	import com.berzerkstudio.flash.meta.Matrix4x4;

	import flash.geom.Matrix;
	
	public class BerzerkDisplayObjectRenderer {
		public var displayObject:com.berzerkstudio.flash.display.DisplayObject ;
		
		private var bzkManager:BerzerkStarlingManager;
		
		static private var startMatrix2d:Matrix;
		static private var _startMatrix:Matrix4x4;
		static private var _startColor:com.berzerkstudio.flash.geom.Color;
		
		static public var matrix2dAnchor:Matrix = new Matrix();
		
		static private var renderSupport : RenderSupport;
		static private var parentAlpha : Number;
		private var withinMask : Boolean;

		public function BerzerkDisplayObjectRenderer(berzerkMgr : BerzerkStarlingManager, pDisplayObject : DisplayObject) {
			bzkManager = berzerkMgr;
			displayObject = pDisplayObject;
			_startMatrix = Matrix4x4.createIdentity();
			
			
			_startColor = com.berzerkstudio.flash.geom.Color.white;
			startMatrix2d = new Matrix();
		}
		
		public function setUpRenderSupport(support:RenderSupport, alpha:Number):void{
			renderSupport = support;
			parentAlpha = alpha;
		}
		
		public function reset():void{
			renderSupport = null;
			parentAlpha = 0.0;
		}
				
		public function draw():void {
			optimizedDeepDraw();
		}
		
		private function optimizedDeepDraw():void{
			displayObject.transform.concatenedMatrix2D = startMatrix2d;
			displayObject.transform.mustUpdateConcatened = false;
			
			var count:int = 0;
			var childLeft:int = 1;
			
			var firstDis:com.berzerkstudio.flash.display.DisplayObject = displayObject;
			var crntDis:com.berzerkstudio.flash.display.DisplayObject = firstDis;
			var inBatch:Boolean = true;
			var s:ShapeObject ;
			var bmp:BzkBitmap;
			var dc:com.berzerkstudio.flash.display.DisplayObjectContainer ;
			var child:com.berzerkstudio.flash.display.DisplayObject ;
			var txt:com.berzerkstudio.flash.display.TextField ;
			var mustUpdateConcatened:Boolean = false;
			var childTransform:Transform2D ;
			var crntTransform:Transform2D ;
			
			while(childLeft > 0){
				
				if(crntDis.visible){
					
					if(crntDis.hasMouseEvent) {
						if(crntDis.mouseEnabled) {
							bzkManager.bzkMouseCollider.AddMouseCollider(crntDis, crntDis.transform.concatenedMatrix2D);
						}
					}
					if(crntDis.isBitmap){
						bmp = (crntDis as BzkBitmap);
						if(bmp.transform.mustUpdateConcatened) {
							//matrix2dAnchor.a = 1;
							//matrix2dAnchor.b = 0;
							//matrix2dAnchor.c = 0;
							//matrix2dAnchor.d = 1;
							//matrix2dAnchor.tx = bmp.anchorX;
							//matrix2dAnchor.ty = bmp.anchorY;
							//matrix2dAnchor.concat(bmp.transform.concatenedMatrix2D);
							//bmp.transform.concatenedMatrix2D.copyFrom(matrix2dAnchor);
							bmp.transform.mustUpdateConcatened = false;
						}
						DrawBitmap(bmp, bmp.transform.concatenedMatrix2D, bmp.transform.colorTransform);
					} else if(crntDis.isShape) {
						s = (crntDis as ShapeObject);
			
						
						if(s.transform.mustUpdateConcatened) {
							matrix2dAnchor.a = 1;
							matrix2dAnchor.b = 0;
							matrix2dAnchor.c = 0;
							matrix2dAnchor.d = 1;
							matrix2dAnchor.tx = s.anchorX;
							matrix2dAnchor.ty = s.anchorY;
							matrix2dAnchor.concat(s.transform.concatenedMatrix2D);
							s.transform.concatenedMatrix2D.copyFrom(matrix2dAnchor);
							s.transform.mustUpdateConcatened = false;
						}
						
						

						DrawShape(s, s.transform.concatenedMatrix2D, s.transform.colorTransform);
					} else if(crntDis.isTextfield) {
						txt = (crntDis as com.berzerkstudio.flash.display.TextField);
						bzkManager.bzkStarlingTextFieldRenderer.addTxtToBatch(txt);
						txt.onEnterFrame();
					} else {
						//add childs to stack
						crntDis.onEnterFrame();
						dc = (crntDis as com.berzerkstudio.flash.display.DisplayObjectContainer);
						count = dc.numChildren;
						crntTransform = crntDis.transform;
						mustUpdateConcatened = crntTransform.mustUpdateConcatened;
						child = dc.lastChild;
						
						while(count > 0) {
							
							//Unshift
							childLeft++;
							child.tempNext = firstDis ;
							firstDis = child;
							childTransform = child.transform;
								
							if(mustUpdateConcatened || childTransform.mustUpdateConcatened) {
								if(childTransform._isDirty) {
									childTransform.CalcMatrix();
								}
								
								childTransform.concatenedMatrix2D.copyFrom(childTransform.matrix2D);
								childTransform.concatenedMatrix2D.concat(crntTransform.concatenedMatrix2D);
								
								childTransform.concatenedRot = crntTransform.concatenedRot + childTransform.rotation;
								childTransform.mustUpdateConcatened = true;
							
								if(child.isShape) {
									s = (child as ShapeObject);
									s.needToRefreshVertexData = true;	
								}	
							} 
							
							
							
							/**/
							childTransform.colorTransform.Concat(crntTransform.colorTransform);
							count--;
							child = child.prevSibling;
						}
						
						crntTransform.mustUpdateConcatened = false;
					}
					
					if(crntDis.endTextFieldBatchBeforeRendering) {
						bzkManager.bzkStarlingShapeObjectRenderer.endBatch();
						bzkManager.bzkStarlingTextFieldRenderer.drawTextFieldBatch();
					}
				}
					
				if(crntDis.stopMask) {
					stopMask();
				}
				
				if(crntDis.maskRect) {
					startMask(crntDis);	
				}
				
				crntDis = firstDis;
				firstDis = crntDis.tempNext ;
				crntDis.tempNext = null;
				childLeft--;
			}

			
			if(inBatch) {
				bzkManager.bzkStarlingShapeObjectRenderer.endBatch();
				bzkManager.bzkStarlingTextFieldRenderer.drawTextFieldBatch();
				inBatch = false;
			}
			
			if(withinMask) {
				stopMask();
			}
		}
		
		private function startMask(crntDis:DisplayObject):void {
			crntDis.transform.setConcatenedMask(crntDis.maskRect);
			
			bzkManager.bzkStarlingShapeObjectRenderer.endBatch();
			bzkManager.bzkStarlingTextFieldRenderer.drawTextFieldBatch();
			renderSupport.pushClipRect(crntDis.transform.maskConcatened, false);
			
			var recurDisplay:DisplayObject = crntDis;
			while(recurDisplay.nextSibling == null || recurDisplay == displayObject) {
				recurDisplay = recurDisplay.parent;
			}
			if(recurDisplay.nextSibling) {
				recurDisplay.nextSibling.stopMask = true;
			}			
			
			withinMask = true;
		}
		
		private function stopMask():void {
			bzkManager.bzkStarlingShapeObjectRenderer.endBatch();
			bzkManager.bzkStarlingTextFieldRenderer.drawTextFieldBatch();
			withinMask = false;
			//var rects:int = crntDis.numberOfMaskRectsToPop;
			//for(var i:int = 0; i < rects; i++){
				renderSupport.popClipRect();
			//}
			
			//crntDis.numberOfMaskRectsToPop = 0;
		}
		
		private function DrawBitmap(bmp:BzkBitmap, matrix:Matrix, color:ColorTransform):void{
			renderSupport.finishQuadBatch();
			bzkManager.bzkStarlingShapeObjectRenderer.drawSingleBitmap(bmp, matrix, color);
		}
		
		private function DrawShape(s:ShapeObject, matrix:Matrix, color:ColorTransform):void {
			//if(!s.modelFla.isTextureLoaded) return ;
			renderSupport.finishQuadBatch();
			bzkManager.bzkStarlingShapeObjectRenderer.drawShapeObject(s, matrix, color);
		}
	}
}