package com.lachhh.lachhhengine.animation {
	import com.lachhh.lachhhengine.VersionInfo;
	import com.berzerkstudio.ModelFla;
	import com.berzerkstudio.flash.meta.MetaDisplayObject;
	import com.lachhh.lachhhengine.meta.ModelBase;

	/**
	 * @author LachhhSSD
	 */
	public class ModelFlashAnimation extends ModelBase {
		public var modelFla:ModelFla;
		private var metaDisplayObject:MetaDisplayObject;
		public var animFactoryId:int = -2;
		public function ModelFlashAnimation(pIndex:int, pId : String, pModelFla:ModelFla) {
			super(pIndex, pId);
			modelFla = pModelFla ;
			if(VersionInfo.isDebug && VersionInfo.starlingReady) {
				//validate();
			}
		}		
		
		
		private function validate():void {
			if(isNull) return ;
			if(modelFla.GetMetaDisplayObjectFromString(id) == null) {
				if(VersionInfo.isThrowErrorOnValidateStarling) {
					throw new Error("Cannot retreive : " + id + "/" + " from fla : " + modelFla.id);
				} else {
					trace("ERROR ModelStarlingAnimation : Cannot retreive : " + id + "/" + " from fla : " + modelFla.id);
				}
			}
		}
		
		public function getMetaDisplayObject():MetaDisplayObject {
			if(metaDisplayObject == null) {
				metaDisplayObject = modelFla.GetMetaDisplayObjectFromString(id);
			}
			return metaDisplayObject;
		}
		
		public function isEmpty():Boolean {
			return (id == ModelFlashAnimationEnum.EMPTY.id);
		}
	}
}
