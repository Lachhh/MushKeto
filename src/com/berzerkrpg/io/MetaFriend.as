package com.berzerkrpg.io {
	import com.berzerkrpg.io.playerio.ModelExternalPremiumAPIEnum;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.DataManager;

	/**
	 * @author Lachhh
	 */
	public class MetaFriend {
		public var accountName:String;
		public var metaPlayer:MetaPlayerFromServer ;
		public var rawData:Object ;
		public var callbackonDirty:Vector.<Callback>;
		public var loadingError:int = 0;
		
		private var _isErrorNotFound:Boolean;
		private var _canFightWithMe:Boolean;

		public function MetaFriend(pAccountName:String) {
			loadingError = 0;
			accountName = pAccountName;
			metaPlayer = MetaPlayerFromServer.createEmpty(ModelExternalPremiumAPIEnum.RemovePrefixFromModel(accountName, ModelExternalPremiumAPIEnum.GAMERSAFE));
			
			_canFightWithMe = false;
			callbackonDirty = new Vector.<Callback>();
		}

		public function setMetaPlayerFromRawData(pRawData:Object):void {
			rawData = pRawData;
			try {
				metaPlayer.decode(DataManager.objToDictionary(rawData));
				
				trace("");
				 
			} catch(e:Error) {
				
				trace(e.getStackTrace());
				SetError();
				return ;
			}
			
			callDirtyCallback();
		}
		
		public function SetError():void {
			_isErrorNotFound = true;			
			callDirtyCallback();
		}
		
		public function callDirtyCallback():void {
			while(callbackonDirty.length > 0) {
				var c:Callback = callbackonDirty.shift();
				c.call();
			}
		}
		
		public function GetMyName():String {
			return ModelExternalPremiumAPIEnum.RemovePlatFormPrefixFromString(accountName);	
		}
		
	
		public function get isLoadingData():Boolean {
			return metaPlayer == null;	
		}
		
		public function get hasDataLoaded():Boolean {
			return metaPlayer != null;	
		}
		
		public function get isErrorNotFound() : Boolean {return _isErrorNotFound;}
		
		static public function createMetaFriend(characterName:String):MetaFriend {
			var result:MetaFriend = new MetaFriend(ModelExternalPremiumAPIEnum.TWITCH.prefixId + characterName);
			return result;
		}
		
		static public function createMetaFriends(names:Array):Array {
			var result:Array = new Array();
			for (var i : int = 0; i < names.length; i++) {
				result.push(createMetaFriend(names[i]));
			}
			return result;
		}
		
		static public function extractListOfMetaPlayer(metaFriends:Array, keepEmpty:Boolean):Array {
			var result:Array = new Array();
			for (var i : int = 0; i < metaFriends.length; i++) {
				var metaFriend:MetaFriend = metaFriends[i];
				if(keepEmpty || !metaFriend.metaPlayer.metaGameProgress.isEmpty()) {
					result.push(metaFriend.metaPlayer);
				}
			}
			return result;
		}
		
	}
}
