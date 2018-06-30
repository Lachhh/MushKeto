package com.flashinit {
	import com.berzerkrpg.meta.ModelPlatformEnum;
	import com.lachhh.lachhhengine.VersionInfo;

	/**
	 * @author LachhhSSD
	 */
	public class DebugStarlingInitCleanHD extends DebugStarlingInitClean {
		public function DebugStarlingInitCleanHD() {
			VersionInfo.isHDTexture = true;
			VersionInfo.modelPlatform = ModelPlatformEnum.DESKTOP_ITCH_IO;
			super();
		}
	}
}
