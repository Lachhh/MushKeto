package com.lachhh.lachhhengine.animation {
	import com.lachhh.flash.FlashAnimation;

	import flash.display.MovieClip;
	/**
	 * @author Lachhh
	 */
	public class AnimationManager {
		
		static private var _factoryCache:FlashAnimationCache = new FlashAnimationCache();
		static private var _activeFactoryObjects:Vector.<MovieClip> = new Vector.<MovieClip>();
		static private var _activeById:Array = new Array();
		
		static public function createAnimation(idAnim:int):MovieClip {
			AddNumberAtId(idAnim, 1);			
			var factoryObject:MovieClip = _factoryCache.GetFactoryObject(idAnim);
			
			_activeFactoryObjects.push(factoryObject);
			return factoryObject;
		}
		
		static public function destroy(animation:MovieClip):void {
			AddNumberAtId(animation.idInCache, -1);
			_factoryCache.AddToCache(animation);
			for (var i : int = 0; i < _activeFactoryObjects.length; i++) {
				if(_activeFactoryObjects[i] == animation) {
					_activeFactoryObjects.splice(i, 1);
					break;
				}
			}			

		}
		
		static private function AddNumberAtId(id:int, mod:int):void {
			if(_activeById[id] == null) {
				_activeById[id] = 0;
			}
			var nb:int = _activeById[id];
			nb += mod; 
			_activeById[id] = nb;
		}
		
		static public function GetNbActiveById(id:int):int {
			return _activeById[id] ;
		}
		
		static public function get activeFactoryObjects():Vector.<MovieClip> {
			return _activeFactoryObjects;
		}
		
		static public function get factoryCache():FlashAnimationCache {
			return _factoryCache;
		}
	}
}
