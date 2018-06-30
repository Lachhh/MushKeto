package com.lachhh.flash.debug {
	import com.berzerkstudio.MetaCachedGOManager;
	import com.lachhhStarling.SymbolManager;

	/**
	 * @author Lachhh
	 */
	public class DebugStarlingTree extends DebugTree {
		private var textfieldCache : DebugTree;
		private var shapeObjCache : DebugTree;
		private var btnCache : DebugTree;
		private var movieClipCache : DebugTree;
		private var metaCacheGOActive : DebugTree;
		private var metaCacheGOCache : DebugTree;

		public function DebugStarlingTree() {
			super();	
			
			movieClipCache = new DebugTree();
			btnCache = new DebugTree();
			shapeObjCache = new DebugTree();
			textfieldCache = new DebugTree();
			
			metaCacheGOActive = new DebugTree();
			metaCacheGOCache = new DebugTree();
			
			AddChild(movieClipCache);
			AddChild(btnCache);
			AddChild(shapeObjCache);
			AddChild(textfieldCache);
			AddChild(metaCacheGOActive);
			AddChild(metaCacheGOCache);
		}
		
		override public function update():void {
			super.update();
			
			movieClipCache.name = "MovieClip Cache : " + SymbolManager._cachedMovieClip.length;
			btnCache.name = "ButtonSelect Cache : " + SymbolManager._cachedButtonSelect.length;
			shapeObjCache.name = "ShapeObject Cache : " + SymbolManager._cachedShapeObject.length;
			textfieldCache.name = "Textfield Cache : " + SymbolManager._cachedTextField.length;
			metaCacheGOActive.name = "MetaCacheGO Cache : " + MetaCachedGOManager.cacheGOs.length;
			metaCacheGOCache.name = "MetaCacheGO Active : " + MetaCachedGOManager.activeGOs.length;
			
			name = "Berzerk MovieClip" ;
		}
		
	
	}
}
