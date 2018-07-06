package com.berzerkrpg.meta {
	import com.lachhh.flash.FlashUtils;
	import com.lachhh.lachhhengine.IEncode;

	import flash.utils.Dictionary;
	/**
	 * @author Lachhh
	 */
	public class MetaIngredientGroup {
		private var objData : Dictionary = new Dictionary();
		public var listIngredients : Vector.<MetaIngredient> = new Vector.<MetaIngredient>();

		public function MetaIngredientGroup() {
			
		}
		
		
		public function encode():Dictionary {
			objData["listIngredients"] = FlashUtils.encodeList(Vector.<IEncode>(listIngredients));
			return objData; 
		}
				
		public function decode(obj:Dictionary):void {
			if(obj == null) return ;
			var list : Vector.<IEncode> = FlashUtils.decodeList(obj["listIngredients"], MetaIngredient.createFromDictionnary);
			listIngredients = Vector.<MetaIngredient>(list);
		}

		public function replaceCategory(modelCategory : ModelIngredientCategory, list : Vector.<MetaIngredient>) : void {
			removeAllOfCategory(modelCategory);
			addBatch(list);
		}
		
		public function removeAllOfCategory(model : ModelIngredientCategory) : void {
			var allOfCategory : Vector.<MetaIngredient> = appendAllOfCategory(model, new Vector.<MetaIngredient>());
			removeBatch(allOfCategory);
		}

		public function appendAllOfCategory(modelCategory : ModelIngredientCategory, output : Vector.<MetaIngredient>) : Vector.<MetaIngredient> {
			for (var i : int = 0; i < listIngredients.length; i++) {
				if(!listIngredients[i].isOfCategory(modelCategory)) continue;
				output.push(listIngredients[i]);
			}
			return output;
		}
		
		public function removeBatch(listToRemove:Vector.<MetaIngredient>):void {
			for (var i : int = 0; i < listToRemove.length; i++) {
				var mi : MetaIngredient = listToRemove[i];
				remove(mi);
			}
		}

		private function remove(mi : MetaIngredient) : void {
			var index:int = listIngredients.indexOf(mi);
			if(index == -1) return;
			listIngredients.splice(index, 1);
		}
		
		public function add(mi : MetaIngredient) : void {
			var sameIngredient : MetaIngredient = getEqualIngredient(mi);
			if(sameIngredient == null) {
				listIngredients.push(mi);	
			} else {
				sameIngredient.qty++;
			}
			
		}

		private function getEqualIngredient(mi : MetaIngredient) : MetaIngredient {
			for (var i : int = 0; i < listIngredients.length; i++) {
				if(listIngredients[i].isEquals(mi)) return listIngredients[i];
			}
			return null;
		}
		
		public function addBatch(list : Vector.<MetaIngredient>):void {
			for (var i : int = 0; i < list.length; i++) {
				add(list[i]);
			}
		}
		
		public function setAllToAddToFalse():void {
			for (var i : int = 0; i < listIngredients.length; i++) {
				listIngredients[i].toAddInRecipe = false;
			}
		}
		
		public function sortNormal() : void {
			listIngredients.sort(sortByCatName);
		}

		private function sortByCatName(a:MetaIngredient, b:MetaIngredient) : int {
			if(a.modelCategory.index < b.modelCategory.index) return -1;
			if(a.modelCategory.index > b.modelCategory.index) return 1;
			if(a.nameLowerCase < b.nameLowerCase) return -1;
			if(a.nameLowerCase > b.nameLowerCase) return 1;
			return 0;
		}

		static public function keepFavoriteOnly(list : Vector.<MetaIngredient>) : Vector.<MetaIngredient> {
			for (var i : int = 0; i < list.length; i++) {
				if(list[i].isFavorite) continue;
				list.splice(i, 1);
				i--;
			}
			return list;
		}
		
		static public function keepWithName(list:Vector.<MetaIngredient>, name:String):Vector.<MetaIngredient> {
			if(name == "") return list;
			if(name == null) return list;
			var nameLower:String = name.toLowerCase();
			for (var i : int = 0; i < list.length; i++) {
				if(list[i].nameLowerCase.indexOf(nameLower) != -1) continue;
				list.splice(i, 1);
				i--;
			}
			return list;
		}
		
		static public function keepToAddOnly(list:Vector.<MetaIngredient>):Vector.<MetaIngredient> {
			for (var i : int = 0; i < list.length; i++) {
				if(list[i].toAddInRecipe) continue;
				list.splice(i, 1);
				i--;
			}
			return list;
		}
		
		static public function getNumToAdd(list:Vector.<MetaIngredient>):int {
			var result:int = 0;
			for (var i : int = 0; i < list.length; i++) {
				if(list[i].toAddInRecipe) result++;
			}
			return result;
		}

		public static function setAllFavorite(listIngredient : Vector.<MetaIngredient>) : void {
			for (var i : int = 0; i < listIngredient.length; i++) {
				listIngredient[i].isFavorite = true;
			}
		}
	}
}