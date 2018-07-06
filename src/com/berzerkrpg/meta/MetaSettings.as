package com.berzerkrpg.meta {
	import flash.utils.Dictionary;
	/**
	 * @author Lachhh
	 */
	public class MetaSettings {
		private var objData : Dictionary = new Dictionary();
		
		public var metaGoal : MetaGoal = new MetaGoal();
		
		public var metaIngradientTemplate : MetaIngredientTemplate = new MetaIngredientTemplate();

		public function MetaSettings() {
			
		}
		
		public function encode():Dictionary {
			objData["metaGoal"] = metaGoal.encode();
			objData["metaIngradientTemplate"] = metaIngradientTemplate.encode();
			return objData; 
		}
				
		public function decode(obj:Dictionary):void {
			if(obj == null) return ;
			metaGoal.decode(obj["metaGoal"]);
			metaIngradientTemplate.decode(obj["metaIngradientTemplate"]);
			
		}
	}
}