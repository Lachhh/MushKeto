
package com.berzerkstudio.flash.meta {
	import com.lachhhStarling.ModelFlaEnum;
	import com.berzerkstudio.ModelFla;
	public class MetaDisplayObject {
		public var name:String = "";
		public var theClassName:String = "";
		public var theClassId:int = -1;
		public var modelFla:ModelFla = ModelFlaEnum.NULL;
		public var transform:Meta2DTransform = new Meta2DTransform();
		public var isButton:Boolean = false;
		
		
		public var isAnimAsset:Boolean = false;
		
		//public var metaFlaId:int = -1;
		//public var alpha:float = 1;
		
		//MetaShapeObject
		public var prefabId:int = -1;
		public var prefabName:String = "";
		public var packedSpriteframe:int = 0;
		public var textureName:String = "";
		
		public var width:int = 0;
		public var height:int = 0;	
		public var isSingularTexture : Boolean = false;
		
		//MetaTextField
		public var text:String = "";
		public var textSize:int = 12;
		public var textId:String = "";
		public var textAlign:String = "l";
		public var textColor:uint = 0;
		public var fontName:String = "";
		public var textLeading:int = 0;
		public var r:Number = 0;
		public var g:Number = 0;
		public var b : Number = 0;
		public var anchorX : Number = 0;
		public var anchorY : Number = 0;
		public var hasShadow:Boolean = false;
		public var shadowDistance:int = 0;
		public var shadowColor : uint = 0xFFFFFF;
		public var shadowAngle : int = 0;
		

		public function MetaDisplayObject() {
		}

		public function isShape() : Boolean {
			return prefabId != -1;
		}
		public function isTextField():Boolean { 
			return fontName != ""; 
		}
		
		public function get isNull():Boolean { return name == "";}
		
	}
}