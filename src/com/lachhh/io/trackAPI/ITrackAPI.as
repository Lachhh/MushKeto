package com.lachhh.io.trackAPI {

	/**
	 * @author LachhhSSD
	 */
	public interface ITrackAPI {
		function trackView(arg0:String):void
		function trackEvent(arg0:String, arg1:String):void
		function trackEventWithValue(nameEvent:String, nameValue:String, value:int):void
	}
}
