package com.lachhhStarling.berzerk {
	import com.lachhh.lachhhengine.VersionInfo;
	import starling.display.QuadBatch;
	import starling.textures.TextureSmoothing;
	import starling.text.BitmapFont;
	import starling.display.BlendMode;
	import starling.utils.VAlign;
	import flashx.textLayout.formats.TextAlign;
	import starling.core.RenderSupport;
	import starling.display.Sprite;
	import starling.display.DisplayObjectContainer;
	import starling.text.TextField;

	import com.berzerkstudio.flash.display.TextField;
	import com.berzerkstudio.flash.geom.ColorTransform;

	import flash.geom.Matrix;
	/**
	 * @author LachhhSSD
	 */
	public class BerzerkTextFieldRenderer {
		static public var starlingTextFields : Vector.<starling.text.TextField> = new Vector.<starling.text.TextField>;
		static public var currentTextFields : int = -1;
		
		static private var _txtField:Vector.<com.berzerkstudio.flash.display.TextField> = new Vector.<com.berzerkstudio.flash.display.TextField>(100);
		static private var _txtFieldIndex:int = -1 ;
		
		private var renderSupport:RenderSupport;
		private var parentAlpha:Number;
		
		private var renderText:Vector.<starling.text.TextField> = new Vector.<starling.text.TextField>();

		public function BerzerkTextFieldRenderer() {
			
		}
		
		public function setUpRenderSupport(support:RenderSupport, parentAlpha:Number):void{
			renderSupport = support;
			this.parentAlpha = parentAlpha;
		}

		public function reset() : void {
			renderSupport = null;
			parentAlpha = 0.0;
			
			renderText.length = 0;
			
			for each(var txt:starling.text.TextField in starlingTextFields) {
				txt.visible = false;
			}
			currentTextFields = -1;
			_txtFieldIndex = -1;
		}
		
		public function addTxtToBatch(txt:com.berzerkstudio.flash.display.TextField):void {
			_txtFieldIndex++;
			_txtField[_txtFieldIndex] = txt;
		}
		
		public function finalizeRender():void{
			for each(var txt:starling.text.TextField in renderText){
				renderSupport.loadIdentity();
				renderSupport.transformMatrix(txt);
				txt.render(renderSupport, parentAlpha);
			}
			
			renderSupport.finishQuadBatch();
		}
		
		public function drawTextFieldBatch():void {
			var txtField:com.berzerkstudio.flash.display.TextField ;
			var fontName:String ;
			var fontSet:Boolean ;
			var i:int = 0 ; 
			var cpt:int = _txtFieldIndex ; 
			//_txtField.sort(sortOnFont);
			
			while(cpt >= 0) {
				fontSet = false ;
				for(i = 0 ; i <= _txtFieldIndex ;i++) {
					txtField = _txtField[i];
					
					if(txtField != null) {
						if(!fontSet) {
							fontName = txtField.fontNameUsed;
							fontSet = true;
						}
						
						if(txtField.fontNameUsed == fontName) {
							drawTextField(txtField, txtField.transform.concatenedMatrix2D, txtField.transform.colorTransform);
							_txtField[i] = null;
							cpt--;
						}
					}
				}
			}
			_txtFieldIndex = -1;
		}
		
		/*private function sortOnFont(a:com.berzerkstudio.flash.display.TextField, b:com.berzerkstudio.flash.display.TextField):int {
			if(a == null) return 1;
			if(b == null) return -1;
			if(a.fontName < b.fontName) return -1;
			if(a.fontName > b.fontName) return 1;
			return 0;
		}*/
		
		public function drawTextField(txt:com.berzerkstudio.flash.display.TextField, matrix:Matrix, color:ColorTransform):void {
			if(VersionInfo.DEBUG_NOTEXTFIELD_STARLING) return ;
			
			txt.updateStarlingTexts(color);
			if(txt.metaDisplayObject.hasShadow) {
				renderSupport.loadIdentity();
				renderSupport.transformMatrix(txt.starlingTextFieldShadow);
				txt.starlingTextFieldShadow.render(renderSupport, parentAlpha);
			}
			renderSupport.loadIdentity();
			renderSupport.transformMatrix(txt.starlingTextField);
			txt.starlingTextField.render(renderSupport, parentAlpha);
		}
	}
}
