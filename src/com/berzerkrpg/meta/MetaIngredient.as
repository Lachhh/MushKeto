package com.berzerkrpg.meta {
	import com.lachhh.flash.FlashUtils;
	import com.lachhh.lachhhengine.IEncode;
	import com.lachhh.utils.Utils;

	import flash.utils.Dictionary;
	/**
	 * @author Lachhh
	 */
	public class MetaIngredient implements IEncode {
		private static const DEBUG_NAME : Array = ["Beer", "Cocaine", "Fantanyl", "LSD", "The weird kind of drug"];
		public var modelCategory : ModelIngredientCategory;
		public var metaIngredientTraits : MetaIngredientTraitGroup = new MetaIngredientTraitGroup();
		public var qty : int;
		private var _name : String;
		private var _nameLower : String;
		public var isFavorite : Boolean = false;
		public var toAddInRecipe : Boolean = false;
		private var objData : Dictionary = new Dictionary();

		public function MetaIngredient(qty:int) {
			this.qty = qty;
			modelCategory = ModelIngredientCategoryEnum.NULL;
		}

		public function encode() : Dictionary {
			
			objData["name"] = name;
			objData["modelCategory"] = modelCategory.id;
			objData["metaIngredientTraits"] = metaIngredientTraits.encode();
			objData["qty"] = qty;
			objData["isFavorite"] = isFavorite+"";
			
			return objData; 
		}
				
		public function decode(obj:Dictionary):void {
			if (obj == null) return ;
			metaIngredientTraits.decode(obj["metaIngredientTraits"]);
			modelCategory = ModelIngredientCategoryEnum.getFromId(obj["modelCategory"]);
			qty = obj["qty"];
			name = obj["name"];
			isFavorite = FlashUtils.myParseBool(obj["isFavorite"]);
		}
		
		public function getTotalOfTrait(modelTrait:ModelIngredientTrait):Number{
			return metaIngredientTraits.getValueOfTrait(modelTrait)*qty;
		}

		public static function createFromDictionnary(objData : Dictionary) : MetaIngredient {
			var result : MetaIngredient = new MetaIngredient(0);
			result.decode(objData);
			return result;
		}

		public function qtyStr() : String {
			return qty+"";
		}

		public function getTotalOfTraitStr(m : ModelIngredientTrait) : String {
			return getTotalOfTrait(m).toFixed(2);
		}
		
		public function isOfCategory(m:ModelIngredientCategory):Boolean {
			if(m.isAll()) return true;
			return modelCategory.isEquals(m);
		}

		public static function DEBUG_createDummy() : MetaIngredient {
			var result:MetaIngredient = new MetaIngredient(0);
			result.name = Utils.pickRandomInArray(DEBUG_NAME) as String;
			result.qty = Math.random() * 10 + 1;
			result.modelCategory = ModelIngredientCategoryEnum.pickRandom();
			result.metaIngredientTraits.DEBUG_Randomize();
			return result;
		}

		public static function DEBUG_createDummyList() : Vector.<MetaIngredient> {
			var result:Vector.<MetaIngredient> = new Vector.<MetaIngredient>();
			for (var i : int = 0; i < 15; i++) {
				result.push(DEBUG_createDummy());
			}
			return result;
		}

		static public function createListFromStr(modelCategory : ModelIngredientCategory, str : String) : Vector.<MetaIngredient> {
			var result : Vector.<MetaIngredient> = new Vector.<MetaIngredient>();
			var list : Array = str.split("\n");
			for (var i : int = 0; i < list.length; i++) {
				var newIngredient : MetaIngredient = MetaIngredient.createFromStr(list[i] as String);
				if (newIngredient == null) continue;
				newIngredient.modelCategory = modelCategory;
				result.push(newIngredient);
			}
			return result;
		}

		public static function createFromStr(string : String) : MetaIngredient {
			var result:MetaIngredient = new MetaIngredient(1);
			var properties:Array = string.split("\t");
			if(properties.length < 6) return null;
			
			result.name = properties[0];
			result.metaIngredientTraits.getTrait(ModelIngredientTraitEnum.PROTEIN).value = FlashUtils.myParseFloat(properties[1]);
			result.metaIngredientTraits.getTrait(ModelIngredientTraitEnum.FAT).value = FlashUtils.myParseFloat(properties[2]);
			result.metaIngredientTraits.getTrait(ModelIngredientTraitEnum.CARB).value = FlashUtils.myParseFloat(properties[3]);
			result.metaIngredientTraits.getTrait(ModelIngredientTraitEnum.FIBER).value = FlashUtils.myParseFloat(properties[4]);
			result.metaIngredientTraits.getTrait(ModelIngredientTraitEnum.CAL).value = FlashUtils.myParseFloat(properties[5]);
			
			return result;
		}

		public function get name() : String {return _name;}
		public function set name(name : String) : void {
			_name = name;
			_nameLower = this.name.toLowerCase();
		}
		
		public function get nameLowerCase() : String {
			return _nameLower;
		}

		public function isEquals(mi : MetaIngredient) : Boolean {
			if(name != mi.name) return false;
			if(!metaIngredientTraits.isEquals(mi.metaIngredientTraits)) return false;
			return true;
		}
		
	}
}