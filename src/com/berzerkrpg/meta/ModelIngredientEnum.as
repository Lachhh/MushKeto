package com.berzerkrpg.meta {
	/**
	 * @author Lachhh
	 */
	public class ModelIngredientEnum {
		static public var ALL:Vector.<ModelIngredient> = new Vector.<ModelIngredient>() ;
		
		 
					
		static public var NULL:ModelIngredient = new ModelIngredient(-1, "", "", 0,0,0,0,0,0,0);
				
		static public var INGREDIENT_1:ModelIngredient = create("ing1", "Mayonaise", 1,1,1,1,1,1,1);
		static public var INGREDIENT_2:ModelIngredient = create("ing2", "Peanut Butter", 2,2,2,2,2,2,2);
		
		
		static public var ALL_METAS : Vector.<MetaIngredient> = createMetas() ;

		private static function createMetas() : Vector.<MetaIngredient> {
			var result:Vector.<MetaIngredient> = new Vector.<MetaIngredient>();
			for (var i : int = 0; i < ALL.length; i++) {
				result.push(new MetaIngredient(1, ALL[i]));
			}
			return result;
		}

		static public function create(id : String, name : String, proCarb : Number, ratio : Number, protein : Number, fat : Number, carb : Number, fiber : Number, cal : Number) : ModelIngredient {
			var m:ModelIngredient = new ModelIngredient(ALL.length, id, name, proCarb, ratio, protein, fat, carb, fiber, cal) ;
			if(!getFromId(id).isNull) throw new Error("Duplicate ID!");
			ALL.push(m);
			return m;
		}
		
		static public function getFromId(id:String):ModelIngredient {
			for (var i:int = 0; i < ALL.length; i++) {
				var g:ModelIngredient = ALL[i] as ModelIngredient;
				if(id == g.id) return g;
			}
			return NULL;
		} 
		
		static public function getFromIndex(index:int):ModelIngredient {
			if(index >= ALL.length) return NULL;
			if(index < 0) return NULL;
			return ALL[index] ;
		}  
				
		static public function getNum():int {
			return ALL.length;
		}
		
		static public function pickRandom():ModelIngredient {
			return ALL[Math.floor(Math.random()*ALL.length)];
		} 
	}
}