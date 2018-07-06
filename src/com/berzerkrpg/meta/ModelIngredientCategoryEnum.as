package com.berzerkrpg.meta {
	import com.berzerkrpg.multilingual.TextInstance;
	import com.berzerkrpg.multilingual.TextFactory;
	/**
	 * @author Lachhh
	 */
	public class ModelIngredientCategoryEnum {
		static public var ALL:Vector.<ModelIngredientCategory> = new Vector.<ModelIngredientCategory>() ; 
					
		static public var NULL:ModelIngredientCategory = new ModelIngredientCategory(-1, "", TextFactory.NULL);
		
		static public var FOOD_ALL:ModelIngredientCategory = create("all", TextFactory.FOOD_CATEGORY_ALL);
				
		static public var FOOD_CARBS:ModelIngredientCategory = create("foodCarbs", TextFactory.FOOD_CATEGORY_CARBS);
		static public var FOOD_CREAM:ModelIngredientCategory = create("cream", TextFactory.FOOD_CATEGORY_CREAM);
		static public var FOOD_FAT:ModelIngredientCategory = create("fat", TextFactory.FOOD_CATEGORY_FAT);
		static public var FOOD_MISC:ModelIngredientCategory = create("misc", TextFactory.FOOD_CATEGORY_MISC);
		static public var FOOD_PROTEIN:ModelIngredientCategory = create("protein", TextFactory.FOOD_CATEGORY_PROTEIN);
		static public var FOOD_WATER:ModelIngredientCategory = create("water", TextFactory.FOOD_CATEGORY_WATER);
		
		static public function create(id : String, name : TextInstance) : ModelIngredientCategory {
			var m : ModelIngredientCategory = new ModelIngredientCategory(ALL.length, id, name);
			if (!getFromId(id).isNull) throw new Error("Duplicate ID!");
			ALL.push(m);
			return m;
		}
		
		static public function getFromId(id:String):ModelIngredientCategory {
			for (var i:int = 0; i < ALL.length; i++) {
				var g:ModelIngredientCategory = ALL[i] as ModelIngredientCategory;
				if(id == g.id) return g;
			}
			return NULL;
		} 
		
		static public function getFromIndex(index:int):ModelIngredientCategory {
			if(index >= ALL.length) return NULL;
			if(index < 0) return NULL;
			return ALL[index] ;
		}  
				
		static public function getNum():int {
			return ALL.length;
		}
		
		static public function pickRandom():ModelIngredientCategory {
			return ALL[Math.floor(Math.random()*ALL.length)];
		} 
	}
}