package com.lachhh.lachhhengine.sfx {
	import flash.media.Sound;
	

	/**
	 * @author LachhhSSD
	 */
	public class SfxFactory {
		static public var allSoundClass:Vector.<Class> = new Vector.<Class>();
		static public var allSounds:Vector.<Sound> = new Vector.<Sound>();
		
		
		//static public var ID_SFX_GEEK_HIT_GROUND_02:int = pushClassLink(SFX_GEEK_HIT_GROUND_02);
		
		
		
		static public function pushClassLink(pClass:Class):int {
			allSoundClass.push(pClass);
			return (allSoundClass.length-1);
		}
		
		static public function getNum():int {
			return allSoundClass.length;
		}
		
		
		
		static public function createSound(iSfx:int):Sound {
			while(iSfx >= allSounds.length) allSounds.push(null);
			if(allSounds[iSfx] == null) {
				var theClass:Class = allSoundClass[iSfx];
				allSounds[iSfx] = (new theClass()) as Sound;
			}
			
			
			return allSounds[iSfx]; 
		}
	}
}
