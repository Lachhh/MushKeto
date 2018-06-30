package com.berzerkrpg.meta.store {
	import playerio.DatabaseObject;

	import com.berzerkrpg.constants.GameConstants;
	import com.berzerkrpg.io.MetaServerProgress;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.lachhh.flash.FlashUtils;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.utils.Utils;
	/**
	 * @author Eel
	 */
	public class MetaSale {
		
		private var rawDBObj:DatabaseObject;
		
		public var saleStart:Date = new Date();
		public var saleEnd:Date = new Date();
		public var saleTitle:String = "";
		public var salePlatforms:String = "";
		public var hasBeenLoaded:Boolean = false;
		
		public function MetaSale(){
			
		}
		
		public function decode(dbObj:DatabaseObject):void{
			rawDBObj = dbObj;
			saleStart = dbObj["saleStarts"];
			saleEnd = dbObj["saleEnds"];
			salePlatforms = dbObj["forPlatform"];
			saleTitle = dbObj["saleTitle"];
			hasBeenLoaded = true;
		}
		
		public function hasFlashSaleData():Boolean{
			if(!hasBeenLoaded) return false;
			if(rawDBObj == null) return false;
			if(rawDBObj["item1"] == null) return false;
			if(rawDBObj["item1"]["saleType"] == null) return false;
			return true;
		}
		
		public function hasDoubleDiamondData():Boolean{
			if(!hasBeenLoaded) return false;
			if(rawDBObj == null) return false;
			if(rawDBObj["item1"] == null) return false;
			if(rawDBObj["item1"]["newDiamonds"] == null) return false;
			return true;
		}
		
		public function hasDoubleDiamondDataForPack(m:MetaDiamondPack):Boolean{
			if(!hasBeenLoaded) return false;
			if(rawDBObj == null) return false;
			if(rawDBObj[m.modelExternalItemFullPrice.id] == null) return false;
			if(rawDBObj[m.modelExternalItemFullPrice.id]["newDiamonds"] == null) return false;
			if(rawDBObj[m.modelExternalItemFullPrice.id]["newBloodstones"] == null) return false;
			return true;
		}
		
		public function hasFlashSaleDataForPack(m:MetaDiamondPack):Boolean{
			if(!hasBeenLoaded) return false;
			if(rawDBObj == null) return false;
			if(rawDBObj[m.modelExternalItemFullPrice.id] == null) return false;
			if(rawDBObj[m.modelExternalItemFullPrice.id]["saleType"] == null) return false;
			return true;
		}
		
		public function hasFlashSaleDataForDLC(m:MetaDLCPack):Boolean{
			if(!hasBeenLoaded) return false;
			if(rawDBObj == null) return false;
			if(rawDBObj[m.modelExternalItemAtFullPrice.id] == null) return false;
			if(rawDBObj[m.modelExternalItemAtFullPrice.id]["saleType"] == null) return false;
			return true;
		}
		
		public function applyFlashSaleToDLC(m:MetaDLCPack):void{
			if(!hasBeenLoaded) return;
			if(!hasFlashSaleDataForDLC(m)) return;
			var modelSale:ModelFlashSaleType = ModelFlashSaleTypeEnum.getFromId(rawDBObj[m.modelExternalItemAtFullPrice.id]["saleType"]);
			if(modelSale.isNull) return;
			m.setToSaleType(modelSale);
		}
		
		public function applyFlashSaleToPack(m:MetaDiamondPack):void{
			if(!hasBeenLoaded) return;
			if(!hasFlashSaleDataForPack(m)) return;
			var modelSale:ModelFlashSaleType = ModelFlashSaleTypeEnum.getFromId(rawDBObj[m.modelExternalItemFullPrice.id]["saleType"]);
			if(modelSale.isNull) return;
			m.setToSaleType(modelSale);
		}
		
		public function applyDoubleDiamondsToPack(m:MetaDiamondPack):void{
			if(!hasBeenLoaded) return;
			if(!hasDoubleDiamondDataForPack(m)) return;
			m.numDiamondsBonusDeal = rawDBObj[m.modelExternalItemFullPrice.id]["newDiamonds"];
			m.numBloodstonesBonusDeal = rawDBObj[m.modelExternalItemFullPrice.id]["newBloodstones"];
		}
		
		public function isSaleInProgress():Boolean{
			if(!hasBeenLoaded) return false;
			if(!MetaServerProgress.hasServerDate()) return false;
			if(saleStart == null) return false;
			if(saleEnd == null) return false;
			if(!isSaleForMyPlatform()) return false;
			return (saleStart < MetaServerProgress.serverDate) && (saleEnd > MetaServerProgress.serverDate);
		}
		
		private function isSaleForMyPlatform():Boolean{
			if(!hasBeenLoaded) return false;
			if(salePlatforms == "all") return true;
			var platforms:Array = salePlatforms.split(",");
			for(var i:int = 0; i < platforms.length; i++){
				var p:String = platforms[i];
				if(p == VersionInfo.modelPlatform.id) return true;
				if(p == VersionInfo.modelPlatform.modelPlatformType.id) return true;
			}
			return false;
		}
		
		public function getDurationOfDealInMs():Number{
			if(!hasBeenLoaded) return 0;
			if(saleEnd == null) return 0;
			return saleEnd.time - MetaServerProgress.myGetDateMs();
		}
		
		public function shouldBounceTimerText():Boolean{
			if(!isSaleInProgress()) return false;
			return getDurationOfDealInMs() < GameConstants.DAYS;
		}
		
		public function getTitleOfBonusDeal():String{
			return saleTitle;
		}
		
		public function getDurationBonusDealDaysString():String{
			var days:int = Math.floor(getDurationOfDealInMs() / GameConstants.DAYS);
			
			if(days == 1) return TextFactory.ONE_DAY_LEFT.getText();
			if(days < 1) return Utils.MsToTime(getDurationOfDealInMs());
			
			var result:String = TextFactory.DAYS_LEFT.getText();
			result = FlashUtils.myReplace(result, "[x]", days+"");
			return result;
		}
		
		public static function create(dbObj:DatabaseObject):MetaSale{
			var result:MetaSale = new MetaSale();
			result.decode(dbObj);
			return result;
		}
		
		public static function createEmpty():MetaSale{
			var result:MetaSale = new MetaSale();
			return result;
		}
		
	}
}