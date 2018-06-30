package com.lachhh.io.premiumAPI {
	import com.lachhh.lachhhengine.meta.ModelBase;

	/**
	 * @author Lachhh
	 */
	public class ModelExternalItem extends ModelBase{
		public var idGS:int;
		public var idArmorGames:String;
		public var idKong:String;
		public var idPIO:String;
		public var idGoogle:String;
		public var idAmazon:String;
		public var idIOS:String;
		public var isDLC:Boolean = false;
		public var idSteamDLC:uint;
		
		function ModelExternalItem(pIndex:int, id:String, pIdGS:int = -1, pIdKong:String = "", pIdArmorGames:String = "", pIdPIO:String = "",
												pidGoogle:String = "", pidIOS:String = "", pIdAmazon:String = "", pIdSteamDLC:uint = -1) {
			super(pIndex, id);
			idGS = pIdGS;
			idKong = pIdKong;
			idArmorGames = pIdArmorGames;
			idPIO = pIdPIO;
			idGoogle = pidGoogle;
			idIOS = pidIOS;
			idAmazon = pIdAmazon;
			idSteamDLC = pIdSteamDLC;
		}
	}
}
