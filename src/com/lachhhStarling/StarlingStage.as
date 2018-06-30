package com.lachhhStarling {
	import starling.display.Sprite;

	/**
	 * @author LachhhSSD
	 */
	public class StarlingStage extends Sprite {
		static public var instance:StarlingStage;
		
		public function StarlingStage() {
			instance = this;
		}
	}
}
