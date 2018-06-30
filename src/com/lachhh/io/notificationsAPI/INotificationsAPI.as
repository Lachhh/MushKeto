package com.lachhh.io.notificationsAPI {
	/**
	 * @author Shayne
	 */
	public interface INotificationsAPI {
		
		function get areNotificationsAvailable():Boolean;
		function get arePushNotificatiosnEnabled():Boolean;
		function setOneDayNotification(message:String):void;
		function setNotificationWithDelay(title:String, message:String, delayInSeconds:int):void;
		function disableLocalNotification():void;
		function enablePushNotifications():void;
		function disablePushNotifications():void;
		
	}
}
