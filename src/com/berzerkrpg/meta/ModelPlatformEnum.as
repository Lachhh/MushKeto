package com.berzerkrpg.meta {
	import com.berzerkrpg.io.playerio.ModelExternalPremiumAPI;
	import com.berzerkrpg.io.playerio.ModelExternalPremiumAPIEnum;
	import com.lachhh.lachhhengine.VersionInfo;
	/**
	 * @author LachhhSSD
	 */
	public class ModelPlatformEnum {
		static public var ALL:Array = new Array();
				
		static public var NULL:ModelPlatform = new ModelPlatform(-1, "", ModelPlatformTypeEnum.NULL);
				
		static public var WEB_KONGREGATE:ModelPlatform = create("kong", ModelPlatformTypeEnum.WEB);
		static public var WEB_ARMORGAMES:ModelPlatform = create("armorgames", ModelPlatformTypeEnum.WEB);
		static public var WEB_NEWGROUNDS:ModelPlatform = create("newgrounds", ModelPlatformTypeEnum.WEB);
		static public var WEB_NOTDOPPLER:ModelPlatform = create("notdoppler", ModelPlatformTypeEnum.WEB);
		static public var WEB_KIZI:ModelPlatform = create("kizi", ModelPlatformTypeEnum.WEB);
		static public var WEB_FACEBOOK:ModelPlatform = create("facebook_web", ModelPlatformTypeEnum.WEB);
		static public var WEB_ZOMBIDLE:ModelPlatform = create("zombidle", ModelPlatformTypeEnum.WEB);
		static public var WEB_VIRAL:ModelPlatform = create("viral", ModelPlatformTypeEnum.WEB);
		static public var WEB_YAHOO:ModelPlatform = create("yahoo", ModelPlatformTypeEnum.WEB);
		static public var WEB_PIO_NETWORK:ModelPlatform = create("pioNetwork", ModelPlatformTypeEnum.WEB);
		static public var MOBILE_IOS:ModelPlatform = create("ios", ModelPlatformTypeEnum.MOBILE);
		static public var MOBILE_ANDROID:ModelPlatform = create("android", ModelPlatformTypeEnum.MOBILE);
		static public var MOBILE_AMAZON:ModelPlatform = create("amazon", ModelPlatformTypeEnum.MOBILE);
		static public var DESKTOP_STEAM:ModelPlatform = create("steam", ModelPlatformTypeEnum.DESKTOP);
		static public var DESKTOP_ITCH_IO:ModelPlatform = create("itchio", ModelPlatformTypeEnum.DESKTOP);
		
		static public function create(id:String, modelPlatformType:ModelPlatformType):ModelPlatform {
			var m:ModelPlatform = new ModelPlatform(ALL.length, id, modelPlatformType);
			if(!getFromId(id).isNull) throw new Error("Duplicate ID!");
			ALL.push(m);
			return m;
		}
		
		static public function getFromPremiumAPI(model:ModelExternalPremiumAPI):ModelPlatform {
			switch(model.id) {
				case ModelExternalPremiumAPIEnum.AMAZON.id: return MOBILE_AMAZON;
				case ModelExternalPremiumAPIEnum.GOOGLEPLAYGAMES.id: return MOBILE_ANDROID;
				case ModelExternalPremiumAPIEnum.IOSGAMECENTER.id: return MOBILE_IOS;
				case ModelExternalPremiumAPIEnum.KONGREGATE.id: return WEB_KONGREGATE;
				case ModelExternalPremiumAPIEnum.NEWGROUNDS.id: return WEB_NEWGROUNDS;
				case ModelExternalPremiumAPIEnum.ARMORGAMES.id: return WEB_ARMORGAMES;
				case ModelExternalPremiumAPIEnum.BERZERK.id: return (VersionInfo.modelPlatform.isWeb() ? WEB_ZOMBIDLE : DESKTOP_ITCH_IO);
				case ModelExternalPremiumAPIEnum.STEAM.id: return DESKTOP_STEAM;
				case ModelExternalPremiumAPIEnum.KIZI.id: return WEB_KIZI;
				case ModelExternalPremiumAPIEnum.YAHOO.id: return WEB_YAHOO;
				case ModelExternalPremiumAPIEnum.PIO_NETWORK.id: return WEB_PIO_NETWORK;
				case ModelExternalPremiumAPIEnum.VIRAL.id: return WEB_VIRAL;
			}
			return NULL;
		} 
		
		static public function getFromId(id:String):ModelPlatform {
			for (var i : int = 0; i < ALL.length; i++) {
				var g:ModelPlatform = ALL[i] as ModelPlatform;
				if(id == g.id) return g;
			}
			return NULL;
		} 
		
		static public function getFromIndex(index:int):ModelPlatform {
			if(index >= ALL.length) return NULL;
			if(index < 0) return NULL;
			return ALL[index] as ModelPlatform;
		}  
				
		static public function getNum():int {
			return ALL.length;
		}
	}
}
