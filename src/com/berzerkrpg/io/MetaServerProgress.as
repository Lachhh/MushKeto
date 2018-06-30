package com.berzerkrpg.io {
	import com.berzerkrpg.io.playerio.MetaGetRewardsCommand;
	import com.berzerkrpg.io.playerio.MetaPlayerIOCommand;
	import com.berzerkrpg.io.playerio.MetaRewardFromServer;
	import com.berzerkrpg.io.playerio.ModelExternalPremiumAPI;
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkrpg.meta.ModelPlatform;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.lachhh.flash.FlashUtils;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.ui.UIBase;
	/**
	 * @author LachhhSSD
	 */
	public class MetaServerProgress {
		static private var _serverDate : Date;
		static private var _localTimeOffset : Number = 0;
		

		static public function myGetDateMs() : Number {
			return _serverDate.time + (FlashUtils.myGetTime() - _localTimeOffset);
		}

		
		static public function hasServerDate():Boolean {
			return (_serverDate != null);
		}
		
		static public function isAprilFools():Boolean{
			var now:Date = new Date();
			if(now.month == 3 && now.date == 1) return true;
			return false;
		}
		
		static public function isDevilDealXmasSpecialDate():Boolean{
			if(!hasServerDate()) return false;
			var serverDate:Date = MetaServerProgress.serverDate;
			var startDate:Date = new Date("12/24/2016 12:00:00 AM GMT-0000");
			var endDate:Date = new Date("1/7/2017 12:00:00 AM GMT-0000");
			if(startDate < serverDate && serverDate < endDate){
				return true;
			} else {
				return false;
			}
		}
		
		static public function isSteamLaunchSpecialDate():Boolean{
			var now:Date = new Date();
			var startDate:Date = new Date("5/30/2017 12:00:00 AM GMT-0000");
			var endDate:Date = new Date("6/1/2017 12:00:00 AM GMT-0000");
			return ((startDate < now) &&(now < endDate));
		}
		
		static public function setServerDate(d:Date):void  {
			_serverDate = d;
			_localTimeOffset = FlashUtils.myGetTime();
		}
		
		static public function get serverDate() : Date{
			return _serverDate;
		}
		
		static public function sendRewardClaimedCommand(reward:MetaRewardFromServer, success:Callback, error:Callback):void{
			var command:MetaPlayerIOCommand = new MetaPlayerIOCommand("reportRewardCollectedWithRewardKey", reward.key, ["errorLoadingRewardFromkey", "successReportingCollected"], null);
			PlayerIOZombIdleController.getInstance().mySecuredConnection.pushNewPlayerIOCommand(command);
		}
		
		static public function sendGetKeysForAliasCommand(alias:String, success:Callback, error:Callback):void{
			var command:MetaGetRewardsCommand = new MetaGetRewardsCommand("getRewardKeysFromAlias", alias);
			command.callbackOnError = error;
			command.callbackOnSuccess = success;
			PlayerIOZombIdleController.getInstance().mySecuredConnection.pushNewPlayerIOCommand(command);
		}
		
		static public function loadGame(name:String, model:ModelExternalPremiumAPI, success:Callback, error:Callback):MetaFriend {
			return loadGameFromName(model.prefixId + name, success, error);
		}
		
		static public function loadGameFromName(name:String, success:Callback, error:Callback):MetaFriend {
			var result:MetaFriend = new MetaFriend(name);
			PlayerIOZombIdleController.getInstance().myFriendsController.loadGame(result, success, error);
			return result;
		}
		
		static public function loadRewardsWithAlias(alias:String, success:Callback, error:Callback):void{
			sendGetKeysForAliasCommand(alias, success, error);
		}
		
		static public function loadRewardsWithAliasKeys(aliasKeys:Array, success:Callback, error:Callback):void{
			PlayerIOZombIdleController.getInstance().mySecuredConnection.getListOfRewardsWithAliasKeys(aliasKeys, success, error);
		}
		
		static public function loadTwitchNotificationsWithPlatform(platform:String, success:Callback, error:Callback):void{
			PlayerIOZombIdleController.getInstance().mySecuredConnection.getListOfTwitchNotificationsWithPlatform(platform, success, error);
		}
		
		static public function loadDynamicBigNewsNotifications(success:Callback, error:Callback):void{
			PlayerIOZombIdleController.getInstance().mySecuredConnection.getListOfDynamicBigNewsNotifications(success, error);
		}
		
		static public function ADMIN_saveOtherGuyGame(success:Callback, error:Callback):void {
			PlayerIOZombIdleController.getInstance().mySecuredConnection.saveProgressOnOtherSaveFile(MetaGameProgress.instance, success, error);
		}
		
		static public function loadAdminSaleSettings(success:Callback, error:Callback):void{
			PlayerIOZombIdleController.getInstance().mySecuredConnection.loadAdminSaleSettingsObject(success, error);
		}
		
		static public function loadAdminFlashSaleSettings(success:Callback, error:Callback):void{
			PlayerIOZombIdleController.getInstance().mySecuredConnection.loadAdminFlashSaleSettingsObject(success, error);
		}
		

		static public function loadGameUsingAlias(name:String, success:Callback, error:Callback):MetaFriend{
			throw new Error("NOT IMPLEMENTED!");
		}
		
		static public function loadGameUsingGameCode(code:String, success:Callback, error:Callback):MetaFriend{
			throw new Error("NOT IMPLEMENTED!");
		}
		
		static public function tryToClaimAlias(alias:String, success:Callback, error:Callback):void{
			throw new Error("NOT IMPLEMENTED!");
		}
		
		static public function getUniqueGameCode():String{
			return "xxx-xxx";
		}

		public static function loadPartnerShare(webArmorgames : ModelPlatform, success:Callback, errorCall:Callback) : void {
			PlayerIOZombIdleController.getInstance().mySecuredConnection.loadPartnerShare(webArmorgames, success, errorCall);
		}

		public static function loadPartnerShareDate(webArmorgames : ModelPlatform, month : int, year : int, success : Callback, errorCall : Callback) : void {
			PlayerIOZombIdleController.getInstance().mySecuredConnection.loadPartnerShareDate(webArmorgames, month, year, success, errorCall);
		}
		
		public static function fixDateString(success:Callback, errorCall:Callback) : void {
			PlayerIOZombIdleController.getInstance().mySecuredConnection.fixDateString(success, errorCall);
		}

		public static function loadOrCreateMyFriendKey(success:Callback, errorCall:Callback) : void {
			PlayerIOZombIdleController.getInstance().mySecuredConnection.loadOrCreateFriendKey(success, errorCall);
		}		
	}
}
