package com.berzerkrpg.meta {
	import com.berzerkrpg.io.ModelAdTypeEnum;
	import com.lachhh.io.Callback;
	import com.lachhh.io.ExternalAPIManager;

	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * @author LachhhSSD
	 */
	public class MetaExternalAdRequest {
		public var errorMsg:String = "";
		public var successCallback:Callback;
		public var adLoadedCallback:Callback;
		public var errorCallback:Callback;
		public var adCanceledByUserCallback:Callback;
		public var timeoutCallback:Callback;
		public var isAdLoaded : Boolean = false;
		public var isRewarded : Boolean = false;
		public var isCompleted : Boolean = false;
		public var isCanceledByUser : Boolean = false;
		public var adType:String = ModelAdTypeEnum.NEUTRAL;
		
		public var str1:String = "";
		public var str2:String = "";
		public var str3:String = "Devil Deal Bonus";
		public var str4:String = "";
		public var iconURL:String = "";
		public var metaDevilDeal:MetaDevilDeal = null;
		
		public var timeoutDelay:Number = 1000*10;
		private var timer:Timer = new Timer(timeoutDelay);

		public function MetaExternalAdRequest(pMetaDevilDeal:MetaDevilDeal) {
			metaDevilDeal = pMetaDevilDeal;
			iconURL = metaDevilDeal.modelDevilDeal.iconURL;
		}

		public function hasBeenRewarded() : Boolean {
			return (isRewarded);
		}
		
		public function load():void {
			timer.delay = timeoutDelay ;
			timer.start();
			timer.addEventListener(TimerEvent.TIMER, onTimerComplete);
			ExternalAPIManager.adsAPI.loadAds(this);
		}
		
		public function triggerError(msg:String):void {
			if(isCompleted) return ;
			isCompleted = true;
			isRewarded = false;
			errorMsg = msg;
			if(errorCallback) errorCallback.call();
		}
		
		public function triggerSuccess():void {
			if(isCompleted) return ;
			isCompleted = true;
			isRewarded = true;
			errorMsg = "";
			if(successCallback) successCallback.call();
		}
		
		public function triggerCanceledByUser():void {
			if(isCompleted) return ;
			isCompleted = true;
			isRewarded = false;
			isCanceledByUser = true;
			errorMsg = "";
			if(adCanceledByUserCallback) adCanceledByUserCallback.call();
		}
		
		public function triggerLoaded():void {
			if(isAdLoaded) return ;
			if(isCompleted) return ;
			isAdLoaded = true;
			timer.stop();
			if(adLoadedCallback) adLoadedCallback.call();
		}

		public function triggerLoadTimeout():void {
			timer.stop();
			if(isAdLoaded) return ;
			if(isCompleted) return ;
			isCompleted = true;
			
			
			if(timeoutCallback) timeoutCallback.call();
		}

		private function onTimerComplete(event : TimerEvent) : void {
			triggerLoadTimeout();
		}
	}
}
