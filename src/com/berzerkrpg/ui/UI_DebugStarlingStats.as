package com.berzerkrpg.ui {
	import com.animation.exported.UI_DEBUGSTARLINGSTATS;
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.ui.UIBaseFlashOnly;
	import com.lachhhStarling.berzerk.BerzerkStarlingManager;

	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 * @author LachhhSSD
	 */
	public class UI_DebugStarlingStats extends UIBaseFlashOnly{
		private var viewModel : ViewDebugModelFlaGroup;
		public function UI_DebugStarlingStats() {
			super(UI_DEBUGSTARLINGSTATS);
			
			viewModel = new ViewDebugModelFlaGroup(this, panel);
		}

		override public function start() : void {
			super.start();
		}
		
		

		override public function update() : void {
			super.update();
			if(visualFlash.currentFrame == 7) {
				txt.text = "";
				txt.appendText("Draw Call : " + BerzerkStarlingManager.instance.lastDrawCount + "\n");
				//txt.appendText("Num Quads : " + BerzerkStarlingManager.instance.bzkStarlingShapeObjectRenderer.numShapeObject + "\n");
				txt.appendText("Texture Changed : " + BerzerkStarlingManager.instance.bzkStarlingShapeObjectRenderer.numTextureChanged + "\n");
				txt.appendText("Texture Static : " + BerzerkStarlingManager.instance.bzkStarlingShapeObjectRenderer.numTextureStatic + "\n");
				viewModel.refresh();
			}
			checkToOpenClose();
			
		}
		
		private function checkToOpenClose():void {
			if(visualFlash.currentFrame <= 1 || visualFlash.currentFrame >= 15) {
				if(isMouseLessThan(20, 20)) visualFlash.gotoAndStop(7);
			} else {
				if(!isMouseLessThan(300, 75)) visualFlash.gotoAndStop(15);
			}
		}
		
		private function isMouseLessThan(x:int, y:int):Boolean {
			if(KeyManager.GetMousePos().x > x) return false;
			if(KeyManager.GetMousePos().y > y) return false;
			return true;
		}
			
		public function get panel() : MovieClip { return visualFlash.getChildByName("panel") as MovieClip;}
		public function get txt() : TextField { return panel.getChildByName("txt") as TextField;}
	}
}
