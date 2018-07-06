package com.berzerkrpg.meta {
	import com.lachhh.lachhhengine.IEncode;
	import com.lachhh.flash.FlashUtils;

	import flash.utils.Dictionary;
	/**
	 * @author Lachhh
	 */
	public class MetaRecipeGroup {
		public var listRecipes : Vector.<MetaRecipe> = new Vector.<MetaRecipe>();
		private var objData : Dictionary = new Dictionary();
		
		public function MetaRecipeGroup() {

		}

		public function add(metaRecipe : MetaRecipe) : void {
			listRecipes.push(metaRecipe);
		}
		
		public function remove(metaRecipe : MetaRecipe) : void {
			var index : int = listRecipes.indexOf(metaRecipe);
			if(index == -1) return ;
			listRecipes.splice(index, 1);
		}
		
		public function encode() : Dictionary {
			objData["listRecipes"] = FlashUtils.encodeList(Vector.<IEncode>(listRecipes));
			return objData; 
		}
				
		public function decode(obj:Dictionary):void {
			if (obj == null) return ;
			var list : Vector.<IEncode> = FlashUtils.decodeList(obj["listRecipes"], MetaRecipe.createFromDictionnary);
			listRecipes = Vector.<MetaRecipe>(list);
		}

		
	}
}