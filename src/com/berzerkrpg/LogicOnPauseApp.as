package com.berzerkrpg {
	import com.lachhh.io.CallbackGroup;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.lachhhengine.sfx.Jukebox;

	import flash.desktop.NativeApplication;
	import flash.events.Event;

	/**
	 * @author LachhhSSD
	 */
	public class LogicOnPauseApp {
		public var callbackOnPause:CallbackGroup = new CallbackGroup();
		public var callbackOnUnpause : CallbackGroup = new CallbackGroup();
		public var callbackOnClose : CallbackGroup = new CallbackGroup();
		public var autoSave:Boolean = true;

		public function LogicOnPauseApp() {
			super();
			NativeApplication.nativeApplication.addEventListener(Event.CLOSING, onClosing);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate);
		}
		
		public function onDeactivate(event : Event) : void {
			if(autoSave) {
				//LogicAutoSave.saveGameOnServerAndLocal();
				trace("Pause");
				
				Jukebox.SFX_MUTED = true;
				Jukebox.MUSIC_MUTED = true;
				Jukebox.getInstance().update();
			} 
						
			callbackOnPause.call();
		}

		public function onActivate(event : Event) : void {
			if(autoSave) {
				trace("Unpaused");
				
				Jukebox.SFX_MUTED = false;
				Jukebox.MUSIC_MUTED = false;
				ExternalAPIManager.trackerAPI.trackEvent("Misc.", "NumSessionUnpaused");
			}
			callbackOnUnpause.call();
			
		}

		private function onClosing(event : Event) : void {
			if(autoSave) {
				Jukebox.SFX_MUTED = true;
				Jukebox.MUSIC_MUTED = true;
				
				//LogicAutoSave.saveGameOnServerAndLocal();
				trace("Saved");
			}
			callbackOnClose.call();
		}
	}
}
