package com.berzerkrpg.io {
	import playerio.Client;
	import playerio.DatabaseObject;
	import playerio.generated.PlayerIOError;

	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.effect.CallbackTimerEffect;
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkrpg.meta.store.MetaDLCPack;
	import com.berzerkrpg.meta.store.MetaDiamondPack;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.ui.UI_Loading;
	import com.berzerkrpg.ui.UI_PopUp;
	import com.lachhh.io.Callback;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.io.premiumAPI.IPremiumAPIController;
	import com.lachhh.io.premiumAPI.ModelExternalItem;

	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	/**
	 * @author Shayne
	 */
	public class PlayerIOPaypalPremiumAPI implements IPremiumAPIController {
		
		public var _premiumAPIController:IPremiumAPIController;
		
		private var _pricesLoaded:Boolean = false;
		private var _isLoadingPrices:Boolean = false;
		private var _numPricesLoaded:int = 0;
		
		private var purchaseCallback:Callback;
		private var _lastRequestedPurchase:ModelExternalItem;
		private var _lastItemPurchased:ModelExternalItem;
		
		private var _costDict:Dictionary = new Dictionary();
		
		private function get pioClient():Client{ return PlayerIOZombIdleController.getInstance().mySecuredConnection.client; }
		
		public function PlayerIOPaypalPremiumAPI(controller:IPremiumAPIController){
			_premiumAPIController = controller;
		}
		
		public function Connect(root : DisplayObjectContainer, success : Callback = null, error : Callback = null) : void {
		}
		
		public function set onPurchaseCallback(c : Callback) : void {
			purchaseCallback = c;
		}

		public function ShowItem(m : ModelExternalItem) : void {
			if (!PlayerIOZombIdleController.getInstance().mySecuredConnection.connected) {
				UI_PopUp.createYesNo(TextFactory.PAYPAL_DIAMOND_PACK_PLAY_ONLINE.getText(), new Callback(onYesPlayOnline, this, null), null);
				return ;
			}
			
			var descMsg:String = "DESCRIPTION";
			/*if(m.isDLC){
				var metaDLC:MetaDLCPack = MetaGameProgress.instance.metaStoreProgress.getMetaDLCPackFromModel(m);
				descMsg = metaDLC.getDescForPaypalTxt();
			} else {
				var metaDiamonPack:MetaDiamondPack = MetaGameProgress.instance.metaStoreProgress.getMetaPackFromModel(m);
				descMsg = metaDiamonPack.getDescForPaypalTxt();
			}
			*/
			_lastRequestedPurchase = m;
			pioClient.payVault.getBuyDirectInfo("paypal", 
			{currency:"USD", item_name:descMsg, image_url:"http://www.zombidle.com/assets/icons/paypal_icon.png"},
			[{itemKey:m.idPIO}],
			onShowItemSuccess,
			onShowItemError);
			UI_Loading.show(TextFactory.PAYPAL_DIAMOND_PACK_OPENING_PAYPAL.getText());
		}
		
		private function onYesPlayOnline() : void {
			//UI_Transition.transitionToTitleScreen();
		}
		
		private function onShowItemSuccess(info:Object):void{
			//Utils.navigateToURLAndRecord(info.paypalurl);
			ExternalAPIManager.externalURLNavigator.gotoAndRecord(info.paypalurl);
			CallbackTimerEffect.addWaitCallFctToActor(MainGame.dummyActor, showCloseThisPopup, 3000);
		}
		
		private function showCloseThisPopup():void {
			UI_PopUp.createOkOnly(TextFactory.PAYPAL_DIAMOND_PACK_CLICK_WHEN_DONE.getText(), new Callback(onConfirmedPurchaseComplete, this, null));
			UI_Loading.hide();
		}
		
		private function onConfirmedPurchaseComplete():void{
			UI_Loading.show(TextFactory.PAYPAL_DIAMOND_PACK_WAITING_FOR_SERVERS.getText());
			pioClient.payVault.refresh(onPlayerIOVaultRefreshed, onPlayerIOVaultRefreshError);
		}
		
		private function onPlayerIOVaultRefreshed():void{
			UI_Loading.hide();
			var playerHasItem:Boolean = pioClient.payVault.has(_lastRequestedPurchase.idPIO);
			
			if(playerHasItem){
				if(_lastRequestedPurchase.isDLC){
					onPlayerIOVaultConsume();
				} else {
					pioClient.payVault.consume([pioClient.payVault.first(_lastRequestedPurchase.idPIO)],
					onPlayerIOVaultConsume,
					onPlayerIOVaultConsumeError);
				}
			}
			else{
				UI_PopUp.createYesNo(TextFactory.PAYPAL_DIAMOND_PACK_FAILED_TO_LOAD_FROM_SERVER.getText(), new Callback(onConfirmedPurchaseComplete, this, null), null);
			}
		}
		
		private function onPlayerIOVaultConsume():void{
			_lastItemPurchased = _lastRequestedPurchase;
			if(purchaseCallback) purchaseCallback.call();
		}
		
		private function onPlayerIOVaultConsumeError():void{
			UI_PopUp.createYesNo(TextFactory.PAYPAL_DIAMOND_PACK_FAILED_TO_CONSUME_FROM_SERVER.getText(), new Callback(onConfirmedPurchaseComplete, this, null), null);
		}
		
		private function onPlayerIOVaultRefreshError():void{
			UI_PopUp.createYesNo(TextFactory.PAYPAL_DIAMOND_PACK_FAILED_TO_CONNECT.getText(), new Callback(onConfirmedPurchaseComplete, this, null), null);
		}
		
		private function onShowItemError(e:PlayerIOError):void{
			trace(e);
			UI_PopUp.createOkOnly(TextFactory.PAYPAL_DIAMOND_PACK_FAILED_TO_BUY.getText(), null);
		}
		
		public function hasEverPurchasedItem(m:ModelExternalItem):Boolean{
			if(pioClient == null) return false;
			try{
				return pioClient.payVault.has(m.idPIO);
			} catch(e:Error){
				return false;
			}
			return false;
		}
		
		public function onGameStarted():void{
			if(pioClient == null) return;
			pioClient.payVault.refresh();
		}

		public function ShowStore(o : Object = null) : void {
			//TODO: replace with paypal
		}

		public function HasItem(m : ModelExternalItem) : Boolean {
			// TODO: Auto-generated method stub
			return false;
		}

		public function IsLastItemPurchased(m : ModelExternalItem) : Boolean {
			if(_lastItemPurchased == null) return false;
			return _lastItemPurchased.idPIO == m.idPIO;
		}

		public function GetItemNumBought(m : ModelExternalItem) : int {
			// TODO: Auto-generated method stub
			return 0;
		}

		public function GetPriceTagOfItem(m : ModelExternalItem) : String {
			
			if (!PlayerIOZombIdleController.getInstance().mySecuredConnection.connected) {
				return null;
			}
			
			if(!_pricesLoaded){
				UI_Loading.show(TextFactory.PAYPAL_DIAMOND_PACK_WAITING_FOR_SERVERS.getText());
				loadMicrotransactionPrices();
				return " ";
			}
			
			var result:String = _costDict[m.idPIO];
			return result;
		}
		
		private function loadMicrotransactionPrices() : void {
			if(_isLoadingPrices) return;
			_isLoadingPrices = true;
			for each(var item:ModelExternalItem in ModelExternalItemEnum.ALL){
				requestItemPriceFromServer(item);
			}
		}
		
		private function requestItemPriceFromServer(m:ModelExternalItem):void{
			trace("loading" + m.idPIO);
			pioClient.bigDB.load("PayVaultItems", m.idPIO, initializeItemPrice, initializeItemPriceError);
			_numPricesLoaded++;
			
			if(_numPricesLoaded >= ModelExternalItemEnum.ALL.length){
				_pricesLoaded = true;
				_isLoadingPrices = false;
			}
		}
		
		private function initializeItemPrice(ob:DatabaseObject):void{
			UI_Loading.hide();
			if(ob == null){
				trace("NULL!");
				return;
			}
			var rawCost:String = ob.PriceUSD;
			_costDict[ob.key] = convertToProperCurrencyString(rawCost);
		}
		
		private function roundToCorrectLength(n:Number):Number{
			return int(n*100)/100;
		}
		
		private function convertToProperCurrencyString(str:String):String{
			var cost:Number = Number(str);
			cost = roundToCorrectLength(cost * 0.01);
			return "$" + cost;
		}
		
		private function initializeItemPriceError(error:Object):void{
			trace(error);
		}

		public function GetItemCostPoint(m : ModelExternalItem) : int {
			// TODO: Auto-generated method stub
			return 0;
		}

		public function ConsumeItem(m : ModelExternalItem, numToConsume : int, callback : Callback) : void {
		}

		public function get goldCurrencyName() : String {
			// TODO: Auto-generated method stub
			return null;
		}

		public function get pointCurrencyName() : String {
			// TODO: Auto-generated method stub
			return null;
		}

		public function get goldAcronym() : String {
			// TODO: Auto-generated method stub
			return null;
		}

		public function get pointAcronym() : String {
			// TODO: Auto-generated method stub
			return null;
		}

		public function get myGold() : int {
			// TODO: Auto-generated method stub
			return 0;
		}

		public function get myPoint() : int {
			// TODO: Auto-generated method stub
			return 0;
		}

		public function get canShowMyMoney() : Boolean {
			// TODO: Auto-generated method stub
			return false;
		}

		public function get mustShowPurchasePopup() : Boolean {
			// TODO: Auto-generated method stub
			return false;
		}

		public function set onLogInCallback(c : Callback) : void {
			_premiumAPIController.onLogInCallback = c;
		}
		
		public function get connected() : Boolean {
			return _premiumAPIController.connected;
		}

		public function get loggedIn() : Boolean {
			return _premiumAPIController.loggedIn;
		}

		public function get nameOfSystem() : String {
			return _premiumAPIController.nameOfSystem;
		}

		public function ShowBar(o : Object = null) : void {
			_premiumAPIController.ShowBar(o);
		}

		public function ShowLogin(o : Object = null) : void {
			_premiumAPIController.ShowLogin(o);
		}
		
		public function HideBar() : void {
			_premiumAPIController.HideBar();
		}

		public function FlashBar() : void {
			_premiumAPIController.FlashBar();
		}

		public function InUse() : Boolean {
			return _premiumAPIController.InUse();
		}
		
		public function get accountName() : String {
			return _premiumAPIController.accountName;
		}
		
		public function GetServerTime() : Date {
			return _premiumAPIController.GetServerTime();
		}
	}
}
