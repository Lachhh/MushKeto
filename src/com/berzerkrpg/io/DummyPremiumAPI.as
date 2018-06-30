package com.berzerkrpg.io {
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.effect.CallbackTimerEffect;
	import com.berzerkrpg.ui.UI_Loading;
	import com.lachhh.io.Callback;
	import com.lachhh.io.premiumAPI.IPremiumAPIController;
	import com.lachhh.io.premiumAPI.ModelExternalItem;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author LachhhSSD
	 */
	public class DummyPremiumAPI implements IPremiumAPIController {
		private var purchaseCallback : Callback ;
		private var _lastItemBought : ModelExternalItem;

		public function DummyPremiumAPI() {
		}

		public function Connect(root : DisplayObjectContainer, success : Callback = null, error : Callback = null) : void {
		}

		public function get connected() : Boolean {
			return true;
		}

		public function get loggedIn() : Boolean {
			return true;
		}

		public function get nameOfSystem() : String {
			return "dummy";
		}

		public function ShowBar(o : Object = null) : void {
		}

		public function ShowLogin(o : Object = null) : void {
		}

		public function ShowItem(m : ModelExternalItem) : void {
			UI_Loading.show("Dummy text");
			CallbackTimerEffect.addWaitCallFctToActor(MainGame.dummyActor, onWait, 2000);
			_lastItemBought = m;
		}

		private function onWait() : void {
			UI_Loading.hide();
			if(purchaseCallback) purchaseCallback.call();
		}

		public function ShowStore(o : Object = null) : void {
		}

		public function HideBar() : void {
		}

		public function FlashBar() : void {
		}

		public function InUse() : Boolean {
			// TODO: Auto-generated method stub
			return false;
		}

		public function HasItem(m : ModelExternalItem) : Boolean {
			// TODO: Auto-generated method stub
			return false;
		}

		public function IsLastItemPurchased(m : ModelExternalItem) : Boolean {
			return _lastItemBought.isEquals(m);
		}

		public function GetItemNumBought(m : ModelExternalItem) : int {
			
			return 0;
		}

		public function GetPriceTagOfItem(m : ModelExternalItem) : String {
			return null;
		}

		public function GetItemCostPoint(m : ModelExternalItem) : int {

			return 0;
		}

		public function ConsumeItem(m : ModelExternalItem, numToConsume : int, callback : Callback) : void {
		}

		public function GetServerTime() : Date {
			return null;
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

		public function get accountName() : String {
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

		public function set onPurchaseCallback(c : Callback) : void {
			purchaseCallback = c;
		}

		public function set onLogInCallback(c : Callback) : void {
		}

		public function hasEverPurchasedItem(m : ModelExternalItem) : Boolean {
			return false;
		}

		public function onGameStarted() : void {
		}
	}
}
