package com.berzerkstudio {
	import com.lachhhStarling.format.ModelImageFormat;
	import com.lachhhStarling.format.ModelImageFormatEnum;
	import com.berzerkstudio.flash.meta.Matrix4x4;
	import com.berzerkstudio.flash.meta.Meta2DMatrix;
	import com.berzerkstudio.flash.meta.Meta2DTransform;
	import com.berzerkstudio.flash.meta.MetaColorTransform;
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.berzerkstudio.flash.meta.MetaDisplayObjectContainer;
	import com.berzerkstudio.flash.meta.MetaMovieClip;
	import com.berzerkstudio.flash.meta.MetaMovieClipFrame;
	import com.berzerkstudio.flash.meta.MetaRectangle;
	import com.berzerkstudio.flash.meta.Vector4;
	import com.lachhh.flash.FlashUtils;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;
	import com.lachhh.lachhhengine.meta.ModelBase;
	import com.lachhhStarling.ModelFlaEnum;

	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;

	// import com.lachhh.lachhhengine.animation.ModelStarlingAnimation;
	public class ModelFla extends ModelBase {
		private static var aliasesLoaded : Boolean = false;
		public var modelImageFormat:ModelImageFormat = ModelImageFormatEnum.PNG;
		public var allSymbol : Vector.<MetaDisplayObject> = new Vector.<MetaDisplayObject>();
		
		public var docName:String = "" ;
		public var numTextures :int = -1;
		public var blendMode :String = "normal";
		public var smoothing :String = "none";
		public var forceTinting:Boolean = false;
		
		public var isLoaded:Boolean = false;
		public var isTextureLoaded:Boolean = false;
		
		public function ModelFla(pIndex:int = -1, pIdStr:String = "") {
			super(pIndex, pIdStr); 
			
			
		}
		
		public function saveToByteArray():ByteArray{
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(this);
			return bytes;
		}
		
		public function loadFromByteArray(data:ByteArray):void{
			if(data == null) return;
			try{
				var flaObject:Object = data.readObject();
			} catch(e:Error){
				trace("[MODEL FLA] " + id + " - ERROR!");
				trace(e);
				trace(e.getStackTrace());
				return;
			}
			var fla:ModelFla = flaObject as ModelFla;
			
			this.allSymbol = fla.allSymbol;
			this.index = fla.index;
			this.docName = fla.docName;
			this.numTextures = fla.numTextures;
			this.blendMode = fla.blendMode;
			this.forceTinting = fla.forceTinting;
			
			for (var i : int = 0; i < allSymbol.length; i++) {
				var mc:MetaMovieClip = allSymbol[i] as MetaMovieClip;
				mc.modelFla = this;
				for(var k: int = 0; k < mc.metaMovieClipFrames.length; k++){
					var frame:MetaMovieClipFrame = mc.metaMovieClipFrames[k];
					for(var j: int = 0; j < frame.metaDisplayObjects.length; j++){
						frame.metaDisplayObjects[j].modelFla = this;
					}
				}
			}
			isLoaded = true;
		}
		
		public function initFromEmbeddedXML(embeddedXml:Class):void {
			var xmlData:Object = new embeddedXml();
			/*var xmlObject:Object = embeddedXml.data as Object;
			var xml:XML = embeddedXml.data as XML;
			var xmlNode:XMLNode = embeddedXml.data as XMLNode;*/
			var str:String = xmlData.toString();
			initFromXmlString(str);
			isLoaded = true;
		}
		
		public function initFromXmlString(xmlString:String):void {
			var _xDoc:XMLDocument = new XMLDocument();
			_xDoc.ignoreWhite = true;
			_xDoc.parseXML(xmlString);
			
			
			var all:XMLNode = _xDoc.childNodes[0];
			//trace(all);
			
			docName = all.attributes["docName"] as String;
			numTextures = FlashUtils.myParseFloat(all.attributes["numTexture"]);
			allSymbol = new Vector.<MetaDisplayObject>(all.childNodes.length);
			
			
			for(var i:int =0 ; i < all.childNodes.length ; i++) {
				var childNode:XMLNode = all.childNodes[i];
				allSymbol[i] = CreateMetaDisplayObject(childNode);
			}
		}
		
		public function GetMetaDisplayObject(classId:int):MetaDisplayObject {		
			return allSymbol[classId];
		}
		
		public function GetMetaDisplayObjectFromString(name:String):MetaDisplayObject {
			for (var i : int = 0; i < allSymbol.length; i++) {
				if(allSymbol[i].theClassName == name) return allSymbol[i]; 
			}		
			return null;
		}
		
		public function CreateMetaDisplayObject(xmlSymbol:XMLNode):MetaDisplayObject {
			var metaFrames : Vector.<MetaMovieClipFrame> = new Vector.<MetaMovieClipFrame>();
			//var metaFramesArray:Array = new Array();
	
			var className:String  = xmlSymbol.attributes["theClass"];		
			var animClassId:int  = FlashUtils.myParseFloat(xmlSymbol.attributes["theClassId"]) ;	
			var isButton:Boolean = (xmlSymbol.attributes["isButton"] == "1");
			var isAnimAsset:Boolean = (xmlSymbol.attributes["isAnimAsset"] == "1");
			
	
			var xmlFramesList:Array = xmlSymbol.childNodes;
			var xmlFramesLabelsList:Array = null;
			
			var numFrames:int = xmlFramesList.length ;
			var anim:MetaMovieClip = new MetaMovieClip();
			
			anim.theClassId = animClassId;
			anim.theClassName = className;
			anim.modelFla = this;
			anim.name = "instance";
			anim.isButton = isButton;
			anim.isAnimAsset = isAnimAsset;
					
			//anim.metaFlaId = index;
			
			//_allMetaDisplayObject[animClassId] = anim;
			var maxDisplayObjects:int = 0 ; 
			
			
			/*if(xmlFramesLabelsList != null) {
				anim.frameLabels = new Vector.<String>(xmlFramesLabelsList.length);
				anim.frameLabelsId = new Vector.<int>(xmlFramesLabelsList.length);
				for(var jj:int  = 0 ; jj < xmlFramesLabelsList.length ; jj++) {
					var xmlFrameLabel:XML = xmlFramesLabelsList[jj];
					var frame:int =  FlashUtils.myParseFloat(xmlFrameLabel.attributes["i"]);
					var name:String =  xmlFrameLabel.attributes["name"];
					
					anim.frameLabels[jj] = name;
					anim.frameLabelsId[jj] = frame;
				}
			}*/
			
			
			
			var frameToMetaIdArray:Vector.<int> = new Vector.<int>();
			metaFrames = new Vector.<MetaMovieClipFrame>();
			
			anim.frameLabels = new Vector.<String>();
			anim.frameLabelsId = new Vector.<int>();
			for(var k:int = 0 ; k < xmlFramesList.length ; k++) {
				var xmlFrame:XMLNode = xmlFramesList[k];
				if(xmlFrame.nodeName == "FrameLabel") {
					var frame:int =  FlashUtils.myParseFloat(xmlFrame.attributes["i"]);
					var name:String =  xmlFrame.attributes["name"];
					
					anim.frameLabels.push(name);
					anim.frameLabelsId.push(frame);
					continue;
				}
				
				var xmlDisplayObjectList:Array = xmlFrame.childNodes;
				var numDisplayObjects:int = 0;
				if(xmlDisplayObjectList != null) {
					 numDisplayObjects = xmlDisplayObjectList.length ;
				} else {
					//continue;
				}
				
				var metaFrame:MetaMovieClipFrame ;
				if(numDisplayObjects > maxDisplayObjects) {
					maxDisplayObjects = numDisplayObjects;
				}
				
				metaFrame = new MetaMovieClipFrame();
				metaFrame.metaDisplayObjects = new Vector.<MetaDisplayObject>(numDisplayObjects);
				
				var boundsStr:String = xmlFrame.attributes["bounds"];
				if(boundsStr == null) {
					trace("no bounds " + className);
				} else {
					var aBounds:Array = boundsStr.split(",");
					metaFrame.bounds.x = FlashUtils.myParseFloat(aBounds[0]) ;
					metaFrame.bounds.y = FlashUtils.myParseFloat(aBounds[1]) ;
					metaFrame.bounds.width = FlashUtils.myParseFloat(aBounds[2]) ;
					metaFrame.bounds.height = FlashUtils.myParseFloat(aBounds[3]) ;
				}
				
				for(var l:int = 0 ; l < numDisplayObjects ; l++) {
					var d:MetaDisplayObject ;
					
					var xmlDisplayObject:XMLNode = xmlDisplayObjectList[l];
					var symbolInstanceName:String = xmlDisplayObject.attributes["name"];
					var symbolClassName:String = xmlDisplayObject.attributes["theClass"];
					
					var isTexture:Boolean = (xmlDisplayObject.attributes["isTexture"] == "1");
					
					var transform:String = xmlDisplayObject.attributes["transform"];
					var colorTransform:String = xmlDisplayObject.attributes["colorTransform"];
					
					var aTransform:Array = transform.split(",");
					var alpha:Number = FlashUtils.myParseFloat(xmlDisplayObject.attributes["alpha"]);
					var aColorTransform:Array = colorTransform.split(",");
					
					var row0:Vector4 ;
					var row1:Vector4 ;
											
					d = new MetaDisplayObject();
					
					
					if(symbolClassName == "TextField") {
						
						//var tf:MetaTextField = new MetaTextField();
						var textIdStr:String = xmlDisplayObject.attributes["textId"]; 
						d.text = xmlDisplayObject.attributes["text"];
						if(textIdStr == null || textIdStr == "")  {
							d.textId = "";
						} else {
							d.textId = textIdStr;
						}
						
						d.fontName = xmlDisplayObject.attributes["font"];
						d.width = FlashUtils.myParseFloat(xmlDisplayObject.attributes["w"]);
						d.height = FlashUtils.myParseFloat(xmlDisplayObject.attributes["h"]);
						d.textSize = FlashUtils.myParseFloat(xmlDisplayObject.attributes["size"]);
						d.textAlign = xmlDisplayObject.attributes["align"];
						d.hasShadow = xmlDisplayObject.attributes["hasShadow"] == "true";
						d.textLeading = FlashUtils.myParseFloat(xmlDisplayObject.attributes["leading"]);
						
						if(d.hasShadow) {
							d.shadowAngle = FlashUtils.myParseFloat(xmlDisplayObject.attributes["shadowAngle"]);
							d.shadowColor = FlashUtils.myParseFloat(xmlDisplayObject.attributes["shadowColor"]);
							d.shadowDistance = FlashUtils.myParseFloat(xmlDisplayObject.attributes["shadowDistance"]);
						}
						
						var color:uint = FlashUtils.myParseFloat(xmlDisplayObject.attributes["color"]);
						d.textColor = color;
						d.r = (((color >> 16) & 0xFF)+0.0)/255;
						d.g = (((color >> 8) & 0xFF)+0.0)/255;
						d.b = (((color >> 0) & 0xFF)+0.0)/255;
						//d.a = (((color >> 0) & 0xFF)+0.0)/255;
						
						
						//d.a = color >> 0;
						
						
						d.theClassId = -1;
					} else if(symbolClassName == "undefined") {
						trace("Undefined class");
						continue;
					} else if(isTexture) {
						var w:int = FlashUtils.myParseFloat(xmlDisplayObject.attributes["w"]);
						var h:int = FlashUtils.myParseFloat(xmlDisplayObject.attributes["h"]);
						var psFrame:int = FlashUtils.myParseFloat(xmlDisplayObject.attributes["frame"]);
						var isSingular:Boolean = (xmlDisplayObject.attributes["isSingular"] == "true");
	
						//var so:MetaShapeObject = new MetaShapeObject();
						d.theClassId = -1;
						d.prefabId = index;
						d.prefabName = "FlashPrefabs/" + docName;
						d.packedSpriteframe = psFrame;
						d.textureName = symbolClassName;
						d.width = w;
						d.height = h;
						var anchorX:int = FlashUtils.myParseFloat(xmlDisplayObject.attributes["aX"]);
						var anchorY:int = FlashUtils.myParseFloat(xmlDisplayObject.attributes["aY"]);
						d.anchorX = anchorX;
						d.anchorY = anchorY;
						d.isSingularTexture = isSingular;
						
						//(-1, _id, docName,  psFrame, w, h);
						//classId:int, pPrefabId:int, name:String, textureName:String, psFrame:int, w:int, h:int) {
						
					} else {
						
						//trace(symbolClassName + "/" + xmlDisplayObject.attributes["theClassId"]) ;
						d.theClassId = FlashUtils.myParseFloat(xmlDisplayObject.attributes["theClassId"]);
						if(d.theClassId == -1) {
							trace("WARNING unknown displayObject ignored : " + symbolClassName + "/" + docName + "/" + className);
							continue;
						}
					}
					
					
					d.theClassName = symbolClassName;
					d.name = symbolInstanceName;
					d.modelFla = this;
					
					row0 = new Vector4();
					row1 = new Vector4();
					row0.x = FlashUtils.myParseFloat(aTransform[0]) ;
					row0.y = FlashUtils.myParseFloat(aTransform[1]) ;
					row1.x = FlashUtils.myParseFloat(aTransform[2]) ;
					row1.y = FlashUtils.myParseFloat(aTransform[3]) ;
					row0.w = FlashUtils.myParseFloat(aTransform[4]) ;
					row1.w = FlashUtils.myParseFloat(aTransform[5]) ;
					
					d.transform = new Meta2DTransform();
					d.transform.LoadFromFromRows(row0, row1);
					var colorUint:uint = FlashUtils.myParseFloat(colorTransform);
					
					d.transform.colorTransform.r = FlashUtils.myParseFloat(aColorTransform[0]);
					d.transform.colorTransform.g = FlashUtils.myParseFloat(aColorTransform[1]);
					d.transform.colorTransform.b = FlashUtils.myParseFloat(aColorTransform[2]);
					d.transform.colorTransform.a = FlashUtils.myParseFloat(aColorTransform[3]);
					d.transform.colorTransform.alpha = alpha;
					/*d.transform.colorTransform.redOffset = FlashUtils.myParseFloat(aColorTransform[0]) ;
					d.transform.colorTransform.redMultiplier = FlashUtils.myParseFloat(aColorTransform[1]) ;
					d.transform.colorTransform.greenOffset = FlashUtils.myParseFloat(aColorTransform[2]) ;
					d.transform.colorTransform.greenMultiplier = FlashUtils.myParseFloat(aColorTransform[3]) ;
					d.transform.colorTransform.blueOffset = FlashUtils.myParseFloat(aColorTransform[4]) ;
					d.transform.colorTransform.blueMultiplier = FlashUtils.myParseFloat(aColorTransform[5]) ;
					d.transform.colorTransform.alphaOffset = FlashUtils.myParseFloat(aColorTransform[6]) ;
					d.transform.colorTransform.alphaMultiplier = FlashUtils.myParseFloat(aColorTransform[7]) ;
					*/
					metaFrame.metaDisplayObjects[l] = d;
				}	
				
				var iFrameStr:String = xmlFrame.attributes["i"];
				var numIdem:int = iFrameStr.split(",").length;
				
				for(var kk:int = 0 ; kk < numIdem ; kk++) {
					frameToMetaIdArray.push(k);
					metaFrames.push(metaFrame);
				}
			}
			
			anim.maxDisplayObjects = maxDisplayObjects;
			anim.metaMovieClipFrames = metaFrames ;	
			
			anim.stopOnEnter = new Vector.<Boolean>(frameToMetaIdArray.length);
			anim.frameToMetaId = new Vector.<int>(frameToMetaIdArray.length);
			var ii:int = 0 ; 
			for(ii = 0 ; ii < anim.stopOnEnter.length ; ii++) {
				anim.stopOnEnter[ii] = false;
				anim.frameToMetaId[ii] = frameToMetaIdArray[ii];
			}
			
			if(isButton) {
				//-2 because, it's start from 0, and we need to get back from 1 frame.
				anim.stopOnEnter[anim.GetFrame("down")-2] = true;
				anim.stopOnEnter[anim.GetFrame("over")-2] = true;
				anim.stopOnEnter[anim.GetFrame("out")-2] = true;
				if(anim.HasFrameLabel("selected")) {
					anim.stopOnEnter[anim.GetFrame("selected")-2] = true;
				}
				if(anim.HasFrameLabel("lock")) {
					anim.stopOnEnter[anim.GetFrame("lock")-2] = true;
				}
				if(anim.HasFrameLabel("locked")) {
					anim.stopOnEnter[anim.GetFrame("locked")-2] = true;
				}
				
				if(anim.HasFrameLabel("notbuy")) {
					anim.stopOnEnter[anim.GetFrame("notbuy")-2] = true;
				}
				
				anim.stopOnEnter[ii-1] = true;
			}
						
			return anim ;
		}
		
		public function isInit():Boolean {
			return (numTextures != -1);
		}
		
		static public function registerClassForSerialization():void {
			if(aliasesLoaded) return ;
			aliasesLoaded = true;
			registerClassAlias("String", String);
			registerClassAlias("Boolean", Boolean);
			registerClassAlias("Number", Number);
			registerClassAlias("int", int);
			registerClassAlias("com.lachhhStarling.ModelFlaEnum", ModelFlaEnum);
			registerClassAlias("com.berzerkstudio.ModelFla", ModelFla);
			registerClassAlias("com.lachhhStarling.format.ModelImageFormat", ModelImageFormat);
			registerClassAlias("com.lachhhStarling.format.ModelImageFormatEnum", ModelImageFormatEnum);
			registerClassAlias("com.lachhh.lachhhengine.meta.ModelBase;", ModelBase);
			registerClassAlias("com.berzerkstudio.flash.meta.MetaDisplayObject", MetaDisplayObject);
			registerClassAlias("com.berzerkstudio.flash.meta.Meta2DTransform", Meta2DTransform);
			registerClassAlias("com.berzerkstudio.flash.meta.Meta2DMatrix", Meta2DMatrix);
			registerClassAlias("com.berzerkstudio.flash.meta.MetaColorTransform", MetaColorTransform);
			registerClassAlias("com.berzerkstudio.flash.meta.MetaMovieClipFrame", MetaMovieClipFrame);
			registerClassAlias("com.berzerkstudio.flash.meta.MetaDisplayObjectContainer", MetaDisplayObjectContainer);
			registerClassAlias("com.berzerkstudio.flash.meta.MetaMovieClip", MetaMovieClip);
			registerClassAlias("com.berzerkstudio.flash.meta.MetaRectangle", MetaRectangle);
			registerClassAlias("com.berzerkstudio.flash.meta.ModelStarlingAnimation", ModelFlashAnimation);
			registerClassAlias("com.berzerkstudio.flash.meta.Matrix4x4", Matrix4x4);
			registerClassAlias("com.berzerkstudio.flash.meta.Vector4", Vector4);
		}
	}
}