package com.berzerkrpg.meta {
	import com.lachhh.lachhhengine.IEncode;
	import flash.utils.Dictionary;
	/**
	 * @author Lachhh
	 */
	public class MetaIngredient implements IEncode {
		public var modelIngredient : ModelIngredient;
		public var qty : int;
		private var objData : Dictionary = new Dictionary();

		public function MetaIngredient(qty:int, modelIngredient:ModelIngredient) {
			this.qty = qty;
			this.modelIngredient = modelIngredient; 
		}

		public function encode() : Dictionary {
			objData["modelIngredient"] = modelIngredient.id;
			objData["qty"] = qty;
			return objData; 
		}
				
		public function decode(obj:Dictionary):void {
			if (obj == null) return ;
			modelIngredient = ModelIngredientEnum.getFromId(obj["modelIngredient"]);
			qty = obj["qty"];
		}
		
		public function getTotalOfTrait(modelTrait:ModelIngredientTrait):Number{
			return modelIngredient.getValueOfTrait(modelTrait)*qty;
		}

		public static function createFromDictionnary(objData : Dictionary) : MetaIngredient {
			var result : MetaIngredient = new MetaIngredient(0, ModelIngredientEnum.NULL);
			result.decode(objData);
			return result;
		}

		public function qtyStr() : String {
			return qty+"";
		}

		public function getTotalOfTraitStr(m : ModelIngredientTrait) : String {
			return getTotalOfTrait(m)+"";
		}

		public static function DEBUG_createDummy() : MetaIngredient {
			var result:MetaIngredient = new MetaIngredient(0, ModelIngredientEnum.INGREDIENT_1);
			result.qty = Math.random()*10+1;
			result.modelIngredient = ModelIngredientEnum.pickRandom();
			return result;
		}
	}
}