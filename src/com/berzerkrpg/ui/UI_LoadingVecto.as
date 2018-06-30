package com.berzerkrpg.ui {
	import com.animation.exported.UI_LOADING;
	import com.lachhh.ResolutionManager;

	import flash.display.Stage;
	import flash.text.TextField;

	/**
	 * @author LachhhSSD
	 */
	public class UI_LoadingVecto {
		static public var instance : UI_LoadingVecto;
		private var visual : UI_LOADING;
		

		public function UI_LoadingVecto(stage : Stage) {
			visual = new UI_LOADING();
			stage.addChild(visual);
			refresh();
		}
		
		private function destroy() : void {
			if(visual.parent)visual.parent.removeChild(visual);
			visual.stop();
			visual = null;
		}
		
		public function refresh():void {
			visual.x = ResolutionManager.windowSize.width*0.5;
			visual.y = ResolutionManager.windowSize.height*0.5;
		}
		
		public function get msgTxt() : TextField { return visual.getChildByName("msgTxt") as TextField;}
		
		static public function show(stage:Stage, msg:String):UI_LoadingVecto {
			
			if(instance == null) {
				instance = new UI_LoadingVecto(stage);
			}
			
			instance.msgTxt.text = msg;
			instance.refresh();
			return instance;
		}
		
		static public function hide():void {
			
			if (instance) {
				instance.destroy();
				instance = null;
			}
			
		}

	
	}
}
