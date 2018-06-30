package com.lachhhStarling {
	import starling.textures.TextureSmoothing;

	import com.berzerkstudio.ModelFla;
	import com.lachhhStarling.format.ModelImageFormatEnum;
	/**
	 * @author LachhhSSD
	 */
	public class ModelFlaEnum {

		static public var ALL:Vector.<ModelFla> = new Vector.<ModelFla>();
		static public var ALL_PERSISTENT:Vector.<ModelFla> = new Vector.<ModelFla>();
				
		static public var NULL:ModelFla = new ModelFla(-1, "");
		
		
		static public var JSB_UI_TITLEANDPRELOADER:ModelFla = createPersistent("JSB_UI_TitleAndPreloader");
		static public var JSB_UI_PERSISTENT:ModelFla = createPersistent("JSB_UI_Persistent");
		
			
		static public function createPersistent(idStr:String):ModelFla {
			var result:ModelFla = create(idStr);
			ALL_PERSISTENT.push(result);
			return result;
		}
		
		
		static public function create(idStr:String, forceTinting:Boolean = false):ModelFla {
			var result:ModelFla = new ModelFla(ALL.length, idStr);	
			result.forceTinting = forceTinting;
			result.modelImageFormat = ModelImageFormatEnum.PNG;
			ALL.push(result);
			return result;
		}
		
		static public function smooothEverything():void {
			var modelFla:ModelFla;
			for (var i : int = 0; i < ModelFlaEnum.ALL.length; i++) {
				modelFla = ModelFlaEnum.ALL[i];
				//modelFla.smoothing = TextureSmoothing.BILINEAR;
				modelFla.smoothing = TextureSmoothing.TRILINEAR;
			}
		}
				
		static public function getFromId(id:String):ModelFla {
			for (var i : int = 0; i < ALL.length; i++) {
				var g:ModelFla = ALL[i] as ModelFla;
				if(id == g.id) return g;
			}
			return NULL;
		} 
		
		static public function getFromIndex(index:int):ModelFla {
			if(index >= ALL.length) return NULL;
			if(index < 0) return NULL;
			return ALL[index] as ModelFla;
		}  
		
		static public function getFirstNotInit():ModelFla {
			return getFirstNotInitIn(ALL);
		}
		
		static public function getFirstNotInitIn(a:Vector.<ModelFla>):ModelFla {
			for (var i : int = 0; i < a.length; i++) {
				var m:ModelFla = a[i];
				if(!m.isInit()) return m;
			}
			return NULL;
		}
		
				
		static public function getNum():int {
			return ALL.length;
		}
	}
}
