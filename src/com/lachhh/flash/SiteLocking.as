package com.lachhh.flash {
	import com.lachhh.lachhhengine.VersionInfo;

	import flash.display.DisplayObject;

	/**
	 * @author Simon Lachance
	 */
	public class SiteLocking {			
		static public const URL_SITELOCK_FGL:String = "flashgamelicense.com";
		static public const URL_SITELOCK_BERZERK:String = "berzerkstudio.com";
		static public const URL_SITELOCK_BERZERK_LAND:String = "berzerk-land.com";
		static public const URL_SITELOCK_ZOMBIDLE:String = "zombidle.com";
		static public const URL_SITELOCK_MIKESUCKS:String = "mikeducarmesucks.com";
		static public const URL_SITELOCK_KONG:String = "kongregate.com";
		static public const URL_SITELOCK_KIZI:String = "kizi.com";
		static public const URL_SITELOCK_ARMORGAMES:String = "armorgames.com";
		static public const URL_SITELOCK_MPSTATIC:String = "mpstatic.com";
		static public const URL_SITELOCK_LACHHHTV:String = "lachhh.tv";
		static public const URL_SITELOCK_NEWGROUNDS1:String = "newgrounds.com";
		static public const URL_SITELOCK_NEWGROUNDS2:String = "ungrounded.net";
		static public const URL_SITELOCK_NOTDOPPLER:String = "notdoppler.com";
		static public var DEBUG_FAKE_IM_ON_THIS_SITE:String = "";
		
		static public function feedSitesAllowed(sites:Array):void {
			
			sites.push(URL_SITELOCK_BERZERK);
			sites.push(URL_SITELOCK_BERZERK_LAND);
			sites.push(URL_SITELOCK_FGL);
			sites.push(URL_SITELOCK_ZOMBIDLE);
			sites.push(URL_SITELOCK_MIKESUCKS);
			sites.push(URL_SITELOCK_KONG);
			sites.push(URL_SITELOCK_MPSTATIC);
			sites.push(URL_SITELOCK_NEWGROUNDS1);
			sites.push(URL_SITELOCK_NEWGROUNDS2);
			sites.push(URL_SITELOCK_NOTDOPPLER);
			sites.push(URL_SITELOCK_ARMORGAMES);
			sites.push(URL_SITELOCK_LACHHHTV);
			
			
		}
		
		static public function isInSites(root:DisplayObject, a:Array):Boolean {
			for (var i:int = 0 ; i < a.length ; i++) {
				if(a[i] != null) {
					if(isInSite(root, a[i])) 
						return true;
				}	
			}
			return false;
		}
		
		static public function isInSite(root:DisplayObject, site:String) : Boolean {
			var siteURL:String ;
		
			if(site == "") {
				var i:int = root.loaderInfo.url.indexOf("file:///");
				return (i != -1);
			} else {
				if(VersionInfo.isDebug && (site == DEBUG_FAKE_IM_ON_THIS_SITE)) return true;
				
				siteURL = root.loaderInfo.url;
				var domain:String = siteURL.split("/")[2];
				if(domain == null) return false;
				if(domain.indexOf(site) == -1) return false;
				
				/*if(VersionInfo.ignoreExtensionDomain) {
					domain = domain.substring(domain.indexOf(site), domain.length);
					domain = domain.split(".")[0];
				} */
				
				if ((domain.indexOf(site) == (domain.length - site.length))) { 
					return true ;
				} else { 
					return false;
				}
			}
			
		}
		
		public static function isOnPIONetwork(root:DisplayObject) : Boolean {
			return isInSites(root, [URL_SITELOCK_MPSTATIC, URL_SITELOCK_LACHHHTV]);
		}

		public static function isOnYahoo(root:DisplayObject) : Boolean {
			return isInSites(root, [URL_SITELOCK_MPSTATIC]);
		}
		
		public static function isOnNewgrounds(root:DisplayObject) : Boolean {
			return isInSites(root, [URL_SITELOCK_NEWGROUNDS1, URL_SITELOCK_NEWGROUNDS2]);
		}

		public static function isOnArmorGames(root:DisplayObject) : Boolean {
			return isInSites(root, [URL_SITELOCK_ARMORGAMES]);
		}
		
		public static function isOnKizi(root:DisplayObject) : Boolean {
			return isInSites(root, [URL_SITELOCK_KIZI]);
		}

		public static function isOnKongregate(root:DisplayObject) : Boolean {
			return isInSites(root, [URL_SITELOCK_KONG]);
		}
		
		public static function isOnZombidle(root:DisplayObject) : Boolean {
			return isInSites(root, [URL_SITELOCK_ZOMBIDLE]);
		}
		
		public static function isOnNotDoppler(root:DisplayObject) : Boolean {
			return isInSites(root, [URL_SITELOCK_NOTDOPPLER]);
		}
		
		public static function isPlayedLocally(root:DisplayObject) : Boolean {
			return isInSites(root, [""]);
		}
		
	}
}
