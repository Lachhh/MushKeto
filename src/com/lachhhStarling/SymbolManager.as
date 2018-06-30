package com.lachhhStarling {
	import com.berzerkstudio.MetaCachedGOManager;
	import com.berzerkstudio.ModelFla;
	import com.berzerkstudio.flash.display.ButtonSelect;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.ShapeObject;
	import com.berzerkstudio.flash.display.TextField;
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.berzerkstudio.flash.meta.MetaMovieClip;
	public class SymbolManager {
		
		static public var metaFlas:Vector.<ModelFla>;
		static public var metaFlasToLoad:Vector.<String>;
		static public var metaFlasLoadedIndex:int = 0;	
		
		static public var _cachedMovieClip:Vector.<MovieClip> = new Vector.<MovieClip>();
		static public var _cachedButtonSelect:Vector.<ButtonSelect> = new Vector.<ButtonSelect>();
		//private var _cachedAnimationAsset:AnimationAssetArray = new Vector.<MovieClip>();
		static public var _cachedShapeObject:Vector.<ShapeObject> = new Vector.<ShapeObject>();
		static public var _cachedTextField:Vector.<TextField> = new Vector.<TextField>();
		
		static public var metaDisplayObjectEmpty:MetaMovieClip = MetaMovieClip.create();
		
		/*static public function GetMetaDisplayObject(idFla:int, classId:int):MetaDisplayObject {
			return ModelFlaEnum.getFromIndex(idFla).GetMetaDisplayObject(classId);
		}*/
	
		/*static public function CreateNewMovieClip(m:MetaDisplayObject):MovieClip {
			var metaDisplayObject:MetaDisplayObject = m.modelFla.GetMetaDisplayObject(m.theClassId);
			var mc:MovieClip = new MovieClip(); 	
			mc.LoadFromMeta(metaDisplayObject);
			return mc;
		}*/
		
		static public function CreateNewSymbol(m:MetaDisplayObject):DisplayObject {
			if(m.isTextField()) {
				var tf:TextField = getCachedTextField();
				tf.LoadFromMeta(m);
				return tf;
			} else if(m.isShape()) {
				var s:ShapeObject = getCachedShape();
				s.LoadFromMeta(m);
				return s;
			} 
			
			var metaDisplayObject:MetaDisplayObject = m.modelFla.GetMetaDisplayObject(m.theClassId);
			if(metaDisplayObject.isButton){
				var btn:ButtonSelect = getCachedButtonSelect();
				btn.LoadFromMeta(metaDisplayObject);
				return btn;
			} else {
				var mc:MovieClip = getCachedMovieClip();
				mc.LoadFromMeta(metaDisplayObject);
				return mc;
			}
		}
		
		static public function getEmptyMovieClip():MovieClip {
			var result:MovieClip = getCachedMovieClip();
			result.LoadFromMeta(metaDisplayObjectEmpty);
			return result;
		}
		
		static private function getCachedMovieClip():MovieClip {
			var mc:MovieClip ;
			if(_cachedMovieClip.length > 0) {
			 	mc = _cachedMovieClip.pop();
			} else {
			 	mc = new MovieClip();
			}
			mc.isCached = false;
			return mc;
		}
		
		static public function getCachedShape():ShapeObject {
			var s:ShapeObject ;
			if(_cachedShapeObject.length > 0) {
			 	s = _cachedShapeObject.pop();
			} else {
			 	s = new ShapeObject();
			}
			s.isCached = false;
			return s;
		}
		
		static public function getCachedButtonSelect():ButtonSelect {
			var btn:ButtonSelect ;
			if(_cachedButtonSelect.length > 0) {
			 	btn = _cachedButtonSelect.pop();
			} else {
			 	btn = new ButtonSelect();
			}
			btn.isCached = false;
			return btn;
		}
		
		static public function getCachedTextField():TextField {
			var tf:TextField ;
			if(_cachedTextField.length > 0) {
			 	tf = _cachedTextField.pop();
			} else {
			 	tf = new TextField();
			}
			tf.isCached = false;
			return tf;
		}
		
		static public function CacheDisplayObject(d:DisplayObject):void {
			if(!d.isCached) {
				if(d is TextField) {
					_cachedTextField.push(d as TextField);
				} else if(d is ShapeObject) {
					_cachedShapeObject.push(d as ShapeObject);
				} else if(d is ButtonSelect) {
					_cachedButtonSelect.push(d as ButtonSelect);
				} else if(d is MovieClip) {
					_cachedMovieClip.push(d as MovieClip);
				}
				d.transform.Dispose();
			}
			
			d.isCached = true;
			
			MetaCachedGOManager.cache(d.metaGo);
			var dc:DisplayObjectContainer = d as DisplayObjectContainer;
			var child:DisplayObject ;
			
			if(dc != null) {
				while(dc.numChildren > 0) {
					child = dc.firstChild;
					dc.removeChild(child);
					
					CacheDisplayObject(child);
				}
			}
		}
	}
		
}