package com.berzerkstudio.mushketo {
	import com.lachhh.lachhhengine.VersionInfo;

	/**
	 * @author LachhhSSD
	 */
	public class MushKeto_iOs_Debug extends MushKeto_iOs {
		public function MushKeto_iOs_Debug() {
			VersionInfo.isDebug = true; 
			super();
		}
		
		/*override protected function languagesLoaded():void {
			MainGame.instance.startQuickDebug();
		}*/
	}
}
