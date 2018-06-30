package com.berzerkrpg.meta {
	import com.lachhh.lachhhengine.meta.ModelBase;

	/**
	 * @author LachhhSSD
	 */
	public class ModelPlatform extends ModelBase {
		public var modelPlatformType : ModelPlatformType;

		public function ModelPlatform(pIndex:int, pId : String, pModelPlatformType : ModelPlatformType) {
			super(pIndex, pId);
			modelPlatformType = pModelPlatformType;
		}
		
		public function isWebOrDesktop():Boolean {return isWeb() || isDesktop();}
		
		public function isWeb():Boolean {return modelPlatformType.isWeb();}		
		public function isDesktop():Boolean { return modelPlatformType.isDesktop();}		
		public function isMobile() : Boolean { return modelPlatformType.isMobile();}
		public function isIos() : Boolean { return isEquals(ModelPlatformEnum.MOBILE_IOS);}
		public function isSteam() : Boolean { return id == ModelPlatformEnum.DESKTOP_STEAM.id;}
		
		public function isAndroid() : Boolean { 
			if(isEquals(ModelPlatformEnum.MOBILE_AMAZON)) return true;
			if(isEquals(ModelPlatformEnum.MOBILE_ANDROID)) return true;
			return false;
		}

		public function isAmazon() : Boolean {
			if(isEquals(ModelPlatformEnum.MOBILE_AMAZON)) return true;
			return false;
		}
		
		
	}
}
