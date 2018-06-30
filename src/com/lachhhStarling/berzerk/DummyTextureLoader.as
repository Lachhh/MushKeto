package com.lachhhStarling.berzerk {
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.lachhhStarling.berzerk.IBerzerkTextureLoader;
	import com.berzerkstudio.ModelFla;
	import com.lachhhStarling.berzerk.MetaFla;

	/**
	 * @author LachhhSSD
	 */
	public class DummyTextureLoader implements IBerzerkTextureLoader {
		public function loadFla(modelFla : ModelFla) : MetaFla {
			return null;
		}

		public function unloadFla(modelFla : ModelFla) : MetaFla {
			return null;
		}

		public function getMetaFlaFromModel(modelFla : ModelFla) : MetaFla {
			return null;
		}

		public function isAtlasLoaded(modelFla : ModelFla) : Boolean {
			return true;
		}

		public function isSingularTextureLoaded(metaDisplayObject:MetaDisplayObject) : Boolean {
			return false;
		}

		public function loadSingularTexture(metaDisplayObject:MetaDisplayObject) : void {
		}

		public function unloadSingularTexture(metaDisplayObject:MetaDisplayObject) : void {
		}

		public function unloadAllSingularTextures() : void {
		}

		public function unloadSingularTexturesFromFLA(modelFla : ModelFla) : void {
		}
	}
}
