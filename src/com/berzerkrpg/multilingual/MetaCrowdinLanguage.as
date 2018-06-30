package com.berzerkrpg.multilingual {
	/**
	 * @author Eel
	 */
	public class MetaCrowdinLanguage {
		
		public var name:String = "null";
		public var id:String = "";
		public var translatedProgress:Number = 0;
		
		public function MetaCrowdinLanguage(pId:String, pName:String, progress:Number){
			name = pName;
			id = pId;
			translatedProgress = progress;
		}
		
		public static function createFromJson(json:Object):MetaCrowdinLanguage{
			var name:String = json["name"];
			var id:String = json["code"];
			var translatedProgress:Number = json["translated_progress"];
			
			return new MetaCrowdinLanguage(id, name, translatedProgress);
		}
		
		public function get isAvailable():Boolean{ return translatedProgress >= 75; }
		
	}
}