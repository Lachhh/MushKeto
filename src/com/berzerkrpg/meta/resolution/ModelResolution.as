package com.berzerkrpg.meta.resolution {
	import com.lachhh.lachhhengine.meta.ModelBase;

	/**
	 * @author Eel
	 */
	public class ModelResolution extends ModelBase {
		
		public var width:Number = 800;
		public var height:Number = 600;
		
		public function ModelResolution(pIndex:int, pId : String, pWidth:Number, pHeight:Number) {
			super(pIndex, pId);
			width = pWidth;
			height = pHeight;
		}
	}
}