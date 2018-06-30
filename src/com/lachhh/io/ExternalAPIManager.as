package com.lachhh.io {
	import com.berzerkrpg.io.IAdsAPI;
	import com.lachhh.io.mobileShareAPI.IMobileShareAPI;
	import com.lachhh.io.notificationsAPI.INotificationsAPI;
	import com.lachhh.io.pioAccount.IPIOAccount;
	import com.lachhh.io.premiumAPI.IAchievementAPI;
	import com.lachhh.io.premiumAPI.IPremiumAPIController;
	import com.lachhh.io.savefileAPI.ISaveFileAPI;
	import com.lachhh.io.statsAPI.IStatsAPI;
	import com.lachhh.io.trackAPI.ITrackAPI;
	import com.lachhhStarling.BerzerkAnimationManager;

	/**
	 * @author Lachhh
	 */
	public class ExternalAPIManager {
		static private var _emptyController:EmptyController = new EmptyController();
		
		static public var savedFileAPI:ISaveFileAPI = _emptyController;
		static public var premiumAPI:IPremiumAPIController = _emptyController;
		static public var achievementAPI:IAchievementAPI = _emptyController;

		static public var platformPioAccount : IPIOAccount = _emptyController;
		static public var platformPremiumAPI:IPremiumAPIController = _emptyController;
		
		static public var statsAPI : IStatsAPI = _emptyController;
		static public var pioAccount : IPIOAccount = _emptyController;
		static public var trackerAPI : ITrackAPI = _emptyController;
		static public var adsAPI : IAdsAPI = _emptyController;
		
		
		static public var notificationsAPI : INotificationsAPI = _emptyController;
		static public var internetConnectAPI : IInternetCheckAPI = _emptyController;
		
		static public var mobileShareApi : IMobileShareAPI = _emptyController;
		static public var externalURLNavigator : IURLNavigator = _emptyController;
		
		
		//TOP REMOVE FROM HERE 
		static public var berzerkAnimationManager : BerzerkAnimationManager = null;
	}
}
