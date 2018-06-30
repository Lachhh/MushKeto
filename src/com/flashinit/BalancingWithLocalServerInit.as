package com.flashinit {
	import com.lachhh.lachhhengine.VersionInfo;

	/**
	 * @author LachhhSSD
	 */
	public class BalancingWithLocalServerInit extends BalancingInit {
		public function BalancingWithLocalServerInit() {
			VersionInfo.isDebugPIO = true;
			super();
		}
	}
}
