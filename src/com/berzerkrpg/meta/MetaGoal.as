package com.berzerkrpg.meta {
	import flash.utils.Dictionary;
	/**
	 * @author Lachhh
	 */
	public class MetaGoal {
		public var metaGoalTrait : MetaIngredientTraitGroup = new MetaIngredientTraitGroup();
		private var objData : Dictionary = new Dictionary();

		public function MetaGoal() {
			metaGoalTrait.DEBUG_Randomize();
		}

		
		public function encode():Dictionary {
			objData["metaGoalTrait"] = metaGoalTrait.encode();
			return objData; 
		}
				
		public function decode(obj:Dictionary):void {
			if(obj == null) return ;
			metaGoalTrait.decode(obj["metaGoalTrait"]);
		}
	
	}
}