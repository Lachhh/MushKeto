package com.berzerkrpg.meta {
	import com.berzerkrpg.multilingual.TextInstance;
	import com.lachhh.lachhhengine.meta.ModelBase;

	/**
	 * @author Lachhh
	 */
	public class ModelIngredientCategory extends ModelBase {
		public var name : TextInstance;
		

		public function ModelIngredientCategory(pIndex : int, pId : String, name : TextInstance) {
			super(pIndex, pId);
			this.name = name;
			
		}
		
		public function getFrame():int {
			return index+1;
		}

		public function isAll() : Boolean {
			return isEquals(ModelIngredientCategoryEnum.FOOD_ALL);
		}
	}
}