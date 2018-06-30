package com.berzerkrpg.meta {
	/**
	 * @author Lachhh
	 */
	public class ModelIngredientTraitEnum {
		static public var ALL:Vector.<ModelIngredientTrait> = new Vector.<ModelIngredientTrait>() ; 
					
		static public var NULL:ModelIngredientTrait = new ModelIngredientTrait(-1, "");
				
		static public var PRO_CARB:ModelIngredientTrait = create("proCarb");
		static public var RATIO:ModelIngredientTrait = create("ratio");
		static public var PROTEIN:ModelIngredientTrait = create("protein");
		static public var FAT:ModelIngredientTrait = create("fat");
		static public var CARB:ModelIngredientTrait = create("carb");
		static public var FIBER:ModelIngredientTrait = create("fiber");
		static public var CAL:ModelIngredientTrait = create("cal");
		
		static public function create(id:String):ModelIngredientTrait {
			var m:ModelIngredientTrait = new ModelIngredientTrait(ALL.length, id);
			if(!getFromId(id).isNull) throw new Error("Duplicate ID!");
			ALL.push(m);
			return m;
		}
		
		static public function getFromId(id:String):ModelIngredientTrait {
			for (var i:int = 0; i < ALL.length; i++) {
				var g:ModelIngredientTrait = ALL[i] as ModelIngredientTrait;
				if(id == g.id) return g;
			}
			return NULL;
		} 
		
		static public function getFromIndex(index:int):ModelIngredientTrait {
			if(index >= ALL.length) return NULL;
			if(index < 0) return NULL;
			return ALL[index] ;
		}  
				
		static public function getNum():int {
			return ALL.length;
		}
		
		static public function pickRandom():ModelIngredientTrait {
			return ALL[Math.floor(Math.random()*ALL.length)];
		} 
	}
}