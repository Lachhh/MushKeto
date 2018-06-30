package com.lachhh.lachhhengine {
	import com.lachhh.flash.FlashUtils;
	/**
	 * @author LachhhSSD
	 */
	public class VersionBuild {
		public var version:String = "";
		public var major:int = 0;
		public var minor:int = 0;
		public var build:int = 0;
		
		public function VersionBuild(pVersion:String) {
			version = pVersion;
			if(version == null) return ;
			var a:Array = version.split(".");
			if(a.length >= 1) major = getNumber(a[0]);
			if(a.length >= 2) minor = getNumber(a[1]);
			if(a.length >= 3) build = getNumber(a[2]);
		}
		
		static public function removeNonDigitChar(str:String):String {
			var resultStr:String = "";
			for (var i : int = 0; i < str.length; i++) {
				var c:String = str.substr(i, 1);
				var digit:int = parseInt(c);
				if(digit == 0 && c != "0") continue;
				resultStr += c;
			}
			return resultStr;
		}
		
		static public function getNumber(str:String):int {
			var digitsOnly:String = removeNonDigitChar(str);
			var result:int = FlashUtils.myParseFloat(digitsOnly);
			return result; 
		}
		
		public function isNewerThanIgnoreBuilds(v:VersionBuild):Boolean {
			if(major > v.major) return true;
			if(major < v.major) return false;
			if(minor > v.minor) return true;
			if(minor < v.minor) return false;
			return false;
		}
		                                        
		
		public function isNewerThan(v:VersionBuild):Boolean {
			if(major > v.major) return true;
			if(major < v.major) return false;
			if(minor > v.minor) return true;
			if(minor < v.minor) return false;
			if(build > v.build) return true;
			if(build < v.build) return false;
			return false;
		}
		
		public function isEquals(v:VersionBuild):Boolean {
			if(v.major != major) return false;
			if(v.minor != minor) return false;
			if(v.build != build) return false;
			return true;
		}
	}
}
