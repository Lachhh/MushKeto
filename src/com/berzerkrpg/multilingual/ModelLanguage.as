package com.berzerkrpg.multilingual {
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.meta.ModelBase;

	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;

	/**
	 * @author LachhhSSD
	 */
	public class ModelLanguage extends ModelBase {
		private static var aliasesLoaded : Boolean = false;
		public var crowdInId:String = "";
		public var texts : Vector.<String> = new Vector.<String>();
		public var fullName : String = "engligh";
		public var translationBy:String = "";
		public var useNotoFont:Boolean = false;
		
		public var embeddedCSVClass:Class = null;
		
		public function ModelLanguage(pIndex:int, pId : String, pCrowdInId:String, pFullName:String) {
			super(pIndex, pId);
			crowdInId = pCrowdInId;
			fullName = pFullName;
		}
		
		public function saveToByteArray():ByteArray{
			var csvClassTemp:Class = embeddedCSVClass;
			embeddedCSVClass = null; 
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject(this);
			embeddedCSVClass = csvClassTemp;
			return bytes;
		}
		
		public function loadFromByteArray(data:ByteArray):void{
			var langObj:Object = data.readObject();
			
			this.texts = langObj["texts"];
			this.fullName = langObj["fullName"];
			this.translationBy = langObj["translationBy"];
		}
		
		public function addText(id:int, str:String):void {
			texts[id] = str;
		}
		
		public function copyFrom(modelLanguage:ModelLanguage):void {
			texts = modelLanguage.texts.slice();
		}
		
		public function DEBUG_SetDummyText():void {
			var numEmntries:int = ModelLanguageEnum.ENGLISH.texts.length;
			var msgDummy:String = "Hodor";
			for (var i : int = 0; i < numEmntries; i++) {
				if(i < texts.length) {
					addText(i, msgDummy);
				}
			}
		}
				
		public function getText(id:int):String {
			if(!hasTextAt(id)) return "";
			return texts[id] ;
		}
		
		public function hasTextAt(id:int):Boolean {
			if(id < 0) return false;
			if(id >= texts.length) return false;
			return true;
		}
				
		public function ExportInCSV():String {
			var result:String = "" ;
			for (var i : int = 0;i < texts.length; i++) {
				if(!haveText(i)) continue;
				var text:String = getText(i).split("\n").join("\\n").split("\"").join("'");
				text = text.split("\r").join("\\n");
				var nameOfVar:String = TextFactory.findVarNameFromId(i);
				var id:String = i+""; 
				result += (id + "," + nameOfVar + ",\"" +  text + "\"\n");
			}
			result += "";
			 
			return result;
		}
				
		public function tryToUpdateFromCSV(encodedCSV:String):Boolean {
			var valid:Boolean = true;
			try {
				DecodeFromCSV(encodedCSV);
				useNotoIfForeignCharUsed();
			} catch (e:Error) {
				valid = false;
			}
			return valid;
		}
		
		public function tryToDecodeFromCSV(encodedCSV:String):Boolean {
			var valid:Boolean = true;
			try {
				DecodeFromCSV(encodedCSV);
			} catch (e:Error) {
				valid = false;
			}
			return valid;
		}
		
		private function useNotoIfForeignCharUsed():void {
			useNotoFont = false;
			for (var i : int = 0; i < texts.length; i++) {
				if(checkIfStringHasForeignChars(getText(i))) {
					useNotoFont = true;
					return ;
				}
			}
		}
		 
		
		public function DecodeFromCSV(encodedCSV:String):void {
			var entry : Array = encodedCSV.split("\n");
			
			for (var i : int = 0;i < entry.length; i++) {
				var entryRawData:String = entry[i];
				var entryParams:Array = entryRawData.split("\",\"");
				//var id:int = FlashUtils.myParseFloat(entryParams.shift());
				var idName:String = entryParams.shift();
				var varName:String = entryParams.shift();
				var englishValue:String = entryParams.shift();
				//var hasQuotes:Boolean = (entryParams.length >= 2);
				var value:String = entryParams.join(",");
				
				value = value.split("\n").join("");
				value = value.split("\r").join("");
				
				value = value.split("\\n").join("\n");
				value = value.split("\\r").join("\r");
				
				value = value.substring(0, value.length-1);
				//if(hasQuotes) value = removeQuotes(value);
				
				/*value = value.substring(1, value.length);
				value = value.substring(0, value.length-2);*/
				var txtInstance:TextInstance = TextFactory.findTextInstanceFromNameOfVar(varName);
				if(txtInstance != null) {
					addText(txtInstance.id, value);
				}
			} 
		}
		
		private function checkIfStringHasForeignChars(str:String):Boolean {
			for (var i : int = 0; i < str.length; i++) {
				var charCode:Number = str.charCodeAt(i);
				if(charCode >= 10000) return true;
			}
			return false;
		}
				
		public function decodeFromEmbeddedData():void {
			if(embeddedCSVClass) decodeFromCSVClass();
		}
		
		public function decodeFromCSVClass():void {
			if(embeddedCSVClass == null) return ;
			var value:String = classToCSV(embeddedCSVClass);
			DecodeFromCSV(value);
		}
		
		private function classToCSV(pClass:Class):String {
			var file:ByteArray = new pClass();
			var str:String = file.readUTFBytes( file.length );
			return str;
		}	
		
		private function classToXML(pClass:Class):XML {
			var file:ByteArray = new pClass();
			var str:String = file.readUTFBytes( file.length );
			return new XML( str );
		}		
		
		public function haveText(i:int):Boolean {
			if(i < 0) return false;
			if(i >= texts.length) return false;
			return (texts[i] != null) ;
		}
				
		public function isVisible():Boolean {
			if(isNull) return false;
			if(id == ModelLanguageEnum.EXPORTED.id && VersionInfo.modelPlatform.isMobile()) return false;
			if(id == ModelLanguageEnum.EXPORTED.id && !VersionInfo.showExportingLanguage) return false;
			
			if(id == ModelLanguageEnum.JAPANESE.id ) return false;
			
			return true;
		}
		
		public function hasToBeAddedToSpecialThanks():Boolean {
			if(!isVisible()) return false;
			return translationBy != ""; 
		}
		
		public function getSpecialThanksText():String {
			return getEnglishName().toUpperCase() + " BY\n" + translationBy; 
		}
		
		public function getEnglishName():String {
			if(id == ModelLanguageEnum.CHINESE.id) return "Chinese";
			if(id == ModelLanguageEnum.JAPANESE.id) return "Japanese";
			return fullName;
		}
		
		static public function registerClassForSerialization():void {
			if(aliasesLoaded) return ;
			aliasesLoaded = true;
			registerClassAlias("String", String);
			//registerClassAlias("com.berzerkstudio.ModelLanguage", ModelLanguage);
			//registerClassAlias("com.lachhh.lachhhengine.meta.ModelBase;", ModelBase);
		}
	}
}
