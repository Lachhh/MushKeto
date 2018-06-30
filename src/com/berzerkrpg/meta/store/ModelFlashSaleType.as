package com.berzerkrpg.meta.store {
	import com.lachhh.lachhhengine.meta.ModelBase;

	/**
	 * @author Eel
	 */
	public class ModelFlashSaleType extends ModelBase {
		
		public var salePrct:Number = 1;
		
		public function ModelFlashSaleType(pId : String, pSalePrct:Number) {
			super(pId);
			salePrct = pSalePrct;
		}
	}
}