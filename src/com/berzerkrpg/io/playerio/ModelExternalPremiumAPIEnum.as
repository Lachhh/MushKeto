package com.berzerkrpg.io.playerio {

	/**
	 * @author Lachhh
	 */
	public class ModelExternalPremiumAPIEnum {
		static public var ALL:Array = new Array();
				
		static public var NULL:ModelExternalPremiumAPI = new ModelExternalPremiumAPI(-1, "",  "", "", -1);
				
		static public var GAMERSAFE:ModelExternalPremiumAPI = Create("gs", "gs_", "GamerSafe", 11);
		static public var KONGREGATE:ModelExternalPremiumAPI = Create("kong", "kong_", "Kongregate", 6);
		static public var ARMORGAMES:ModelExternalPremiumAPI = Create("armor", "armor_", "Armor Games", 4);
		static public var TWITCH:ModelExternalPremiumAPI = Create("twitch", "twitch_", "Twitch", 9);
		static public var YAHOO:ModelExternalPremiumAPI = Create("ygn", "ygn_", "Yahoo Games", 2);
		static public var PIO_NETWORK:ModelExternalPremiumAPI = Create("pio", "pio_", "PIO Network", 2);
		static public var NEWGROUNDS:ModelExternalPremiumAPI = Create("ng", "ng_", "Newgrounds", 5);
		
		static public var GOOGLEPLAYGAMES:ModelExternalPremiumAPI = Create("gpg", "gpg_", "Google Play Games", 7);
		static public var IOSGAMECENTER:ModelExternalPremiumAPI = Create("iosgc", "iosgc_", "Game Center", 8);
		static public var FACEBOOK:ModelExternalPremiumAPI = Create("fb", "fb_", "Facebook", 3);
		static public var BERZERK:ModelExternalPremiumAPI = Create("bzk", "brzk_", "Berzerk Studios", 10);
		static public var BERZERK_FAKE:ModelExternalPremiumAPI = Create("bzkFake", "brzkFake_", "Berzerk FAKE", 12);
		static public var AMAZON:ModelExternalPremiumAPI = Create("ama", "ama_", "Game Circle", 12);
		static public var STEAM:ModelExternalPremiumAPI = Create("steam", "steam_", "Steam", 14);
		static public var KIZI:ModelExternalPremiumAPI = Create("kizi", "kizi_", "Kizi", 13);
		static public var VIRAL:ModelExternalPremiumAPI = Create("", "", "", 2);
		
		static public function Create(id:String, prefixId:String, nameOfSystem:String, frame:int):ModelExternalPremiumAPI {
			var m:ModelExternalPremiumAPI = new ModelExternalPremiumAPI(ALL.length, id, prefixId, nameOfSystem, frame);
			if(!GetFromId(id).isNull) throw new Error("Duplicate ID!");
			ALL.push(m);
			return m;
		}
				
				
		static public function GetFromId(id:String):ModelExternalPremiumAPI {
			for (var i : int = 0; i < ALL.length; i++) {
				var g:ModelExternalPremiumAPI = ALL[i];
				if(id == g.id) return g;
			}
			return NULL;
		} 
		
		static public function getFromIndex(id:int):ModelExternalPremiumAPI {
			if(id >= ALL.length) NULL;
			if(id < 0) NULL;
			var g:ModelExternalPremiumAPI = ALL[id] as ModelExternalPremiumAPI;
			return g;
		} 
		
		static public function RemovePlatFormPrefixFromString(str:String):String {
			for (var i : int = 0; i < ModelExternalPremiumAPIEnum.ALL.length; i++) {
				var modelExternal:ModelExternalPremiumAPI = ModelExternalPremiumAPIEnum.getFromIndex(i);
				str = RemovePrefix(str, modelExternal.prefixId);	
			}
			
			return str;
		}
		
		static private function RemovePrefix(strToManipulate:String, prefixToRemove:String):String {
			var index:int = strToManipulate.indexOf(prefixToRemove);
			if(index == 0) {
				strToManipulate = strToManipulate.substr(prefixToRemove.length, strToManipulate.length - (prefixToRemove.length));
			}
			return strToManipulate;
		}
		
		static public function RemovePrefixFromModel(strToManipulate:String, modelExternal:ModelExternalPremiumAPI):String {
			return RemovePrefix(strToManipulate, modelExternal.prefixId);	
		}
	}
}
