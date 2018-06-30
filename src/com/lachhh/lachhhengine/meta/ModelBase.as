package com.lachhh.lachhhengine.meta {
	/**
	 * @author LachhhSSD
	 */
	public class ModelBase {
		static public var NULL:ModelBase = new ModelBase(-1, "");
		public var index : int ;
		public var id : String ;
		

		public function ModelBase(pIndex:int, pId:String) {
			index = pIndex;
			id = pId;
		}
		
		public function get isNull():Boolean {
			return id == ""; 
		}
		
		public function toString():String {
			if(isNull) return "null";
			return ""; 
		}
		
		public function isEquals(modelAnim:ModelBase):Boolean {
			if(modelAnim == null) return false;
			return (modelAnim.index == index);
		}
	}
}
