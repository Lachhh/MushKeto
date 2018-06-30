package com.lachhhStarling.format {
	import com.lachhh.lachhhengine.meta.ModelBase;

	/**
	 * @author Eel
	 */
	public class ModelImageFormat extends ModelBase {
		
		public var extension:String = "";
		
		public function ModelImageFormat(pIndex:int = -1, pId : String = "", pExtension:String = "") {
			super(pIndex, pId);
			extension = pExtension;
		}
		
		public function isATF():Boolean{
			return isEquals(ModelImageFormatEnum.ATF);
		}
	}
}