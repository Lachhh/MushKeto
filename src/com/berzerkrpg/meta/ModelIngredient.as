package com.berzerkrpg.meta {
	import com.lachhh.lachhhengine.meta.ModelBase;

	/**
	 * @author Lachhh
	 */
	public class ModelIngredient extends ModelBase {
		private var listTrait : Vector.<MetaIngredientTrait> = new Vector.<MetaIngredientTrait>();
		public var name : String;

		public function ModelIngredient(pIndex : int, pId : String, name : String, proCarb : Number, ratio : Number, protein : Number, fat : Number, carb : Number, fiber : Number, cal : Number) {
			super(pIndex, pId);
			this.name = name;
			initTraits();
			
			setValueOfTrait(proCarb, ModelIngredientTraitEnum.PRO_CARB);
			setValueOfTrait(ratio, ModelIngredientTraitEnum.RATIO);
			setValueOfTrait(protein, ModelIngredientTraitEnum.PROTEIN);
			setValueOfTrait(fat, ModelIngredientTraitEnum.FAT);
			setValueOfTrait(carb, ModelIngredientTraitEnum.CARB);
			setValueOfTrait(fiber, ModelIngredientTraitEnum.FIBER);
			setValueOfTrait(cal, ModelIngredientTraitEnum.CAL);
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
		
		private function setValueOfTrait(value:Number, modelTrait : ModelIngredientTrait) : Number {
			return getTrait(modelTrait).value = value;
		}
	}
}