package com.berzerkrpg.meta.devildeal {
	/**
	 * @author LachhhSSD
	 */
	public class ModelDevilDealEnum {
		static public var ALL:Array = new Array();
				
		static public var NULL:ModelDevilDeal = new ModelDevilDeal("", -1, "",  "");
				
		
		static public function create(id : String, frame : int,  trackerId : String, iconURL : String) : ModelDevilDeal {
			var m:ModelDevilDeal = new ModelDevilDeal(id, frame, trackerId, iconURL);
			if(!getFromId(id).isNull) throw new Error("Duplicate ID!");
			ALL.push(m);
			return m;
		}
		
		static public function getFromId(id:String):ModelDevilDeal {
			for (var i : int = 0; i < ALL.length; i++) {
				var g:ModelDevilDeal = ALL[i] as ModelDevilDeal;
				if(id == g.id) return g;
			}
			return NULL;
		} 
		
		static public function getFromIndex(index:int):ModelDevilDeal {
			if(index >= ALL.length) return NULL;
			if(index < 0) return NULL;
			return ALL[index] as ModelDevilDeal;
		}  
				
		static public function getNum():int {
			return ALL.length;
		}
	}
}
