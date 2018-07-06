package com.berzerkrpg.meta {
	import com.lachhh.lachhhengine.IEncode;
	import com.lachhh.flash.FlashUtils;
	import flash.utils.Dictionary;
	/**
	 * @author Lachhh
	 */
	public class MetaRecipe implements IEncode {
		public var metaIngredientsGroup : MetaIngredientGroup = new MetaIngredientGroup();
		public var name : String;
		
		private var objData : Dictionary = new Dictionary();
		
		
		public function encode():Dictionary {
			objData["name"] = name;
			objData["metaIngredientsGroup"] = metaIngredientsGroup.encode();
			return objData; 
		}
				
		public function decode(obj:Dictionary):void {
			if(obj == null) return ;
			name = obj["name"];

			metaIngredientsGroup.decode(obj["metaIngredientsGroup"]);
		}

		public function getTotalOfTrait(m : ModelIngredientTrait) : Number {
			var result:Number = 0;
			for (var i : int = 0; i < metaIngredientsGroup.listIngredients.length; i++) {
				result += metaIngredientsGroup.listIngredients[i].getTotalOfTrait(m);
			}
			return result;
		}
		
		public function getTotalOfTraitStr(m : ModelIngredientTrait) : String {
			return getTotalOfTrait(m).toFixed(2);
		}

		public static function DEBUG_createDummy() : MetaRecipe {
			var result : MetaRecipe = new MetaRecipe();
			for (var i : int = 0; i < 15; i++) {
				result.metaIngredientsGroup.add(MetaIngredient.DEBUG_createDummy());
			}
			
			result.name = "Dummy " + Math.ceil(Math.random() * 999);
			return result;
		}

		public static function createFromDictionnary(d:Dictionary) : MetaRecipe {
			var result: MetaRecipe = new MetaRecipe();
			result.decode(d);
			return result;
		}

		
	}
}