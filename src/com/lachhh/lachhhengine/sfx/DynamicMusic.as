package com.lachhh.lachhhengine.sfx {
	import com.lachhh.lachhhengine.VersionInfo;

	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.ByteArray;

	/**
	 * @author Lachhh
	 */
	public class DynamicMusic {
		public var isPlaying:Boolean = false;
		public var startTime:Number = 0;
		public var soundTransform:SoundTransform ;
		public var volume:Number = 1;
		public var debugSoundName : String;
		
		private var _playbackSpeed:Number = 1; 

		private var _loadedMP3Samples:ByteArray;
		private var _dynamicSound:Sound;

		private var _phase:Number;
		private var _numSamples:int;
		
		public var soundByteArray:ByteArray = null;
		public var bruteSound:Sound ;
		
		private var _dynamicSndChannel:SoundChannel ;
		private var _isDestroyed:Boolean ;
		private var _loops : int ;
		private var _oldVolume : Number = 0;
		

		public function DynamicMusic() {
			_isDestroyed = false;
			soundTransform = new SoundTransform(getTotalVolume());
			
			if(VersionInfo.isDebug) {
				debugSoundName = "DynamicSound"; 
			}
		}  

		public function destroy():void {
			_isDestroyed = true;
			stop();
			stopListener();
			soundByteArray.clear();
			soundByteArray = null;
		}
		 
		public function stop():void {
			if(!isPlaying) return ;
			if(_dynamicSndChannel) {
				_dynamicSndChannel.stop();
			}
			
			isPlaying = false;
			
			
		}
		
		private function stopListener():void {
			if (_dynamicSound) {
				
				_dynamicSound.removeEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
				
				//_dynamicSound.close();
				_dynamicSound = null;
			}
			
			_dynamicSndChannel = null;	
		}

		
		public function play():void {
			if(isPlaying) {
				_phase = startTime*44.1;
				return ;
			}
			
			isPlaying = true;
		
			_dynamicSndChannel = _dynamicSound.play(startTime, int.MAX_VALUE, soundTransform);
	
		}
		
		public function loadSong(sound:Sound):void {
			if(soundByteArray == null) {
				stopListener();
				
				_dynamicSound = new Sound();
				_dynamicSound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			
				soundByteArray = new ByteArray();
				bruteSound = sound; 
				sound.extract(soundByteArray, int(sound.length * 44.1));
				
				_loadedMP3Samples = soundByteArray;
				_numSamples = soundByteArray.length / 8;
		         
				_phase = startTime*44.1;
			}
		}
		
		public function loadSongByByteArray(ba:ByteArray):void {
			if(soundByteArray == null) {
				stopListener();
				
				_dynamicSound = new Sound();
				_dynamicSound.addEventListener(SampleDataEvent.SAMPLE_DATA, onSampleData);
			
				soundByteArray = ba;
				//var bruteSound:Sound = bruteSound; 
				//bruteSound.extract(soundByteArray, int(bruteSound.length * 44.1));
				
				_loadedMP3Samples = soundByteArray;
				_numSamples = soundByteArray.length / 8;
		         
				_phase = startTime*44.1;
			}
		}
		
		private function onSampleData( event:SampleDataEvent ):void {
			var l:Number;
			var r:Number;
	        
			var outputLength:int = 0;
			//trace("PLAY4");
			while (outputLength < 2048) { 
				// until we have filled up enough output buffer
	            
				// move to the correct location in our loaded samples ByteArray
				_loadedMP3Samples.position = int(_phase) * 8; // 4 bytes per float and two channels so the actual position in the ByteArray is a factor of 8 bigger than the phase
	            
	            // read out the left and right channels at this position
				l = _loadedMP3Samples.readFloat();
	            r = _loadedMP3Samples.readFloat();
	            
	            // write the samples to our output buffer
	            event.data.writeFloat(l);
	            event.data.writeFloat(r);
	            
	            outputLength++;
	            
	            // advance the phase by the speed...
	            _phase += _playbackSpeed;
	            
	            // and deal with looping (including looping back past the beginning when playing in reverse)
	            if (_phase < 0) {
					_phase = 0;
	               //_phase += _numSamples;
	            } else if (_phase >= _numSamples) {
	               _phase -= _numSamples;
	               _loops--;	               
	            }
			}
		}
		
		public function getTotalVolume():Number {
			return (Jukebox.MUSIC_MUTED ? 0 : volume*Jukebox.MUSIC_VOLUME);
		}
		

		public function refresh():void {
			if(volume > 1) volume = 1;
			if(volume < 0) volume = 0;
			var totalVolume:Number = volume*getTotalVolume();
			if(_oldVolume != totalVolume) {
				_oldVolume = totalVolume;
				soundTransform.volume = totalVolume;
				if(_dynamicSndChannel) _dynamicSndChannel.soundTransform = soundTransform; 
			}
		}
		
		public function refreshVolume():void {
			if(volume > 1) volume = 1;
			if(volume < 0) volume = 0;
			var totalVolume:Number = volume*getTotalVolume();
			if(_oldVolume != totalVolume) {
				_oldVolume = totalVolume;
				soundTransform.volume = totalVolume;
				if(_dynamicSndChannel) _dynamicSndChannel.soundTransform = soundTransform; 
			}
		}
		
	    public function set playbackSpeed(value:Number):void {
	         _playbackSpeed = value;
		}
		
		public function get playbackSpeed():Number {
			return _playbackSpeed;
		}
		
		public function get position():Number {
			return Math.floor(_phase)/44.1;	
		}
		
		public function set position(value:Number):void {
			startTime = Math.min(length-44.1, Math.max(value, 0));
			_phase = startTime*44.1;
		}
		
		public function get dynamicSound():Sound {
			return _dynamicSound;
		}
		
		public function get dynamicSndChannel():SoundChannel {
			return _dynamicSndChannel;
		}
		
		public function get length():int {
			return bruteSound.length;
		}
	}
}
