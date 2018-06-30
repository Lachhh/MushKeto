package com.berzerkrpg.meta.resolution {
	/**
	 * @author Eel
	 */
	public class ModelResolutionEnum {
		
		public static var ALL:Array = new Array();
		
		public static var NULL:ModelResolution = new ModelResolution("", 960, 640);
		
		public static var res640x360:ModelResolution = create("640x360", 640, 360);
		public static var res800x450:ModelResolution = create("800x450", 800, 450);
		public static var res1136x640:ModelResolution = create("1136x640", 1136, 640);
		public static var res1280x720:ModelResolution = create("1280x720", 1280, 720);
		public static var res1366x768:ModelResolution = create("1366x768", 1366, 768);
		public static var res1600x900:ModelResolution = create("1600x900", 1600, 900);
		public static var res1920x1080:ModelResolution = create("1920x1080", 1920, 1080);
		
		public static function create(id:String, width:Number, height:Number):ModelResolution{
			if(!getFromId(id).isNull) throw new Error("DUPLICATE ID");
			var result:ModelResolution = new ModelResolution(id, width, height);
			ALL.push(result);
			return result;
		}
		
		public static function getFromIndex(i:int):ModelResolution{
			if(i < 0 || i >= ALL.length) return NULL;
			return ALL[i];
		}
		
		public static function getFromId(id:String):ModelResolution{
			for(var i:int = 0; i < ALL.length; i++){
				var model:ModelResolution = ALL[i];
				if(model.id == id) return model;
			}
			return NULL;
		}
		
		public static function getIndex(pModel:ModelResolution):int{
			for(var i:int = 0; i < ALL.length; i++){
				var model:ModelResolution = ALL[i];
				if(model.isEquals(pModel)) return i;
			}
			return -1;
		}
		
		public static function getPrev(pModel:ModelResolution):ModelResolution{
			var index:int = getIndex(pModel);
			var result:ModelResolution = getFromIndex(index-1);
			if(result.isNull) return getFromIndex(ALL.length-1);
			return result;
		}
		
		public static function getNext(pModel:ModelResolution):ModelResolution{
			var index:int = getIndex(pModel);
			var result:ModelResolution = getFromIndex(index+1);
			if(result.isNull) return getFromIndex(0);
			return result;
		}
		
	}
}