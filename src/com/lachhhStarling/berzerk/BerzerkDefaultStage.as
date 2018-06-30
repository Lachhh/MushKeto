package com.lachhhStarling.berzerk {
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.berzerkstudio.flash.display.Stage;
	/**
	 * @author LachhhSSD
	 */
	public class BerzerkDefaultStage {
		static public var UI_BERZERK_CONTAINER_ABOVE_NO_CLICK:DisplayObjectContainer;
		static public var UI_BERZERK_CONTAINER_ABOVE:DisplayObjectContainer;
		static public var UI_BERZERK_CONTAINER : DisplayObjectContainer;
		static public var UI_BERZERK_CONTAINER_BELOW : DisplayObjectContainer;
		public var stage:Stage;

		public function BerzerkDefaultStage() {
			stage = new Stage();
			UI_BERZERK_CONTAINER_ABOVE_NO_CLICK = new DisplayObjectContainer();
			UI_BERZERK_CONTAINER_ABOVE = new DisplayObjectContainer();
			UI_BERZERK_CONTAINER = new DisplayObjectContainer();
			UI_BERZERK_CONTAINER_BELOW = new DisplayObjectContainer();
			stage.addChild(UI_BERZERK_CONTAINER_BELOW);
			stage.addChild(UI_BERZERK_CONTAINER);
			stage.addChild(UI_BERZERK_CONTAINER_ABOVE);
			stage.addChild(UI_BERZERK_CONTAINER_ABOVE_NO_CLICK);
		}
	}
}
