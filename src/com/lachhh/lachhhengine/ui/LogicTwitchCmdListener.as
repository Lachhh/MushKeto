package com.lachhh.lachhhengine.ui {
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class LogicTwitchCmdListener extends ActorComponent {
		private var metaTwitchCmds : Vector.<MetaTwitchCmd> = new Vector.<MetaTwitchCmd>();
		public function LogicTwitchCmdListener() {
			super();
		}
		
		public function addTwitchCmd(metaTwitch:MetaTwitchCmd):MetaTwitchCmd {
			metaTwitchCmds.push(metaTwitch);
			return metaTwitch;
		}
		
		public function executeFirstMatchingTwitchCmd(cmd:String):void {
			var metaCmd:MetaTwitchCmd = getTwitchCmdIfListening(cmd);
			if(metaCmd)  {
				metaCmd.execute();
				return ;
			}
		}
		
		public function getTwitchCmdIfListening(cmd:String):MetaTwitchCmd {
			if(!enabled) return null;
			for (var i : int = 0; i < metaTwitchCmds.length; i++) {
				var metaTwitchCmd:MetaTwitchCmd = metaTwitchCmds[i];
				if(metaTwitchCmd.canExecuteWithCmd(cmd)) {
					return metaTwitchCmd;
				} 
			}
			return null;
		}
	}
}
