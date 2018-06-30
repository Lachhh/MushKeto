package com.berzerkrpg.meta {
	/**
	 * @author LachhhSSD
	 */
	public class ModelPlatformTypeEnum {
		static public var ALL:Array = new Array();
				
		static public var NULL:ModelPlatformType = new ModelPlatformType(-1, "");
				
		static public var WEB:ModelPlatformType = create("web");
		static public var DESKTOP:ModelPlatformType = create("desktop");
		static public var MOBILE:ModelPlatformType = create("mobile");
		
		static public function create(id:String):ModelPlatformType {
			var m:ModelPlatformType = new ModelPlatformType(ALL.length, id);
			if(!getFromId(id).isNull) throw new Error("Duplicate ID!");
			ALL.push(m);
			return m;
		}
		
		static public function getFromId(id:String):ModelPlatformType {
			for (var i : int = 0; i < ALL.length; i++) {
				var g:ModelPlatformType = ALL[i] as ModelPlatformType;
				if(id == g.id) return g;
			}
			return NULL;
		} 
		
		static public function getFromIndex(index:int):ModelPlatformType {
			if(index >= ALL.length) return NULL;
			if(index < 0) return NULL;
			return ALL[index] as ModelPlatformType;
		}  
				
		static public function getNum():int {
			return ALL.length;
		}
	}
}
