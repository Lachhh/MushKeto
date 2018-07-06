package com.berzerkrpg.meta {
	import flash.utils.Dictionary;
	/**
	 * @author Lachhh
	 */
	public class MetaIngredientTemplate {
		public var metaIngredientGroup : MetaIngredientGroup = new MetaIngredientGroup();
		
		
		private var objData : Dictionary = new Dictionary();
		public function encode():Dictionary {
			objData["metaIngredientGroup"] = metaIngredientGroup.encode();
			return objData; 
		}
				
		public function decode(obj:Dictionary):void {
			if(obj == null) return ;
			metaIngredientGroup.decode(obj["metaIngredientGroup"]);
			metaIngredientGroup.sortNormal();
		}
	}
}