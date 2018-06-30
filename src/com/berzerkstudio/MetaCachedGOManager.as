package com.berzerkstudio {
	import com.berzerkstudio.flash.display.ShapeObject;
	import com.berzerkstudio.flash.display.DisplayObject;
	/**
	 * @author LachhhSSD
	 */
	public class MetaCachedGOManager {
		static public var cacheGOs:Vector.<MetaCachedGO> = new Vector.<MetaCachedGO>();
		static public var activeGOs:Vector.<MetaCachedGO> = new Vector.<MetaCachedGO>();
		static public function getMetaCachedGO(d:ShapeObject):MetaCachedGO {
			if(d.metaGo != null) return d.metaGo; 
			if(cacheGOs.length <= 0) return createMetaCachedGo(d);
			var result:MetaCachedGO = cacheGOs.pop();
			result.init(d);
			
			return result;
		}
		
		static public function createMetaCachedGo(d:ShapeObject):MetaCachedGO {
			var result:MetaCachedGO = new MetaCachedGO();
			result.init(d);
			activeGOs.push(result);
			return result;
		}
		
		static public function cache(m:MetaCachedGO):void {
			if(m == null) return ;
			m.onCache();
			cacheGOs.push(m);
			var i:int = activeGOs.indexOf(m); 
			if(i != -1) activeGOs.splice(i, 1);
		}
		
		static public function update():void {
			
			for (var i : int = 0; i < activeGOs.length; i++) {
				if(activeGOs[i].isCached) continue;
				activeGOs[i].lifeCached--;
				if(activeGOs[i].lifeCached <= 0) {
					cache(activeGOs[i]);
					i--;
				}
			}
		}
	}
}
