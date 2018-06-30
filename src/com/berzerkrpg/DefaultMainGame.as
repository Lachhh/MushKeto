package com.berzerkrpg {
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.lachhh.flash.EmptyMainGame;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.MyMath;
	import com.lachhh.lachhhengine.sfx.Jukebox;
	import com.lachhh.lachhhengine.ui.UIBase;

	import flash.display.StageScaleMode;
	import flash.events.Event;
	/**
	 * @author LachhhSSD
	 */
	public class DefaultMainGame extends EmptyMainGame {
		static public var UI_CONTAINER_ABOVE_NO_CLICK:DisplayObjectContainer;
		static public var UI_CONTAINER_ABOVE:DisplayObjectContainer;
		static public var UI_CONTAINER:DisplayObjectContainer;
		static public var UI_CONTAINER_BELOW:DisplayObjectContainer;
		
		static public var jukeBox:Jukebox = new Jukebox();
		
		static public var safeBugUglyErrorCatching:Boolean = false;
		
		public function DefaultMainGame() {
			
		}
		
		override public function init():void {
			MyMath.init();
			KeyManager.init(this);
			
			UI_CONTAINER_ABOVE_NO_CLICK = ExternalAPIManager.berzerkAnimationManager.createEmpty();
			UI_CONTAINER_ABOVE = ExternalAPIManager.berzerkAnimationManager.createEmpty();
			UI_CONTAINER = ExternalAPIManager.berzerkAnimationManager.createEmpty();
			UI_CONTAINER_BELOW = ExternalAPIManager.berzerkAnimationManager.createEmpty();
			UI_CONTAINER_ABOVE_NO_CLICK.mouseChildren = false;
			UI_CONTAINER_ABOVE_NO_CLICK.mouseEnabled = false;
			UI_CONTAINER_ABOVE_NO_CLICK.name = "uiContainerAboveNoClick";
			UI_CONTAINER_ABOVE.name = "uiContainerAbove";
			UI_CONTAINER.name = "uiContainer";
			UI_CONTAINER_BELOW.name = "uiContainerBelow";
			
			UIBase.endTextFieldBatchForStarlingMc(UI_CONTAINER_ABOVE);
			 
			ExternalAPIManager.berzerkAnimationManager.getStage().addChild(UI_CONTAINER_BELOW);
			ExternalAPIManager.berzerkAnimationManager.getStage().addChild(UI_CONTAINER);
			ExternalAPIManager.berzerkAnimationManager.getStage().addChild(UI_CONTAINER_ABOVE);
			ExternalAPIManager.berzerkAnimationManager.getStage().addChild(UI_CONTAINER_ABOVE_NO_CLICK);
			
			addEventListener(Event.ENTER_FRAME, updateFlash);
			
			UIBase.defaultUIContainer = UI_CONTAINER ; 
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		override public function updateFlash(e:Event):void {
			if(safeBugUglyErrorCatching ){
				unitTestUpdate();
			} else {
				update();
			}
		}
		
		public function unitTestUpdate():void {
			try {
				update();
			} catch(e:Error) {
				trace("UNIT TEST ERROR : " + e.getStackTrace());
			}
		}
		
		override public function update():void {
			UIBase.manager.update();
			jukeBox.update();
		}
	}
}
