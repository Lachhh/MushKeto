package com.berzerkrpg.debug {
	import com.berzerkrpg.io.MetaServerProgress;
	import com.berzerkrpg.meta.MetaGameProgress;
	/**
	 * @author LachhhSSD
	 */
	public class DebugGameProgress {
		static public function setGame1(mGameProgress:MetaGameProgress):void {
			//return ;
			MetaServerProgress.setServerDate(new Date());
			
		}
		
		
		
		static public function log(obj:Object):void{
			trace("[DEBUG GAME PROGRESS] : " + obj.toString());
		}
	}
}
