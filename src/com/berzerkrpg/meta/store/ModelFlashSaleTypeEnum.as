package com.berzerkrpg.meta.store {
	/**
	 * @author Eel
	 */
	public class ModelFlashSaleTypeEnum {
		
		public static var ALL:Array = new Array();
		
		public static var NULL:ModelFlashSaleType = new ModelFlashSaleType("", 1);
		
		public static var PRCT_75_OFF:ModelFlashSaleType = create("75prct", 0.75);
		public static var PRCT_50_OFF:ModelFlashSaleType = create("50prct", 0.50);
		public static var PRCT_25_OFF:ModelFlashSaleType = create("25prct", 0.25);
		
		public static function create(id:String, prct:Number):ModelFlashSaleType{
			if(!getFromId(id).isNull) throw new Error("Duplicate ID!");
			var result:ModelFlashSaleType = new ModelFlashSaleType(id, prct);
			ALL.push(result);
			return result;
		}
		
		public static function getFromId(id:String):ModelFlashSaleType{
			for (var i : int = 0; i < ALL.length; i++) {
				var g:ModelFlashSaleType = ALL[i] as ModelFlashSaleType;
				if(id == g.id) return g;
			}
			return NULL;
		}
		
	}
}