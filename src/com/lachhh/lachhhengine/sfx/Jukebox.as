package com.lachhh.lachhhengine.sfx {
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.lachhhengine.components.JukeboxSfxComponent;

	import flash.media.Sound;
	import flash.utils.Dictionary;
	/**
	 * @author LachhhSSD
	 */
	public class Jukebox extends Actor {
		static public var SFX_VOLUME:Number = 1;
		static public var MUSIC_VOLUME:Number = 1;
		static public var SFX_MUTED:Boolean = false;
		static public var MUSIC_MUTED:Boolean = false;
		
		static private var instance:Jukebox;
		static public var currentMusicComponent:JukeboxSfxComponent;
		
		static public var allMusics:Vector.<JukeboxSfxComponent> = new Vector.<JukeboxSfxComponent>();
		static public var allSounds:Vector.<JukeboxSfxComponent> = new Vector.<JukeboxSfxComponent>();
		
		public function Jukebox() {
			instance = this;
			
		}

		override public function removeComponent(component : ActorComponent) : void {
			super.removeComponent(component);
			var i : int = 0;
			var sfxComp:JukeboxSfxComponent = component as JukeboxSfxComponent;
			if(sfxComp) {
				var index:int = allMusics.indexOf(sfxComp);
				if(index != -1) allMusics.splice(i, 1);
				
				index = allSounds.indexOf(sfxComp);
				if(index != -1) allSounds.splice(i, 1);
			}
		}
		
		
		static public function fadeToMusic(iSfx:int, numFrame:int):JukeboxSfxComponent {
			if(currentMusicComponent && currentMusicComponent.sfxView.idSfx == iSfx) return currentMusicComponent;
			
			fadeAllMusicToDestroy(numFrame);
			
			var result:JukeboxSfxComponent = JukeboxSfxComponent.addToActor(instance, iSfx, true);
			result.gotoVolume = 1;
			result.gotoVolumeMod = (numFrame <= 0 ? 1 : (1/(numFrame+0.0)));
			result.sfxView.volume = 0;
			result.sfxView.isMusic = true;
			result.sfxView.refresh();
			allMusics.push(result);
			currentMusicComponent = result;
			
			return result;
		}
		
		static private function isNoSound():Boolean {
			if(SFX_MUTED) return true;
			if(SFX_VOLUME <= 0) return true;
			return false;
		}
		
		static public function playSound(iSfx:int):void {
			if(isNoSound()) return;
			playSoundLoop(iSfx, instance, false);
		}
		
		static public function playSoundWithVolume(iSfx:int, volume:Number):void {
			var result:JukeboxSfxComponent = playSoundLoop(iSfx, instance, false);
			result.sfxView.volume = volume;
			
		}
		
		static public function playSound2(sfx:Sound):JukeboxSfxComponent {
			var result:JukeboxSfxComponent = JukeboxSfxComponent.addToActorSound(instance, sfx, false);
			allSounds.push(result);
			return result;
		}
		
		static public function playSoundLoop(iSfx:int, actor:Actor, isLooping:Boolean):JukeboxSfxComponent {
			var result:JukeboxSfxComponent = JukeboxSfxComponent.addToActor(actor, iSfx, isLooping);
			allSounds.push(result);
			return result;
		}
		
		public function encode():Dictionary {
			var o:Dictionary = new Dictionary();
			o["SFX_VOLUME"] = SFX_VOLUME;
			o["MUSIC_VOLUME"] = MUSIC_VOLUME;
			///o["SFX_MUTED"] = SFX_MUTED;
			//o["MUSIC_MUTED"] = MUSIC_MUTED;
			
			return o; 
		}
		
		public function decode(obj:Dictionary):void {
			if(obj == null) return ;
			SFX_VOLUME = obj["SFX_VOLUME"];
			MUSIC_VOLUME = obj["MUSIC_VOLUME"];
			//SFX_MUTED = obj["SFX_MUTED"];
			//MUSIC_MUTED = obj["MUSIC_MUTED"];
		}
				
		
		static public function fadeAllMusicToDestroy(numFrame:int):void {
			for (var i : int = 0; i < allMusics.length; i++) {
				var music:JukeboxSfxComponent = allMusics[i];
				music.fadeToDestroy(numFrame);
			}
			currentMusicComponent = null;
		}
		
		static public function fadeAllSoundToDestroy(numFrame:int):void {
			for (var i : int = 0; i < allMusics.length; i++) {
				var music:JukeboxSfxComponent = allMusics[i];
				music.fadeToDestroy(numFrame);
			}
			currentMusicComponent = null;
		}
		
		static public function getInstance():Jukebox {
			return instance;
		}
	
	}
}
