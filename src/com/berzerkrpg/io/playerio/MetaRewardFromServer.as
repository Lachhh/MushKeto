package com.berzerkrpg.io.playerio {
	import flash.utils.Dictionary;
	/**
	 * @author LachhhSSD
	 */
	public class MetaRewardFromServer {
		public var key:String;
		public var target : String;
		//public var metaReward : MetaReward;
		public var devMessage:String = "";
		public var canExpire:Boolean = false;
		public var expireDate:Date = new Date();
		public var destroyOnClaim:Boolean = false;

		public function MetaRewardFromServer() {
		}
		
		public static function createFromDictionary(data:Dictionary):MetaRewardFromServer{
			var result:MetaRewardFromServer = new MetaRewardFromServer();
			result.key = data["key"];
			result.devMessage = data["devMessage"];
			result.canExpire = data["canExpire"];
			result.expireDate = data["expireDate"];
			result.destroyOnClaim = data["destroyOnClaim"];
			//result.metaReward = MetaReward.createFromDictionary(data);
			return result;
		}
		
		public function hasDevMessage():Boolean{
			return devMessage != "";
		}
	}
}
