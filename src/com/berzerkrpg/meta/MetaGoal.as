package com.berzerkrpg.meta {
	/**
	 * @author Lachhh
	 */
	public class MetaGoal {
		private var listTrait : Vector.<MetaIngredientTrait> = new Vector.<MetaIngredientTrait>();

		public function MetaGoal() {
			initTraits();
		}

		private function initTraits() : void {
			for (var i : int = 0; i < ModelIngredientTraitEnum.ALL.length; i++) {
				var newTrait : MetaIngredientTrait = createTrait(ModelIngredientTraitEnum.ALL[i]);
				listTrait.push(newTrait);
			}
		}
		
		private function createTrait(modelTrait:ModelIngredientTrait):MetaIngredientTrait {
			 var result:MetaIngredientTrait = new MetaIngredientTrait(0, modelTrait);
			 listTrait.push(result);
			 return result;
		}
		
		public function getTrait(modelTrait : ModelIngredientTrait) : MetaIngredientTrait {
			for (var i : int = 0; i < listTrait.length; i++) {
				if(listTrait[i].modelIngredientTrait.isEquals(modelTrait)) return listTrait[i];
			}
			return null;
		}

		public function getValueOfTrait(modelTrait : ModelIngredientTrait) : Number {
			return getTrait(modelTrait).value;
		}
		
		public function setValueOfTrait(value:Number, modelTrait : ModelIngredientTrait) : Number {
			return getTrait(modelTrait).value = value;
		}
	
	}
}