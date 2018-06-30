package com.lachhh.io {
	import com.berzerkrpg.io.IAdsAPI;
	import com.berzerkrpg.meta.MetaExternalAdRequest;
	import com.berzerkrpg.meta.ModelExternalAchievement;
	import com.lachhh.io.mobileShareAPI.IMobileShareAPI;
	import com.lachhh.io.notificationsAPI.INotificationsAPI;
	import com.lachhh.io.pioAccount.IPIOAccount;
	import com.lachhh.io.premiumAPI.IAchievementAPI;
	import com.lachhh.io.premiumAPI.IPremiumAPIController;
	import com.lachhh.io.premiumAPI.ModelExternalItem;
	import com.lachhh.io.savefileAPI.ISaveFileAPI;
	import com.lachhh.io.statsAPI.IStatsAPI;
	import com.lachhh.io.statsAPI.MetaStatData;
	import com.lachhh.io.trackAPI.ITrackAPI;
	import com.lachhh.utils.Utils;

	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Lachhh
	 */
	public class EmptyController implements IPremiumAPIController, IAchievementAPI, IStatsAPI, ISaveFileAPI, IPIOAccount, ITrackAPI, IAdsAPI, INotificationsAPI, IInternetCheckAPI, IMobileShareAPI, IURLNavigator {
		public function gotoAndRecord(url:String, window:String = null):void{
			Utils.navigateToURLAndRecord(url, window);
		}
		
		public function ShowBar(o : Object = null) : void {
		}

		public function ShowLogin(o : Object = null) : void {
		}

		public function ShowItem(m : ModelExternalItem) : void {
		}

		public function ShowStore(o : Object = null) : void {
		}

		public function HideBar() : void {
		}

		public function FlashBar() : void {
		}

		public function InUse() : Boolean {
			return false;
		}

		public function HasItem(m : ModelExternalItem) : Boolean {
			return false;
		}

		public function IsLastItemPurchased(m : ModelExternalItem) : Boolean {
			return false;
		}

		public function set onPurchaseCallback(c : Callback) : void {
		}

		public function set onLogInCallback(c : Callback) : void {
		}

		public function GetItemNumBought(m : ModelExternalItem) : int {
			return 0;
		}

		public function GetPriceTagOfItem(m : ModelExternalItem) : String {
			return "";
		}

		public function GetItemCostPoint(m : ModelExternalItem) : int {
			return 0;
		}

		public function ConsumeItem(m : ModelExternalItem, numToConsume : int, callback : Callback) : void {
		}

		public function get goldCurrencyName() : String {
			return "";
		}

		public function get pointCurrencyName() : String {
			return "";
		}

		public function get goldAcronym() : String {
			return "";
		}

		public function get pointAcronym() : String {
			return "";
		}

		public function get accountName() : String {
			return "";
		}

		public function get myGold() : int {
			return 0;
		}

		public function get myPoint() : int {
			return 0;
		}

		public function get serverStartingTime() : Date {
			return null;
		}

		public function GetServerTime() : Date {
			return null;
		}

		public function get canShowMyMoney() : Boolean {
			return false;
		}

		public function get mustShowPurchasePopup() : Boolean {
			return false;
		}

		public function Connect(root : DisplayObjectContainer, success : Callback = null, error : Callback = null) : void {
		}

		public function get connected() : Boolean {
			return false;
		}

		public function get loggedIn() : Boolean {
			return false;
		}

		public function get nameOfSystem() : String {
			return "";
		}
		
		public function bestowAchievement(m : ModelExternalAchievement) : void {
		}

		public function SendStat(m : MetaStatData) : void {
		}

		public function SaveData(s : String, onDone : Callback) : void {
		}

		public function ClearData() : void {
		}

		public function get savedData() : String {
			return "";
		}

		public function get isEmpty() : Boolean {
			return false;
		}

		public function get dataLoaded() : Boolean {
			return false;
		}

		public function set onDataLoadedCallback(c : Callback) : void {
		}

		public function getPioId() : String {
			return "";
		}

		public function getAuthToken() : String {
			return "";
		}

		public function trackView(arg0 : String) : void {
		}

		public function trackEvent(arg0 : String, arg1 : String) : void {
		}

		public function isConnected() : Boolean {
			return false;
		}


		public function update() : void {
		}

		public function clearCache() : void {
		}

		public function get areNotificationsAvailable() : Boolean {
			return false;
		}

		public function get arePushNotificatiosnEnabled() : Boolean {
			return false;
		}

		public function setOneDayNotification(message : String) : void {
		}

		public function setNotificationWithDelay(title : String, message : String, delayInSeconds : int) : void {
		}

		public function disableLocalNotification() : void {
		}

		public function enablePushNotifications() : void {
		}

		public function disablePushNotifications() : void {
		}

		public function get isInternetConnected() : Boolean {
			return false;
		}

		public function trackEventWithValue(nameEvent : String, nameValue : String, value : int) : void {
		}

		public function loadAds(result : MetaExternalAdRequest) : MetaExternalAdRequest {
			return null;
		}

		public function isReadyToPlayAd() : Boolean {
			return false;
		}

		public function playAds() : void {
		}

		public function canShowScrolls() : Boolean {
			return true;
		}
		
		public function canShare():Boolean{
			return false;
		}
		
		public function shareMessageWithImage(subject:String, message:String, image:BitmapData, pOnShareCompleted:Callback = null):void{
			// do nothing;
		}
		
		public function getUserUDID() : String {
			return getPioId();
		}

		public function getUserName() : String {
			return "[Debug]";
		}

		public function hasEverPurchasedItem(m : ModelExternalItem) : Boolean {
			return false;
		}

		public function onGameStarted() : void {
		}
	}
}
