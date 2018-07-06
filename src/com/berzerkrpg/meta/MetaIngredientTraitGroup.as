package com.berzerkrpg.meta {
	import flash.utils.Dictionary;
	/**
	 * @author Lachhh
	 */
	public class MetaIngredientTraitGroup  {
		private var listTrait : Vector.<MetaIngredientTrait> = new Vector.<MetaIngredientTrait>();
		private var objData : Dictionary = new Dictionary();
		
		public function MetaIngredientTraitGroup() {
			initTraits();
		}
		
		
		public function encode():Dictionary {
			for (var i : int = 0; i < listTrait.length; i++) {
				objData[listTrait[i].modelIngredientTrait.id] = listTrait[i].value;	
			}
			
			return objData; 
		}
				
		public function decode(obj:Dictionary):void {
			if(obj == null) return ;
			
			for (var i : int = 0; i < listTrait.length; i++) {
				setValueOfTraitWithDict(obj, listTrait[i].modelIngredientTrait);
			}
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
		
		public function setValueOfTrait(value:Number, modelTrait : ModelIngredientTrait) : void {
			getTrait(modelTrait).value = value;
		}
		
		private function setValueOfTraitWithDict(d:Dictionary, modelTrait : ModelIngredientTrait) : void {
			if(d == null) return;
			if(d[modelTrait.id] == null) return;
			var value:Number = d[modelTrait.id];
			setValueOfTrait(value, modelTrait);
		}
		
		static public function createWithDictionnary(d:Dictionary):MetaIngredientTraitGroup {
			var result:MetaIngredientTraitGroup = new MetaIngredientTraitGroup();
			result.decode(d);
			return result;
		}

		public function DEBUG_Randomize() : void {
			for (var i : int = 0; i < listTrait.length; i++) {
				listTrait[i].DEBUG_randomize();
			}			
		}

		public function isEquals(mi : MetaIngredientTraitGroup) : Boolean {
			for (var i : int = 0; i < listTrait.length; i++) {
				if(!listTrait[i].isEquals(mi.getTrait(listTrait[i].modelIngredientTrait))) return false;
			}
			return true;
		}
	}
}