package com.lachhh.lachhhengine {
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.utils.Utils;
	/**
	 * @author LachhhSSD
	 */
	public class ActorObjectManager {
		public var debugName:String="";
		public var actorList: Vector.<Actor> = new Vector.<Actor>();
		private var newActorList: Vector.<Actor> = new Vector.<Actor>();
		public var enabled:Boolean ;
		public var autoRefreshOnNewActor : Boolean = true;
		private var temp : Vector.<ActorComponent> = new Vector.<ActorComponent>();
		private var tempActor : Array = new Array();
		public function ActorObjectManager() {
			enabled = true;
		}
		
		public function add(actor:Actor):void {
			actorList.push(actor);
			newActorList.push(actor);
		}
		
		public function update():void {
			if(enabled) {
				updateChildren();
				removeDestroyedChildren();
			}
		}
		
		private function updateChildren():void {
			var actor:Actor;
			var i:int = 0;
			for (i = 0; i < actorList.length; i++) {
				actor = actorList[i];
				if(actor.destroyed) continue;
				if(!actor.started) actor.start();
				if(actor.enabled) actor.update();
				
			}
			
			startNewChildren();
		}
		
		public function startNewChildren():void {
			var actor:Actor;
			var i:int = 0;
			for (i = 0; i < newActorList.length; i++) {
				actor = newActorList[i];
				if(actor.destroyed) continue;
				if(!actor.started) {
					actor.start();
					if(autoRefreshOnNewActor) {
						actor.refresh();
					}
				}
			}
			
			while(newActorList.length > 0) newActorList.pop();
		}
		
		private function removeDestroyedChildren():void {
			var actor:Actor;
			var i:int = 0;
			for (i = 0; i < actorList.length; i++) {
				actor = actorList[i];
				if(actor.destroyed) {
					actorList.splice(i, 1);
					i--;
				}
			}
		}

		public function refresh():void {
			var actor:Actor;
			var i:int = 0;
			for (i = 0; i < actorList.length; i++) {
				actor = actorList[i];
				if(actor.destroyed) continue;
				actor.refresh();
			}
		}
		
		
		public function getNumActive():int {
		    return actorList.length;
		}
		
		public function getNumNotDestroyed():int {
			var actor:Actor;
			var i:int = 0;
			var cpt:int = 0;
			for (i = 0; i < actorList.length; i++) {
				actor = actorList[i];
				if(!actor.destroyed) cpt++;
			}
			return cpt;
		}
		
		public function destroy():void {
			var i:int = 0;
			var actor:Actor;
			for (i = 0; i < actorList.length; i++) {
				actor = actorList[i];
				if(!actor.destroyed) {
					actor.destroy();
				}
			}
			actorList = new Vector.<Actor>();
		}
		
		public function enableAll(b:Boolean):void {
			var i:int = 0 ;
			var actor:Actor; 
			for (i = 0; i < actorList.length; i++) {
				actor = actorList[i];
				actor.enabled = b;
			}
		}
		
		public function destroyAll(theClass:Class):void {
			var i:int = 0 ;
			var actor:Actor; 
			for (i = 0; i < actorList.length; i++) {
				actor = actorList[i];
				if(Utils.myIsInstanceOfClass(actor, theClass)) {
					actor.destroy();
				}
			}
		}
		
		public function appendAllInstanceOf(theClass:Class, outputArray:Array):Array {
			var i:int = 0 ;
			var actor:Actor; 
			for (i = 0; i < actorList.length; i++) {
				actor = actorList[i];
				
				if(!actor.destroyed && Utils.myIsInstanceOfClass(actor, theClass)) {
					outputArray.push(actor);
				}
			}
			return outputArray;
		}
		
		public function appendAllInstanceOfComponent(theClass:Class, outputArray:Vector.<ActorComponent>):Vector.<ActorComponent> {
			var i:int = 0 ;
			var actor:Actor; 
			for (i = 0; i < actorList.length; i++) {
				actor = actorList[i];
				if(!actor.destroyed) actor.getComponentList(theClass, outputArray);
			}
			return outputArray;
		}
		
		public function getFirst(theClass:Class):Actor{
			var i:int = 0 ;
			var actor:Actor; 
			for (i = 0; i < actorList.length; i++) {
				actor = actorList[i];
				if(actor.destroyed) continue;
				if(Utils.myIsInstanceOfClass(actor, theClass)) {
					return actor;
				}
			}
			return null;
		}
		
		public function hasInstanceOf(theClass:Class):Boolean {
			var i:int = 0 ;
			var actor:Actor; 
			for (i = 0; i < actorList.length; i++) {
				actor = actorList[i];
				if(Utils.myIsInstanceOfClass(actor, theClass)) {
					return true;
				}
			}
			return false;
		}
		
		public function findActorByName(name:String):Actor {
			var i:int = 0 ;
			var actor:Actor; 
			for (i = 0; i < actorList.length; i++) {
				actor = actorList[i];
				if(actor.name == name) return actor;
			}
			return null;
		}
		
		public function getNearest(x:int, y:int):Actor {
			var result:Actor ;
			var actor:Actor; 
			var minDistance:int = int.MAX_VALUE;
			var distSquared:Number;
			
			for (var i : int = 0; i < actorList.length; i++) {
				actor = actorList[i];	
				distSquared = Utils.getSquaredDistance(actor.px, actor.py, x, y);
				if(minDistance == int.MAX_VALUE || distSquared < minDistance) {
					minDistance = distSquared;
					result = actor;
				}
			}
			return result;
		}
		
		public function getLastCreated():Actor {
			for (var i : int = actorList.length-1; i >= 0; i--) {
				var actor:Actor = actorList[i];
				if(!actor.destroyed) return actor;
			}
			return null;
		}
		
		public function getRandom():Actor {
			if(actorList.length <= 0) return null;
			return actorList[Math.floor(Math.random()*actorList.length)];
		}
		
		public function refreshAllComponent(theClass:Class):void {
			var tempComponents:Vector.<ActorComponent> = new Vector.<ActorComponent>();
			tempComponents = appendAllInstanceOfComponent(theClass, tempComponents);
			for (var i : int = 0; i < tempComponents.length; i++) {
				var view:ActorComponent = tempComponents[i];
				view.refresh();
			}
		}
		
		public function destroyFirstXOfClass(limit:int, theClass:Class):Boolean {
			var destroyedSome:Boolean = false;
			var tempActor:Array = new Array();
			tempActor = appendAllInstanceOf(theClass, tempActor);
			for (var i : int = (tempActor.length-(limit+1)); i >= 0; i--) {
				var view:Actor = tempActor[i];
				view.destroy();
				destroyedSome = true;
			}
			return destroyedSome;
		}
		
		public function getFirstComponent(theClass:Class):ActorComponent {
			while(temp.length > 0) temp.pop();
			temp = appendAllInstanceOfComponent(theClass, temp);
			if(temp.length <= 0) return null;
			return temp[0];
		}
		
		public function refreshAll(theClass:Class):void {
			while(tempActor.length > 0) tempActor.pop();
			tempActor = appendAllInstanceOf(theClass, tempActor);
			for (var i : int = 0; i < tempActor.length; i++) {
				var v:Actor = tempActor[i];
				v.refresh();
			}
		}		
	}
}
