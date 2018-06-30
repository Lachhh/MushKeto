package com.berzerkrpg.io.stats {
	import com.lachhh.flash.SecureNumber;
	/**
	 * @author Lachhh
	 */
	public class Stats {
		private var _debugName:String ;
		private var _secureNumber:SecureNumber ;
		
		public function Stats(secureNumber:SecureNumber, debugName:String) {
			_secureNumber = secureNumber;
			_debugName = debugName;
		}
		
		public function get debugName():String {
			return _debugName;
		}
		
		public function get secureNumber():SecureNumber {
			return _secureNumber;
		}
	}
}
