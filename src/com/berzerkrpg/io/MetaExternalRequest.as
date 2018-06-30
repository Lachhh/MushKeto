package com.berzerkrpg.io {
	import com.lachhh.io.Callback;

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * @author LachhhSSD
	 */
	public class MetaExternalRequest {
		public var errorMsg:String = "";
		public var successCallback:Callback;
		public var errorCallback:Callback;
		public var timeoutCallback:Callback;
		public var isCompleted : Boolean = false;
		
		public var timeoutDelay:Number = 1000*10;
		private var timer:Timer = new Timer(timeoutDelay);

		public function MetaExternalRequest() {
			
		}
		
		public function startTimer():void {
			if(timer.running) return;
			timer.delay = timeoutDelay ;
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onTimerComplete);
		}
		
		public function triggerError(msg:String):void {
			if(isCompleted) return ;
			isCompleted = true;
			errorMsg = msg;
			if(errorCallback) errorCallback.call();
		}
		
		public function triggerSuccess():void {
			if(isCompleted) return ;
			isCompleted = true;
			errorMsg = "";
			if(successCallback) successCallback.call();
		}

		public function triggerLoadTimeout():void {
			timer.stop();
			if(isCompleted) return ;
			isCompleted = true;
			
			errorMsg = "Request Timeout";
			if(timeoutCallback) {
				timeoutCallback.call();
			} else {
				if(errorCallback) errorCallback.call();
			}
		}
		
		public function createTriggerSuccessCallback():Callback {
			return new Callback(triggerSuccess, this, null);
		}
		
		public function createTriggerErrorCallback():Callback {
			return new Callback(triggerError, this, null);
		}

		private function onTimerComplete(event : TimerEvent) : void {
			triggerLoadTimeout();
		}
	}
}
