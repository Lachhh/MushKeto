package com.lachhh.lachhhengine.components {
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.sfx.DynamicMusic;
	import com.lachhh.lachhhengine.sfx.SfxFactory;

	import flash.media.Sound;

	/**
	 * @author LachhhSSD
	 */
	public class JukeboxDynamicMusicComponent extends ActorComponent {		
		public var sfxViewDynamic:DynamicMusic;
		public var gotoVolume:Number = 1 ;
		public var gotoVolumeMod:Number = 0.01;
		
		private var destroyOnZeroVolume:Boolean = false;
		public function JukeboxDynamicMusicComponent() {
			super();
			sfxViewDynamic = new DynamicMusic();
			debugInfo = "MUSIC:" + "> " + sfxViewDynamic.debugSoundName;
		}
				
		override public function destroy() : void {
			super.destroy();
			sfxViewDynamic.destroy();
		}
		
		public function fadeToDestroy(nFrames:int):void {
			destroyOnZeroVolume = true;
			fadeTo(0, nFrames);
		}
		
		public function fadeTo(volume:Number, nFrames:int):void {
			gotoVolume = volume;
			gotoVolumeMod = (1/(nFrames+0.0));
		}
		
		public function play():void {
			if(destroyed) return ;
			sfxViewDynamic.play();
		}
		
		public function stop():void {
			if(destroyed) return ;
			sfxViewDynamic.stop();	
		}
		
		
		override public function update() : void {
			super.update();
			updateVolume();
			checkIfMustDestroy();
		}
		
		private function updateVolume():void {
			if(sfxViewDynamic.volume > gotoVolume) {
				sfxViewDynamic.volume -= gotoVolumeMod;
			} else if(sfxViewDynamic.volume < gotoVolume) {
				sfxViewDynamic.volume += gotoVolumeMod;
			}
		}
		
		private function checkIfMustDestroy():void {
			var needToDestroy:Boolean = (destroyOnZeroVolume && sfxViewDynamic.volume <= 0);
			if(needToDestroy) {
				destroyAndRemoveFromActor();
			} else {
				sfxViewDynamic.refresh();
			}
		}
		
		static public function addToActor(actor:Actor):JukeboxDynamicMusicComponent {			
			var result:JukeboxDynamicMusicComponent = new JukeboxDynamicMusicComponent();
			
			actor.addComponent(result);
			return result;
		}
	}
}
