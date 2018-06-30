package com.berzerkrpg.io {
	import com.berzerkrpg.io.playerio.ModelExternalPremiumAPI;
	import com.berzerkrpg.meta.MetaGameProgress;

	import flash.utils.Dictionary;
	/**
	 * @author LachhhSSD
	 */
	public class MetaPlayerFromServer {
		public var metaGameProgress:MetaGameProgress;
		public var modelExternalAPI : ModelExternalPremiumAPI;
		public var name : String;
		private var saveData : Dictionary = new Dictionary();

		public function MetaPlayerFromServer() {
			 
		}
		

		public static function createEmpty(name : String) : MetaPlayerFromServer {
			var result:MetaPlayerFromServer = new MetaPlayerFromServer();
			result.name = name;
			result.metaGameProgress = MetaGameProgress.create();
			return result;
		}

		
		public function decode(loadData:Dictionary):void {
			if(loadData == null) return ;
			metaGameProgress.decode(loadData);
		}
	}
}
