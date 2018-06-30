package com.lachhh.lachhhengine.sfx {
	import avmplus.getQualifiedClassName;

	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.effect.CallbackTimerEffect;
	import com.lachhh.flash.FlashUtils;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.utils.Utils;

	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	/**
	 * @author Lachhh
	 */
	public class FlashSfx {		 
		public var sound:Sound ;
		public var looping:Boolean = false;
		public var volume:Number = 1;
		public var startTime:Number = 0;
		public var debugSoundName:String = "";
		public var idSfx:int = -1;
		public var soundTransform:SoundTransform ;
		private var _oldVolume:Number = 1;
		public var isPlaying:Boolean = false;
		public var isMusic:Boolean = false;
		private var _hasFinishedPlaying:Boolean = false;
		private var _soundChannel:SoundChannel = null;
		
		
		public function FlashSfx(s:Sound){
			sound = s;
			soundTransform = new SoundTransform(getTotalVolume());
			_oldVolume = soundTransform.volume;
			
			if(VersionInfo.isDebug) {
				debugSoundName = FlashUtils.mySplit(FlashUtils.myGetQualifiedClassName(sound), "::")[1]; 
			}
		}
		
		public function destroy():void {
			 stop();
			 _soundChannel = null;
			 sound = null;
		}
		
		public function play():void {
			if(isPlaying) return ;
			_soundChannel = sound.play(startTime, (looping ? int.MAX_VALUE : 1), soundTransform);
			
			_hasFinishedPlaying = false;
			if(_soundChannel) {
				isPlaying = true;
				if(!looping) {
					_soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
				}
			} else {
				if(!looping) {
					_hasFinishedPlaying = true;
				}
			}
		}
		
		public function onSoundComplete(e:Event):void {
			if(!looping) {
				_hasFinishedPlaying = true;
			}
		}
		
		public function refresh():void {
			if(volume > 1) volume = 1;
			if(volume < 0) volume = 0;
			var totalVolume:Number = volume*getTotalVolume();
			if(_oldVolume != totalVolume) {
				_oldVolume = totalVolume;
				soundTransform.volume = totalVolume;
				if(_soundChannel) _soundChannel.soundTransform = soundTransform; 
			}
		}
		
		public function stop():void {
			if(!isPlaying) return ;
			if(_soundChannel) {
				_soundChannel.stop();
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			}
			
			isPlaying = false;
		}
		
		public function getTotalVolume():Number {
			if(isMusic) return (Jukebox.MUSIC_MUTED ? 0 : volume*Jukebox.MUSIC_VOLUME);
			return (Jukebox.SFX_MUTED ? 0 : volume*Jukebox.SFX_VOLUME); 
		}
		
		public function get hasFinishedPlaying() : Boolean {
			return _hasFinishedPlaying;
		}
		
		public function get position() : Number {
			if(_soundChannel == null) return -1;
			return _soundChannel.position;
		}
						
	}
}


