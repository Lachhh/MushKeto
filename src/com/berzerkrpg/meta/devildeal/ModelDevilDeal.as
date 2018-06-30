package com.berzerkrpg.meta.devildeal {
	import com.lachhh.lachhhengine.meta.ModelBase;

	/**
	 * @author LachhhSSD
	 */
	public class ModelDevilDeal extends ModelBase {
		public var frame : int = 0;
		public var iconURL : String;
		public var trackerId : String;

		public function ModelDevilDeal(pIndex:int, pId : String, pFrame : int, pTrackerId:String, pIconURL:String) {
			super(pIndex, pId);
			frame = pFrame;
			iconURL = pIconURL;
			trackerId = pTrackerId;
		}
		

	}
}
