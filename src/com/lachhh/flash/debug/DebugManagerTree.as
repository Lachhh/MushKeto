package com.lachhh.flash.debug {
	import com.lachhh.lachhhengine.ActorObjectManager;
	import com.lachhh.lachhhengine.actor.Actor;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author Lachhh
	 */
	public class DebugManagerTree extends DebugTree {
		private var _mgr:ActorObjectManager;
		private var _mgrChild:Array ; 
		
		public function DebugManagerTree(mgr:ActorObjectManager) {
			super();	
			_mgr = mgr;
			_mgrChild = new Array();
		}
		
		override public function update():void {
			super.update();
			
			var numComponent:int = 0;
			for (var i:int = 0 ; i < _mgr.actorList.length; i++) {
				var actor:Actor = _mgr.actorList[i];
				var child:DebugManagerActorTree = GetChildIfNotCreated(i);
				AddChild(child);
				child.setActor(actor);
				child.name = getQualifiedClassName(actor).split("::")[1] + " (" + Math.ceil(actor.px) + "," + Math.ceil(actor.py) + ")" + "~[" + actor.components.length + "]";
				numComponent += actor.components.length ;
			}
			
			for (i; i < numChild; i++) {
				RemoveChild(GetChildAt(i));
			}
			name = _mgr.debugName + " (" + numChild + ")~[" + numComponent + "]"  ;
		}
		
		private function GetChildIfNotCreated(i:int):DebugManagerActorTree {
			var result:DebugManagerActorTree ;
			if(i >= numChild) {
				result = new DebugManagerActorTree();
			} else {
				result = GetChildAt(i) as DebugManagerActorTree;
			}
			return result;
		}
	
	}
}
