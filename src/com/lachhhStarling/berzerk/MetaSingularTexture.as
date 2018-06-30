package com.lachhhStarling.berzerk {
	/**
	 * @author LachhhSSD
	 */
	public class MetaSingularTexture {
		public var isLoaded:Boolean = false;
		public var isLoading : Boolean = false;
		public var name : String;

		public function MetaSingularTexture(pName:String) {
			name = pName;
		}

		public function triggerLoaded() : void {
			isLoaded = true;
			isLoading = false;
		}
		
		public function triggerUnloaded():void {
			isLoaded = false;
			isLoading = false;
		}
		
		public function triggerLoading():void {
			isLoaded = false;
			isLoading = true;
		}
		
		public function canBeLoaded():Boolean {
			if(isLoaded) return false;
			if(isLoading) return false;
			return true;
		}
	}
}
