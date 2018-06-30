package com.berzerkrpg.meta.store {
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.multilingual.TextInstance;
	import com.lachhh.flash.FlashUtils;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.io.premiumAPI.ModelExternalItem;
	/**
	 * @author LachhhSSD
	 */
	public class MetaDiamondPack {
		public var titleTxt:TextInstance = TextFactory.DIAMONDSPACK1_TITLE;
		public var descTxt:TextInstance = TextFactory.DIAMONDSPACK_DESC;
		public var price:Number ;
		public var priceCostStr:String = "$0.99";
		public var numDiamonds:int = 5;
		public var numBloodstones:int = 20;
		public var isBestValue:Boolean = false;
		public var isMostPopular : Boolean = false;
		public var iconFrame : int = 1;
		public var modelExternalItemFullPrice : ModelExternalItem;
		public var numBloodstonesBonusDeal:int = -1;
		public var numDiamondsBonusDeal:int = -1;
		
		private var saleTypes:Vector.<MetaFlashSaleType> = new Vector.<MetaFlashSaleType>();
		private var currentMetaSale:MetaFlashSaleType = null;

		public function MetaDiamondPack() {
		}
		
		public function getCurrentPrice():Number{
			if(isOnFlashSale()) return currentMetaSale.salePrice;
			return price;
		}

		public function getTitleTxt() : String {
			var msg:String = titleTxt.getText();
			//if(isBestValue) msg += " ("+TextFactory.BEST_VALUE.getText() +")";
			//if(isMostPopular) msg += " ("+TextFactory.MOST_POPULAR.getText() +")";
			return msg ;
		}
		
		public function resetBonusDealSettings():void{
			numBloodstonesBonusDeal = -1;
			numDiamondsBonusDeal = -1;
		}
		
		public function isOnBonusDeal():Boolean{
			if(numBloodstonesBonusDeal != -1) return true;
			if(numDiamondsBonusDeal != -1) return true;
			return false;
		}
		
		public function setToSaleType(modelType:ModelFlashSaleType):void{
			for(var i:int = 0; i < saleTypes.length; i++){
				var metaSale:MetaFlashSaleType = saleTypes[i];
				if(metaSale.modelFlashSaleType.isEquals(modelType)) currentMetaSale = metaSale;
			}
			refreshPriceStr();
		}
		
		public function getFlashSalePrct():Number{
			if(!isOnFlashSale()) return 1;
			return currentMetaSale.modelFlashSaleType.salePrct;
		}
		
		public function clearFlashSale():void{
			currentMetaSale = null;
			refreshPriceStr();
		}
		
		public function isOnFlashSale():Boolean{
			return currentMetaSale != null;
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
		
		public function getBloodstonesNum():int{
			return Math.max(numBloodstones, numBloodstonesBonusDeal);
			/*if(numBloodstonesSale == -1){
				return numBloodstones;
			} else {
				return numBloodstonesSale;
			}
			 * 
			 */
		}
		
		public function getDiamondsNum():int{
			return Math.max(numDiamonds, numDiamondsBonusDeal);
			/*if(numDiamondsSale == -1){
				return numDiamonds;
			} else {
				return numDiamondsSale;
			}
			 * 
			 */
		}
		
		public function get modelExternalItem():ModelExternalItem{
			if(isOnFlashSale()) return currentMetaSale.salePriceExternalItem;
			return modelExternalItemFullPrice;
		}
		
		public function getBloodstonesStr():String {
			/*
			var metaStoreProgress:MetaStoreProgress = MetaGameProgress.instance.metaStoreProgress;
			var firstPack:MetaDiamondPack = metaStoreProgress.metaDiamondsPack1;
			var diamondsPerDollar:Number = firstPack.numDiamonds/firstPack.price;
			var diamondsThatShouldGiveAtSameRatio : Number = diamondsPerDollar * price;
			var diff : Number = (numDiamonds - diamondsThatShouldGiveAtSameRatio);
			var diffInPrct : Number = (numDiamonds / diamondsThatShouldGiveAtSameRatio) - 1;
			diffInPrct = Math.round(diffInPrct*100);
			if(diff <= 0) return "";
			
			var result:String = TextFactory.X_IN_BONUS.getText(); 
			result = FlashUtils.myReplace(result, "[x]", diff+"");
			return result;
			 * 
			 */
			 
			 var result:String = TextFactory.BLOODSTONES_IN_PACK.getText();
			 result = FlashUtils.myReplace(result, "[x]", numBloodstones + "");
			 return result;
		}
		
		public function getBonusDealDiamondsStr():String{
			var msg:String = descTxt.getText();
			msg = FlashUtils.myReplace(msg, "[x]", numDiamondsBonusDeal+"");
			
			return msg;
		}
		
		public function getBonusDealBloodstonesStr():String{
			var result:String = TextFactory.BLOODSTONES_IN_PACK.getText();
			 result = FlashUtils.myReplace(result, "[x]", numBloodstonesBonusDeal + "");
			 return result;
		}
		
		public function getDiamondsStr():String {
			var msg:String = descTxt.getText();
			msg = FlashUtils.myReplace(msg, "[x]", numDiamonds+"");
			
			return msg;
		}
		
		public function getDescForPaypalTxt():String {
			var msg:String = TextFactory.DIAMONDSPACK_DESC2.getText();
			msg = FlashUtils.myReplace(msg, "[x]", getDiamondsNum()+"");
			
			return getTitleTxt() + ", " + msg;
		}
		
		public function getDescForPioNetwork() : String {
			var msgDiamonds:String = TextFactory.DIAMONDSPACK_DESC2.getText();
			msgDiamonds = FlashUtils.myReplace(msgDiamonds, "[x]", getDiamondsNum()+"");
			
			var msgBloodstones:String = getBloodstonesStr() + " " + TextFactory.BLOODSTONES.getText();
			
			return msgDiamonds + ", " + msgBloodstones;
		}
		
		private function refreshPriceStr():void{
			if(isOnFlashSale()){
				priceCostStr = "$" + (currentMetaSale.salePrice-0.01);
			} else {
				priceCostStr = "$" + (price-0.01);
			} 
		}
		
		public function getPriceTagStr():String {
			if(!ExternalAPIManager.premiumAPI.connected) return priceCostStr;
			var prcieFromApi:String = ExternalAPIManager.premiumAPI.GetPriceTagOfItem(modelExternalItem) ;
			if(prcieFromApi == null || prcieFromApi == "") return priceCostStr;
			return ExternalAPIManager.premiumAPI.GetPriceTagOfItem(modelExternalItem);
		}
		
		public function getPriceTagFullPrice():String{
			if(!ExternalAPIManager.premiumAPI.connected) return "$" + (price-0.01);
			var prcieFromApi:String = ExternalAPIManager.premiumAPI.GetPriceTagOfItem(modelExternalItemFullPrice) ;
			if(prcieFromApi == null || prcieFromApi == "") return "$" + (price-0.01);
			return ExternalAPIManager.premiumAPI.GetPriceTagOfItem(modelExternalItemFullPrice);
		}
		
		static public function create(iconFrame:int, title:TextInstance, desc:TextInstance, price:Number, numDiamonds:int, numBloodstones:int, modelExternalItem:ModelExternalItem):MetaDiamondPack {
			var result:MetaDiamondPack = new MetaDiamondPack();
			result.iconFrame = iconFrame;
			result.titleTxt = title;
			result.descTxt = desc;
			result.priceCostStr = "$" + (price - 1) + ".99";
			result.price = price;
			result.numDiamonds = numDiamonds;
			result.numBloodstones = numBloodstones;
			result.modelExternalItemFullPrice = modelExternalItem;
			
			return result;
		}

	

		
	}
}
