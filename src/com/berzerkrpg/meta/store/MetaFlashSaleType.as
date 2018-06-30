package com.berzerkrpg.meta.store {
	import com.berzerkrpg.meta.ModelExternalAchievement;
	import com.lachhh.io.premiumAPI.ModelExternalItem;
	/**
	 * @author Eel
	 */
	public class MetaFlashSaleType {
		
		public var modelFlashSaleType:ModelFlashSaleType;
		public var fullPriceExternalItem:ModelExternalItem;
		public var salePriceExternalItem:ModelExternalItem;
		public var isDLC:Boolean = false;
		public var salePrice:Number = 1;
		
		public function MetaFlashSaleType(pModelSaleType:ModelFlashSaleType, pFullPriceExternalItem:ModelExternalItem, pSalePriceExternalItem:ModelExternalItem, pSalePrice:Number, pIsDLC:Boolean){
			modelFlashSaleType = pModelSaleType;
			fullPriceExternalItem = pFullPriceExternalItem;
			salePriceExternalItem = pSalePriceExternalItem;
			isDLC = pIsDLC;
			salePrice = pSalePrice;
		}
		
		public static function create(modelSaleType:ModelFlashSaleType, itemAtFullPrice:ModelExternalItem, itemAtSalePrice:ModelExternalItem, salePrice:Number, isDLC:Boolean):MetaFlashSaleType{
			var result:MetaFlashSaleType = new MetaFlashSaleType(modelSaleType, itemAtFullPrice, itemAtSalePrice, salePrice, isDLC);
			return result;
		}
		
	}
}