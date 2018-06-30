package com.berzerkrpg.meta {
	/**
	 * @author Lachhh
	 */
	public class MetaIngredientTrait {
		public var modelIngredientTrait : ModelIngredientTrait;
		public var value : Number = 0;
		

		public function MetaIngredientTrait(value : Number, modelIngredientTrait : ModelIngredientTrait) {
			this.value = value;
			this.modelIngredientTrait = modelIngredientTrait; 
		}
	}
}