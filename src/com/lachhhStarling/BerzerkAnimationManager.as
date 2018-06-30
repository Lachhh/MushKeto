package com.lachhhStarling {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.Stage;
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;
	import com.lachhhStarling.berzerk.BerzerkStarlingManager;
	/**
	 * @author LachhhSSD
	 */
	public class BerzerkAnimationManager  {
		private var stage : Stage;
		private var bzkManager : BerzerkStarlingManager;

		public function BerzerkAnimationManager(pStage:StarlingStage) {
			bzkManager = new BerzerkStarlingManager(pStage);
			stage = bzkManager.berzerkStage.stage;
		}

		public function createAnimation(modelAnim : ModelFlashAnimation) : MovieClip {
			if(modelAnim.isNull) return null;
			if(modelAnim.isEmpty()) {
				return SymbolManager.getEmptyMovieClip();
			}
			
			var metaDisplayObject:MetaDisplayObject = modelAnim.getMetaDisplayObject();
			if(metaDisplayObject == null) throw new Error("NULL META OBJECT FOR: " + modelAnim.id);
			var result:MovieClip = SymbolManager.CreateNewSymbol(metaDisplayObject) as MovieClip ;
			
			return result;
		}
		
		
		public function createEmpty() : MovieClip {
			return SymbolManager.getEmptyMovieClip();
		}

		
		public function destroyAnimation(d:DisplayObject):void {
			SymbolManager.CacheDisplayObject(d);
			d.removeFromParent();
		}
	
		public function getStage():Stage {
			return stage;
		}

		public function update() : void {
			bzkManager.update();
		}

		public function clearCache() : void {
		}
	}
}
