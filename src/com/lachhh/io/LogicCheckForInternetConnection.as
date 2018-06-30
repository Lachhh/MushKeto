package com.lachhh.io {
	import air.net.URLMonitor;

	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	/**
	 * @author Shayne
	 */
	public class LogicCheckForInternetConnection implements IInternetCheckAPI {
	
		private var monitor:URLMonitor;
		
		private var _isInternetConnected:Boolean = false;
		
		public var onConnectedCallback:CallbackGroup;
		public var onDisconnectedCallback:CallbackGroup;
	
		public function LogicCheckForInternetConnection() {
			NativeApplication.nativeApplication.addEventListener(Event.NETWORK_CHANGE, onNetworkChange);
			onNetworkChange(null);
		}
		
		private function onNetworkChange(e:Event):void{
			monitor = new URLMonitor(new URLRequest("http://www.google.com"));
			monitor.addEventListener(StatusEvent.STATUS, testNetworkConnected);
			monitor.start();
		}
		
		private function testNetworkConnected(e:StatusEvent):void{
			if(_isInternetConnected != monitor.available){
				_isInternetConnected = monitor.available;
				onConnectedChange();
			}
			monitor.stop();
		}
		
		private function onConnectedChange():void{
			if(_isInternetConnected){
				if(onConnectedCallback) onConnectedCallback.call();
			} else {
				if(onDisconnectedCallback) onDisconnectedCallback.call();
			}
		}

		public function get isInternetConnected() : Boolean {
			return _isInternetConnected;
		}
	}
}
