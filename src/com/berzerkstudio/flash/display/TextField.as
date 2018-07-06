package com.berzerkstudio.flash.display {
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	import com.berzerkrpg.multilingual.ModelLanguageEnum;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.multilingual.TextInstance;
	import com.berzerkstudio.flash.geom.ColorTransform;
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.lachhh.lachhhengine.MyMath;

	public class TextField extends DisplayObject {
		private static const AUTO_ : String = "AUTO_";
		public var textColor : uint ;
		public var multiline : Boolean; // Deprecated
		
		public var fontName:String;
		public var fontNameUsed:String;
		private var _text:String;
		public var textId:String;
		
		public var color:uint = 0; 
		
		public var size:Number;
		
		public var maxScrollV:Number;
		public var maxScrollH:Number;
		public var selectable:Boolean;
		public var autoSize:String;
		public var background:Boolean ;
		public var backgroundColor:uint ;
		public var type:String;
		public var isDynamic:Boolean;
		
		
		public var align:String;
		public var vAlign:String = VAlign.TOP;
		
		public var xOffset:int = 0;
		public var yOffset:int = 0;
		public var textDirty:Boolean = true;
		public var autoFitText:Boolean = true;
		
		public var prefabName:String = "";
		public var prefabId:int = -1;
		
		private var _textFormat : TextFormat = new TextFormat();
		public var textColorUsed : Boolean = false;
		public var hasShadow : Boolean = false;
		private var _lastLang:String = "";
		
		private var isTextATwitchCmd:Boolean = false;
		
		private var _starlingTextField:starling.text.TextField;
		private var _starlingTextFieldShadow : starling.text.TextField;
		private var _starlingRequiresRedraw : Boolean = true;
		

		public function get starlingTextField() : starling.text.TextField {
			return _starlingTextField;
		}

		public function TextField() {
			_starlingTextField = new starling.text.TextField(100, 400, "null");
			_starlingTextField.batchable = true;
			//_starlingTextField.border = true;
		}

		override public function LoadFromMeta(m : MetaDisplayObject) : void {
			super.LoadFromMeta(m);
			_starlingTextField.width = 100;
			_starlingTextField.height = 400;
			
			fontName = PATCH_switchFontIfNeeded(m.fontName);
			fontNameUsed = fontName;
			_lastLang = "";
			
			textId = m.textId;
			if(isAutoText()) {
				textId = m.name;
			}
			
			isTextATwitchCmd = false;
			
			if(textId != "") {
				var txtInstance:TextInstance = TextFactory.findTextInstanceFromNameOfVar(textId);
				if(txtInstance == null) {
					trace("WARNING : No text Found for " + textId);
				}
				refreshTextFromId();
			} else {
				_text = m.text;
				isTextATwitchCmd = (_text.substr(0, 1) == "!") ;
			}
			
			autoFitText = true;
			
			size = m.textSize;
			textColorUsed = false;
			textDirty = true;		
			
			isDynamic = false;
			
			textColor = m.textColor;
			
			prefabName = "";
			prefabId = -1;
			
			hitArea.width = m.width;
			hitArea.height = m.height;
			vAlign = VAlign.TOP;
			switch(m.textAlign) {
				case "l" : 
					align = HAlign.LEFT;
					break;
				case "c" : 
					align = HAlign.CENTER;
					break;
				case "r" : 
					align = HAlign.RIGHT;
					break;
			}	
			_starlingRequiresRedraw = true;
		}
		
		private function isAutoText():Boolean {
			if(name.indexOf(AUTO_) == 0) return true;
			return false;
		}
		
		private function getFontName():String {
			return PATCH_switchFontIfNeeded(metaDisplayObject.fontName);
		}
		
		private function PATCH_switchFontIfNeeded(str:String):String {
			var strLower:String = str.toLowerCase();
			if(TextFactory.CRNT_LANG.useNotoFont) {
				return "Noto";
			}
			if(strLower == "big_bottom_typeface_normal") return "Cooper Std Black";
			if(!isValidFont(str)) {
				return "GothamBold";
			}
			return str;
		}
		
		private function isValidFont(str:String):Boolean {
			var strLower:String = str.toLowerCase();
			if(strLower == "gothambold") return true;
			if(strLower == "cooper std black") return true;
			if(strLower == "sf ironsides extended") return true;
			if(strLower == "vinque-regular") return true;
			return false;
		}
		
		public function updateStarlingTexts(color:ColorTransform = null):void {
			if(isATwitchCmd()) {
				highlightTextForTwitch();
			}
			
			updateStarlingTextField(_starlingTextField);
			updateTextColors(_starlingTextField, this.textColor, color);
			if(metaDisplayObject.hasShadow) {
				if(_starlingTextFieldShadow == null){
					_starlingTextFieldShadow = new starling.text.TextField(100, 400, "null");
					_starlingTextFieldShadow.batchable = true;
				}
				updateStarlingTextField(_starlingTextFieldShadow);
				updateTextColors(_starlingTextFieldShadow, metaDisplayObject.shadowColor, color);
				var dx : Number = ((MyMath.myCos((metaDisplayObject.shadowAngle)))* metaDisplayObject.shadowDistance);
				var dy : Number = ((MyMath.mySin((metaDisplayObject.shadowAngle)))* metaDisplayObject.shadowDistance);
				_starlingTextFieldShadow.x += dx;
				_starlingTextFieldShadow.y += dy;
			}
			_starlingRequiresRedraw = false;
		}
		
		private function updateTextColors(pStarlingTextField:starling.text.TextField, textColor:uint, color:ColorTransform = null):void{
			if(color && color.isTinted){
				pStarlingTextField.color = color.transformColor(textColor);
				pStarlingTextField.alpha = color.concatColor.alphaMultiplier;
			}
			else{
				pStarlingTextField.color = textColor;
				pStarlingTextField.alpha = this.alpha;
			}
		}
		
		private function updateStarlingTextField(pStarlingTextField:starling.text.TextField):void{
			
			pStarlingTextField.transformationMatrix = this.transform.concatenedMatrix2D;
			
			pStarlingTextField.x = Math.round(pStarlingTextField.x);
			pStarlingTextField.y = Math.round(pStarlingTextField.y);
			
			if(_lastLang != TextFactory.CRNT_LANG.id) {
				refreshTextFromId();
			}
			
			if(!_starlingRequiresRedraw) return;
			
			
			pStarlingTextField.visible = this.visible;
			pStarlingTextField.text = this.text;
			pStarlingTextField.fontSize = this.size;
			pStarlingTextField.width = this.width;
			pStarlingTextField.leading = this.metaDisplayObject.textLeading ;
			pStarlingTextField.fontName = this.fontName;
			
			if(this.fontName.toLocaleLowerCase() == "big_bottom_typeface_normal") autoFitText = false;
	
			if(!autoFitText) {
				pStarlingTextField.height = Math.max(this.height,  pStarlingTextField.textBounds.height);
			}
			
			var font:BitmapFont = starling.text.TextField.getBitmapFont(pStarlingTextField.fontName);
			if(font == null){
				if(pStarlingTextField.fontName == "gothamblack") {
					pStarlingTextField.fontName = "gothambold";
					font = starling.text.TextField.getBitmapFont("gothambold");
				}
				if(font == null) { 
					trace("Berzerkstudio.TextField [FONT ERROR] font: " + pStarlingTextField.fontName + " is null!");
				}
			}
			
			if(autoFitText) resizeToFit(pStarlingTextField);
			
			pStarlingTextField.vAlign = vAlign;
			pStarlingTextField.hAlign = align;
			pStarlingTextField.redraw();
			
		}
		
		private function isATwitchCmd():Boolean {
			if(!isTextATwitchCmd) return false;
			return true;
		}
		
		private function highlightTextForTwitch():void {
			this.fontName = "GothamBold";
			metaDisplayObject.hasShadow = true;
			metaDisplayObject.shadowAngle = 90;
			metaDisplayObject.shadowDistance = 2;
			metaDisplayObject.shadowColor = 0x6340A4;
			this.textColor = 0xFFFFFF;
		}
		
		private function resizeToFit(pStarlingTextField:starling.text.TextField):void {
			var isTooBigToFit:Boolean = (pStarlingTextField.textBounds.height > this.height);
			//if(isTooBigToFit) {
				while((isTooBigToFit) && (pStarlingTextField.fontSize > 8)) {				
					pStarlingTextField.fontSize -= 1;
					isTooBigToFit = (pStarlingTextField.textBounds.height > this.height);	
				} 
			/*} else {
				pStarlingTextField.height = this.height;
			}*/
		}
		
		public function LanguageChanged():void {
			/*if(TextFactory.getinstance().language.useSystemFont) {
				fontNameUsed = TextFactory.getinstance().language.fontUsed;
			} else {*/
			fontNameUsed = fontName;
			//}
			
			//if(textId != -1) {
				//_text = TextFactory.getinstance().GetMsg(textId);
			//} 
			
			prefabName = "";
			prefabId = -1;
			textDirty = true;
			if(metaGo != null) {
				metaGo.shapeObject = null;
			}
			metaGo = null;
		}
		
		public function GetText():String {
			/*if(textId != -1) {
				_text = TextFactory.getinstance().GetMsg(textId);
			}*/
			return _text;
		}
		
		public function refreshTextFromId():void {
			if(textId != "") {
				_text = TextFactory.getMsgFromName(textId);
				fontName = getFontName();
				_lastLang = TextFactory.CRNT_LANG.id;
				_starlingRequiresRedraw = true;
				isTextATwitchCmd = (_text.substr(0, 1) == "!") ;
			}
		}
		
		public function getTextFormat():TextFormat {
			return _textFormat;
		}
		
		public function setTextFormat(tf:TextFormat):void {
			
		}
		
		public function set text(value:String):void {
			if(_lastLang != TextFactory.CRNT_LANG.id) {
				fontName = getFontName();
				_lastLang = TextFactory.CRNT_LANG.id;
				_starlingRequiresRedraw = true;
			}
			if(_text == value) return ;
				
			fontName = getFontName();
			_starlingRequiresRedraw = true;
			_text = value;
			isTextATwitchCmd = (_text != null && _text.substr(0, 1) == "!") ;
		}
		
		public function get text():String {
			return _text;
		}
		
		public function get textWidth():Number{
			if(_starlingRequiresRedraw) updateStarlingTexts();
			return _starlingTextField.textBounds.width;
		}
		
		public function get textHeight():Number{
			if(_starlingRequiresRedraw) updateStarlingTexts();
			return _starlingTextField.textBounds.height;
		}
		
		//public function set width(value:Number):void{metaDisplayObject.width }
		override public function get width():Number{
			if(metaDisplayObject == null) return 0;
			return metaDisplayObject.width ;
		}
		
		override public function set width(value:Number):void{ 
			if(metaDisplayObject == null) return ;
			if(metaDisplayObject.width != value){
				metaDisplayObject.width = value; 
				_starlingRequiresRedraw = true;
			}
		}
		
		//public function set height(value:Number):void{}
		override public function get height():Number{
			if(metaDisplayObject == null) return 0;
			return metaDisplayObject.height ;
		}
		
		override public function set height(value:Number):void{
			if(metaDisplayObject == null) return ;
			if(metaDisplayObject.height != value){
				metaDisplayObject.height = value;
				_starlingRequiresRedraw = true; 
			}
		}

		override public function get isTextfield() : Boolean {
			return true ;
		}

		public function get starlingTextFieldShadow() : starling.text.TextField {
			return _starlingTextFieldShadow;
		}
		
	}
}