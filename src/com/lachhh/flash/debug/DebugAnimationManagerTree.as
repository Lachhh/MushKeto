package com.lachhh.flash.debug {

	/**
	 * @author Lachhh
	 */
	public class DebugAnimationManagerTree extends DebugTree {
		private var _mgrChild:Array ; 
		public function DebugAnimationManagerTree() {
			super();	
			_mgrChild = new Array();
		
		}
		
		override public function update():void {
			super.update();
			
			var totActive:int = 0;
			var totInCache:int = 0;
			/*for (var i:int = 0 ; i < AnimationFactory.getNbClass(); i++) {
				var inCache:int = AnimationManager.factoryCache.GetNbInCacheById(i);
				var active:int = AnimationManager.GetNbActiveById(i);
				var child:DebugManagerTreeChild = _mgrChild[i];
				if((inCache + active) > 0) {
					AddChild(child);
					child.name = getQualifiedClassName(child.myClass).split("::")[1] + " (" + active + "/" + inCache + ")";
				} else {
					RemoveChild(child);
				}
				
				totActive += active;
				totInCache += inCache;
			}*/
			name = "Animation : " + " (" + totActive + "/" + totInCache + ")";
		}		
	}
}
