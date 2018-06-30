package com.berzerkrpg.multilingual {
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	/**
	 * @author LachhhSSD
	 */
	public class TextFactory {
		static public var CRNT_LANG : ModelLanguage = ModelLanguageEnum.ENGLISH;
		static public var dictOfVarName:Dictionary ;
		static public var dictOfVarNameByIndex : Dictionary ;
		
		static public var NULL:TextInstance = setEnText("");
		
		static public var TOTAL:TextInstance = setEnText("TOTAL");
		static public var GOAL:TextInstance = setEnText("GOAL");
		
		static public var YES:TextInstance = setEnText("yes");
		static public var NO:TextInstance = setEnText("no");
		static public var OK:TextInstance = setEnText("ok");
		
		static public var QUIT_GAME:TextInstance = setEnText("Save and Quit Game?");
		static public var ARMORGAMES_REFRESH_BROWSER:TextInstance = setEnText("Login on ArmorGames and refresh your browser!");
		static public var YAHOO_REFRESH_BROWSER:TextInstance = setEnText("Login on Yahoo and refresh your browser!");
		static public var NEWGROUNDS_REFRESH_BROWSER:TextInstance = setEnText("Login to your Newgrounds account and refresh your browser!");
		static public var TAP_TO_RESUME:TextInstance = setEnText("Tap to resume");
		
		static public var DELETE_RECIPE:TextInstance = setEnText("Are you sure you want to delete this '[x]' recipe? ");
		
		static public var CANCEL:TextInstance = setEnText("Cancel");
		static public var CONFIRM:TextInstance = setEnText("Confirm");
		
		static public var EDIT:TextInstance = setEnText("Edit");
		static public var DELETE:TextInstance = setEnText("Delete");
		
		static public var AUTO_BROWSE_RECIPE:TextInstance = setAutoEnText("AUTO_BROWSE_RECIPE", "Browse Recipe");
		static public var AUTO_ADD_RECIPE:TextInstance = setAutoEnText("AUTO_ADD_RECIPE", "Add Recipe");
		
		private static var _id : int = 0;

		public function TextFactory() {
			super();
		}
		
		static public function init():void {
			ModelLanguageEnum.allCopyFromEnglish();
			ModelLanguageEnum.HODOR.DEBUG_SetDummyText();
			
		}	
		
		static public function importLangFromCSV():void {
			for (var i : int = 0; i < ModelLanguageEnum.ALL.length; i++) {
				var m:ModelLanguage = ModelLanguageEnum.getFromIndex(i);
				m.decodeFromEmbeddedData();
			}
		}
			
		static public function getMsg(id:int):String {
			if(id <= -1) return "";
			return CRNT_LANG.getText(id);
		}
		
		static public function getMsgFromName(id:String):String {
			var txtInstance:TextInstance = findTextInstanceFromNameOfVar(id);
			if(txtInstance == null) return "";
			return txtInstance.getText();
		}
		
		static public function GetNextTextId():int {
			return _id++;
		}
		
		static public function setEnText(english:String):TextInstance {
			var result:int = _id++;
			ModelLanguageEnum.ENGLISH.addText(result, english);
			
			return new TextInstance(result);
		}
		
		
		static public function setAutoEnText(autoId:String, english:String):TextInstance {
			var result:int = _id++;
			ModelLanguageEnum.ENGLISH.addText(result, english);
			
			return new TextInstance(result);
		}
		
		static public function findVarNameFromId(index:int):String {
			if(dictOfVarName == null) createDict();
			var result:String = dictOfVarNameByIndex[index];
			return result;
		}
		
		static public function findTextInstanceFromNameOfVar(pNameOfVar:String):TextInstance {
			if(dictOfVarName == null) createDict();
			return dictOfVarName[pNameOfVar] as TextInstance;
		}
		
		static private function createDict():void {
			dictOfVarName = new Dictionary();
			dictOfVarNameByIndex = new Dictionary();
			var pClass:Class = TextFactory;
			var xml:XML = flash.utils.describeType(pClass);
			var varList:XMLList = xml..variable;
			var constList:XMLList = xml..constant;
			
			var nameOfVar:String;
			var textInstance:TextInstance;
			for(var i:int; i < varList.length(); i++){
				nameOfVar = varList[i].@name;
				textInstance = pClass[nameOfVar] as TextInstance;
				if(textInstance) {
					dictOfVarName[nameOfVar] = textInstance; 
					dictOfVarNameByIndex[textInstance.id] = nameOfVar;
				}
			}
			
			
			for(var j:int; j < constList.length(); j++){
				nameOfVar = constList[j].@name;
				textInstance = pClass[nameOfVar] as TextInstance;
				if(textInstance) {
					dictOfVarName[nameOfVar] = textInstance;
					dictOfVarNameByIndex[textInstance.id] = nameOfVar;
				}
			}
		}
	}
}
