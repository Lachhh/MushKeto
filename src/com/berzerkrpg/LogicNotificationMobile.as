package com.berzerkrpg {
	import com.lachhh.io.CallbackGroup;
	import com.lachhh.io.ExternalAPIManager;

	import flash.desktop.NativeApplication;
	import flash.events.Event;

	/**
	 * @author LachhhSSD
	 */
	public class LogicNotificationMobile {
		public var callbackOnPause:CallbackGroup = new CallbackGroup();
		public var callbackOnUnpause : CallbackGroup = new CallbackGroup();
		public var callbackOnClose : CallbackGroup = new CallbackGroup();

		public function LogicNotificationMobile() {
			super();
			NativeApplication.nativeApplication.addEventListener(Event.CLOSING, onClosing);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
		}
		
		public function onDeactivate(event : Event) : void {
			//setNotification();
		}

		public function onActivate(event : Event) : void {
			resetNotifications();
		}

		private function resetNotifications() : void {
			ExternalAPIManager.notificationsAPI.disableLocalNotification();
		}

		private function onClosing(event : Event) : void {
			//setNotification();
		}
		

	
		
	}
}
