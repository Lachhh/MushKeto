package com.berzerkrpg.meta {
	import com.lachhh.lachhhengine.meta.ModelBase;

	/**
	 * @author LachhhSSD
	 */
	public class ModelPlatformType extends ModelBase {
		
		public function ModelPlatformType(pIndex:int, pId : String) {
			super(pIndex, pId);
		}
		
		public function isWeb():Boolean { return id == ModelPlatformTypeEnum.WEB.id; }
		public function isDesktop():Boolean { return id == ModelPlatformTypeEnum.DESKTOP.id;}
		public function isMobile():Boolean { return id == ModelPlatformTypeEnum.MOBILE.id;}
	}
}
