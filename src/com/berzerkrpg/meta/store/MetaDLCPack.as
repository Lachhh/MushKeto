package com.berzerkrpg.meta.store {
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.multilingual.TextInstance;
	import com.berzerkrpg.ui.UI_Loading;
	import com.lachhh.flash.SecureNumber;
	import com.lachhh.io.Callback;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.io.premiumAPI.ModelExternalItem;
	import com.lachhhStarling.ModelFlaEnum;
	import com.lachhhStarling.berzerk.BerzerkStarlingManager;
	/**
	 * @author Eel
	 */
	public class MetaDLCPack {
		
		public var modelExternalItemAtFullPrice:ModelExternalItem;
		
		public var items:Array = new Array();
		public var itemPromoList:Array = new Array();
		public var diamonds:SecureNumber = new SecureNumber();
		public var bloodstones:SecureNumber = new SecureNumber();
		
		public var title:TextInstance;
		public var price:Number ;
		public var priceCostStr:String = "$0.99";
		public var frame:int = 1;
		
		public var saleTypes:Vector.<MetaFlashSaleType> = new Vector.<MetaFlashSaleType>();
		private var currentMetaSale:MetaFlashSaleType;
		
		public function MetaDLCPack(pModelExternalItem:ModelExternalItem, pTitle:TextInstance, pFrame:int, pDiamonds:int, pBloodstones:int, pItems:Array, pItemPromoList:Array){
			modelExternalItemAtFullPrice = pModelExternalItem;
			title = pTitle;
			frame = pFrame;
			items = pItems;
			itemPromoList = pItemPromoList;
			diamonds.value = pDiamonds;
			bloodstones.value = pBloodstones;
		}
		
		public function awardPack(mGame:MetaGameProgress, onFinishedCallback:Callback):void{
			/*UI_Loading.show("Loading...");
			BerzerkStarlingManager.berzerkModelFlaAssetLoader.loadBunch([ModelFlaEnum.INTERFACE_POPUP, ModelFlaEnum.ZI_INTERFACES_SELFIE, ModelFlaEnum.ZI_INTERFACES_ITEMS], new Callback(onFinishedLoadingPopups, this, [mGame, onFinishedCallback]));
		*/}
		
		private function onFinishedLoadingPopups(mGame:MetaGameProgress, onFinishedCallback:Callback):void{
			/*UI_Loading.hide();
			var ui:UI_PopupDLCReward = new UI_PopupDLCReward(this, mGame);
			ui.callbackOnClose = onFinishedCallback;*/
		}
		
		public function hasDLCBeenPurchasedBefore(mGame:MetaGameProgress):Boolean{
			/*if(mGame.metaStoreProgress.hasEverBeenPurchasedOnServer(this)) return true;
			if(mGame.metaStoreProgress.hasBoughtDLCBefore(this)) return true;*/
			return false;
		}
		
		public function needsToBeRestored(mGame:MetaGameProgress):Boolean{
			if(!hasBeenAwarded(mGame) && hasDLCBeenPurchasedBefore(mGame)) return true;
			return false;
		}
		
		public function hasBeenPurchased(mGame:MetaGameProgress):Boolean{
			return false;
			//return mGame.metaStatsProgress.metaStatsEver.getStatsFromModel(modelExternalItemAtFullPrice).isGreaterThanZero();
		}
		
		public function hasBeenAwarded(mGame:MetaGameProgress):Boolean{
			return false;
			//return mGame.metaChestItemsProgress.hasItemOfModel(modelhat.modelChestItem);
		}
		
		public function getCurrentPrice():Number{
			if(isOnFlashSale()) return currentMetaSale.salePrice;
			return price;
		}
		
		private function refreshPriceStr():void{
			if(isOnFlashSale()){
				priceCostStr = "$" + (currentMetaSale.salePrice-0.01);
			} else {
				priceCostStr = "$" + (price-0.01);
			}
		}
		
		public function getTitleTxt():String{
			return title.getText();
		}
		
		public function getDescForPaypalTxt():String {
			return getTitleTxt();
		}
		
		public function getPriceTagStr():String {
			if(!ExternalAPIManager.premiumAPI.connected) return priceCostStr;
			var prcieFromApi:String = ExternalAPIManager.premiumAPI.GetPriceTagOfItem(modelExternalItem) ;
			if(prcieFromApi == null || prcieFromApi == "") return priceCostStr;
			return ExternalAPIManager.premiumAPI.GetPriceTagOfItem(modelExternalItem);
		}
		
		public function getPriceTagFullPrice():String{
			if(!ExternalAPIManager.premiumAPI.connected) return "$" + (price-0.01);
			var prcieFromApi:String = ExternalAPIManager.premiumAPI.GetPriceTagOfItem(modelExternalItemAtFullPrice) ;
			if(prcieFromApi == null || prcieFromApi == "") return "$" + (price-0.01);
			return ExternalAPIManager.premiumAPI.GetPriceTagOfItem(modelExternalItemAtFullPrice);
		}
		
		public function isOnFlashSale():Boolean{
			return currentMetaSale != null;
		}
		
		public function setToSaleType(modelType:ModelFlashSaleType):void{
			for(var i:int = 0; i < saleTypes.length; i++){
				var metaSale:MetaFlashSaleType = saleTypes[i];
				if(metaSale.modelFlashSaleType.isEquals(modelType)) currentMetaSale = metaSale;
			}
			refreshPriceStr();
		}
		
		public function clearFlashSale():void{
			currentMetaSale = null;
			refreshPriceStr();
		}
		
		public function getFlashSalePrct():Number{
			if(!isOnFlashSale()) return 1;
			return currentMetaSale.modelFlashSaleType.salePrct;
		}
		
		public function addFlashSaleType(metaSale:MetaFlashSaleType):void{
			saleTypes.push(metaSale);
		}
		
		public function hasModelItemAsSale(model:ModelExternalItem):Boolean{
			for(var i:int = 0; i < saleTypes.length; i++){
				var metaSale:MetaFlashSaleType = saleTypes[i];
				if(metaSale.salePriceExternalItem.id == model.id) return true;
			}
			return false;
		}
		
		public function get modelExternalItem():ModelExternalItem{
			if(isOnFlashSale()) return currentMetaSale.salePriceExternalItem;
			return modelExternalItemAtFullPrice;
		}
		
		public static function create(modelExternalItem:ModelExternalItem, title:TextInstance, price:Number, frame:int, diamonds:int, bloodstones:int, items:Array, itemPromo:Array):MetaDLCPack{
			var result:MetaDLCPack = new MetaDLCPack(modelExternalItem, title, frame, diamonds, bloodstones,  items, itemPromo);
			result.price = price;
			result.priceCostStr = "$" + (price - 1) + ".99";
			return result;
		}
		
	}
}