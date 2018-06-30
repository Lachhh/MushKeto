package com.lachhh.io.premiumAPI {
	import com.lachhh.io.Callback;
	import com.lachhh.io.IExternalAPI;

	/**
	 * @author Lachhh
	 */
	public interface IPremiumAPIController extends IExternalAPI{
		function ShowBar(o:Object = null):void ;
		function ShowLogin(o:Object = null):void ;
		function ShowItem(m:ModelExternalItem):void ;
		function ShowStore(o:Object = null):void ;
		function HideBar():void ;
		function FlashBar():void ;				
		function InUse():Boolean ;		
		function HasItem(m:ModelExternalItem):Boolean ;
		function IsLastItemPurchased(m:ModelExternalItem):Boolean ;
		function set onPurchaseCallback(c:Callback):void ;
		function set onLogInCallback(c:Callback):void ;
		
		function hasEverPurchasedItem(m:ModelExternalItem):Boolean;
		function onGameStarted():void;
		
		function GetItemNumBought(m:ModelExternalItem):int ;
		function GetPriceTagOfItem(m:ModelExternalItem):String ;
		function GetItemCostPoint(m:ModelExternalItem):int ;
		function ConsumeItem(m:ModelExternalItem, numToConsume:int, callback:Callback):void ;
		function get goldCurrencyName():String ;
		function get pointCurrencyName():String ;
		function get goldAcronym():String ;
		function get pointAcronym():String ;
		function get accountName():String ;
		function get myGold():int ;
		function get myPoint():int ;
		function GetServerTime():Date ;
		
		function get canShowMyMoney():Boolean ;
		function get mustShowPurchasePopup():Boolean ;
		
		
	}
}
