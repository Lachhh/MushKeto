package com.berzerkrpg.io {
	import com.berzerkrpg.meta.MetaExternalAdRequest;
	/**
	 * @author LachhhSSD
	 */
	public interface IAdsAPI {
		function loadAds(result : MetaExternalAdRequest) : MetaExternalAdRequest ;
		function playAds() : void ;
		function isConnected():Boolean
		function isReadyToPlayAd():Boolean
		function canShowScrolls():Boolean  
	}
}
