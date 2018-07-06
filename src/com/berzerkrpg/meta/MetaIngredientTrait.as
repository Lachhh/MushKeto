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

		public function DEBUG_randomize() : void {
			var cent:int = Math.random()*10000;
			value = cent*0.01;
			value.toFixed(2);
		}
		
		public function getValueStr():String {
			return value.toFixed(2);
		}

		public function isEquals(m : MetaIngredientTrait) : Boolean {
			if(value != m.value) return false;
			return true;
		}
	}
}