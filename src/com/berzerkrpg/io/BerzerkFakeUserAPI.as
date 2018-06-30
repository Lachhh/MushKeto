package com.berzerkrpg.io {
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.effect.CallbackWaitEffect;
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkrpg.ui.UI_BerzerkLogin;
	import com.berzerkrpg.ui.UI_LoadingVecto;
	import com.lachhh.io.Callback;
	import com.lachhh.io.CallbackGroup;
	import com.lachhh.io.pioAccount.IPIOAccount;
	import com.lachhh.io.premiumAPI.IPremiumAPIController;
	import com.lachhh.io.premiumAPI.ModelExternalItem;
	import com.lachhh.lachhhengine.ui.UIBase;
	import com.lachhhStarling.ModelFlaEnum;
	import com.lachhhStarling.berzerk.BerzerkStarlingManager;

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;

	/**
	 * @author Shayne
	 */
	public class BerzerkFakeUserAPI implements IPIOAccount, IPremiumAPIController {
		
		public static var instance:BerzerkFakeUserAPI;
		
		public var _premiumAPIController:IPremiumAPIController;
		
		private var stage:Stage;
		
		private var _connected:Boolean = false;
		private var _loggedIn:Boolean = false;
		
		private var _username:String = "";
		private var _token:String = "";
		
		private var callbacksOnLoggedIn:CallbackGroup = new CallbackGroup();
		private var callbackOnLoginUIClose:CallbackGroup = new CallbackGroup();

		public function BerzerkFakeUserAPI() {
			trace("NEW BERZERK API");
			instance = this;
		}
		
		public static function initInstance():void{
			if(instance != null) return;
			instance = new BerzerkFakeUserAPI();
		}
		
		public function getPioId() : String {
			return _username;
		}

		public function getAuthToken() : String {
			return _token;
		}

		public function Connect(root : DisplayObjectContainer, success : Callback = null, error : Callback = null) : void {
			stage = root as Stage;
		}

		public function get connected() : Boolean {
			return _connected;
		}

		public function get loggedIn() : Boolean {
			return _loggedIn;
		}

		public function get nameOfSystem() : String {
			return "Berzerk FAKE";
		}
		
		public function addLoginCallback(c:Callback):void{
			callbacksOnLoggedIn.addCallback(c);
		}
		
		public function addCallbackOnLoginClose(c:Callback):void{;
			callbackOnLoginUIClose.addCallback(c);
		}
		
		public function ShowLogin(o : Object = null) : void {
			if(UIBase.manager.hasInstanceOf(UI_BerzerkLogin)) return;
			
			checkIfLoaded();
		}
		
		
		private function checkIfLoaded() : void {
			if(!BerzerkStarlingManager.berzerkFlaLoader.isAtlasLoaded(ModelFlaEnum.INTERFACE_TITLEANDPRELOADER)) {
				UI_LoadingVecto.show(MainGame.instance.stage, "Loading...");
				CallbackWaitEffect.addWaitCallFctToActor(MainGame.dummyActor, checkIfLoaded, 30);
				BerzerkStarlingManager.berzerkFlaLoader.loadFla(ModelFlaEnum.INTERFACE_TITLEANDPRELOADER);
				return ;
			}
			
			if(UIBase.manager.hasInstanceOf(UI_BerzerkLogin)) return;
			
			UI_LoadingVecto.hide();
			var login:UI_BerzerkLogin = new UI_BerzerkLogin();
			login.callbackOnClose = new Callback(onLoginUIClose, this, [login]);
			login.visual.setColorAnimViewPrct(255, 0, 0, 0.25);
		}
		
		private function onLoginUIClose(login:UI_BerzerkLogin):void{
			if(login.lastLoginRequest.isSuccessful){
				_token = login.lastLoginRequest.token;
				_username = login.lastLoginRequest.username;
				_connected = true;
				_loggedIn = true;
				callbacksOnLoggedIn.call();
				callbacksOnLoggedIn.clear();
			}
			callbackOnLoginUIClose.call();
			callbackOnLoginUIClose.clear();
		}
		
		public function validateSavedTokens(m:MetaGameProgress, onComplete:Callback):void{
			BerzerkPalsLogInRequest.createValidTokenRequest(m.berzerkPalsUsername, m.berzerkPalsToken, new Callback(onLocalTokenValid, this, [m.berzerkPalsUsername, m.berzerkPalsToken, onComplete]), new Callback(onLocalTokenError, this, [onComplete]));
		}
		
		private function onLocalTokenValid(pUsername:String, pToken:String,onComplete:Callback):void{
			_username = pUsername;
			_token = pToken;
			_connected = true;
			_loggedIn = true;
			
			if(onComplete) onComplete.call();
		}
		
		private function onLocalTokenError(onComplete:Callback):void{
			clear();
			if(onComplete) onComplete.call();
		}
		
		public function clear():void{
			_username = "";
			_token = "";
			_connected = false;
			_loggedIn = false;
		}

		public function ShowBar(o : Object = null) : void {
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

		public function GetServerTime() : Date {
			return null;
		}

		public function get canShowMyMoney() : Boolean {
			return false;
		}

		public function get mustShowPurchasePopup() : Boolean {
			return false;
		}

		public function getUserUDID() : String {
			return "";
		}

		public function getUserName() : String {
			return _username;
		}
	}
}
