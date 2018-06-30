package com.lachhhStarling.format {
	/**
	 * @author Eel
	 */
	public class ModelImageFormatEnum {
		
		public static var ALL:Array = new Array();
		
		public static var NULL:ModelImageFormat = new ModelImageFormat(-1, "", "");
		
		public static var PNG:ModelImageFormat = create("png", ".png");
		public static var ATF:ModelImageFormat = create("atf", ".atf");
		
		static public function create(id:String, extension:String):ModelImageFormat {
			var result:ModelImageFormat = new ModelImageFormat(ALL.length, id, extension);
			ALL.push(result);
			return result;
		}
		
		static public function getFromId(id:String):ModelImageFormat {
			for (var i : int = 0; i < ALL.length; i++) {
				var g:ModelImageFormat = ALL[i] as ModelImageFormat;
				if(id == g.id) return g;
			}
			return NULL;
		} 
		
		static public function getFromIndex(index:int):ModelImageFormat {
			if(index >= ALL.length) return NULL;
			if(index < 0) return NULL;
			return ALL[index] as ModelImageFormat;
		}
		
		static public function getNum():int {
			return ALL.length;
		}
		
	}
}