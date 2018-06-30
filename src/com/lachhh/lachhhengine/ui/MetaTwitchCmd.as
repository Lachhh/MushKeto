package com.lachhh.lachhhengine.ui {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.lachhh.io.Callback;
	/**
	 * @author LachhhSSD
	 */
	public class MetaTwitchCmd {
		public var cmd:String ;
		public var callback : Callback ;
		public var visual : DisplayObject;

		public function MetaTwitchCmd() {
		}

		public function execute() : void {
			if(callback) callback.call();
		}
		
		public function canExecuteWithCmd(pCmd:String):Boolean {
			if(visual && !visual.visible) return false;
			var cmdToLower:String  = cmd.toLowerCase();
			var cmdToLower2:String  = pCmd.toLowerCase();
			if(cmdToLower != cmdToLower2) return false;
			return true; 
		}
		
		static public function create(pCmd:String, visual:DisplayObject, pCallback:Callback):MetaTwitchCmd {
			var result:MetaTwitchCmd = new MetaTwitchCmd();
			result.cmd = pCmd;
			result.callback = pCallback;
			result.visual = visual;
			return result;
		}
		
		static public function createWithFct(pCmd:String, visual:DisplayObject, fct:Function):MetaTwitchCmd {
			var result:MetaTwitchCmd = new MetaTwitchCmd();
			result.cmd = pCmd;
			result.callback = new Callback(fct, null, null);
			result.visual = visual;
			return result;
		}
	}
}
