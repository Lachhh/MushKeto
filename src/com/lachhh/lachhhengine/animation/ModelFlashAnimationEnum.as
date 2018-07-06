package com.lachhh.lachhhengine.animation {
	import com.berzerkstudio.ModelFla;
	import com.lachhhStarling.ModelFlaEnum;
	/**
	 * @author LachhhSSD
	 */
	public class ModelFlashAnimationEnum  {
		static public var ALL:Array = new Array();
				
		static public var NULL:ModelFlashAnimation = new ModelFlashAnimation(-1, "", ModelFlaEnum.NULL);
		static public var EMPTY:ModelFlashAnimation = create("EMC", ModelFlaEnum.JSB_UI_PERSISTENT);
		
		static public var UI_BERZERKSIGNIN:ModelFlashAnimation = create("UI_BERZERKSIGNIN", ModelFlaEnum.JSB_UI_TITLEANDPRELOADER);
		
		static public var UI_MAINMENU_ANIM:ModelFlashAnimation = create("UI_MAINMENU", ModelFlaEnum.JSB_UI_PERSISTENT);
		static public var UI_POPUPINSERT_ANIM:ModelFlashAnimation = create("UI_POPUPINSERT", ModelFlaEnum.JSB_UI_PERSISTENT);
		static public var UI_RECIPEEDIT_ANIM:ModelFlashAnimation = create("UI_RECIPEEDIT", ModelFlaEnum.JSB_UI_PERSISTENT);
		
		static public var UI_RECIPEBROWSE_ANIM:ModelFlashAnimation = create("UI_RECIPEBROWSE", ModelFlaEnum.JSB_UI_PERSISTENT);
		static public var UI_INGREDIENTBROWSE_ANIM:ModelFlashAnimation = create("UI_INGREDIENTBROWSE", ModelFlaEnum.JSB_UI_PERSISTENT);
		static public var UI_SETTINGS_ANIM:ModelFlashAnimation = create("UI_SETTINGS", ModelFlaEnum.JSB_UI_PERSISTENT);
		
		static public var FX_INGREDIENT_ANIM:ModelFlashAnimation = create("FX_INGREDIENT", ModelFlaEnum.JSB_UI_PERSISTENT);
		static public var FX_INGREDIENT_ALL_ANIM:ModelFlashAnimation = create("FX_INGREDIENT_ALL", ModelFlaEnum.JSB_UI_PERSISTENT);
		
		static public var FX_RECIPE_ANIM:ModelFlashAnimation = create("FX_RECIPE", ModelFlaEnum.JSB_UI_PERSISTENT);
		
		
		static public var UI_POPUP:ModelFlashAnimation = create("UI_POPUP", ModelFlaEnum.JSB_UI_PERSISTENT);
		static public var UI_LOADING:ModelFlashAnimation = create("UI_LOADING", ModelFlaEnum.JSB_UI_TITLEANDPRELOADER);
		
		static public var UI_INGREDIENTSTEMPLATES_ANIM:ModelFlashAnimation = create("UI_INGREDIENTSTEMPLATES", ModelFlaEnum.JSB_UI_PERSISTENT);
		
				
		static public function create(id : String, modelFla : ModelFla) : ModelFlashAnimation {
			var m:ModelFlashAnimation = new ModelFlashAnimation(ALL.length, id, modelFla);
			if(!getFromId(id).isNull) throw new Error("Duplicate ID!");
			ALL.push(m);
			return m;
		}
		
		static public function getFromId(id:String):ModelFlashAnimation {
			for (var i : int = 0; i < ALL.length; i++) {
				var g:ModelFlashAnimation = ALL[i] as ModelFlashAnimation;
				if(id == g.id) return g;
			}
			return NULL;
		} 
		
		static public function getFromIndex(index:int):ModelFlashAnimation {
			if(index >= ALL.length) return NULL;
			if(index < 0) return NULL;
			return ALL[index] as ModelFlashAnimation;
		}  
				
		static public function getNum():int {
			return ALL.length;
		}
		
		static public function pickRandomAnim(modelAnims:Array):ModelFlashAnimation {
			return modelAnims[Math.floor(Math.random()*modelAnims.length)] as ModelFlashAnimation;
		}
		
	}
}
