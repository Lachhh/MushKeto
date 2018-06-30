package com.lachhh.lachhhengine.actor {
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.lachhhengine.components.PhysicComponent;
	import com.lachhh.utils.Utils;
	import com.lachhhStarling.berzerk.RenderFlashOrDisplay;

	import flash.geom.Point;
	/**
	 * @author LachhhSSD
	 */
	public class Actor {
		public var components:Vector.<ActorComponent> = new Vector.<ActorComponent>();
		public var px:Number = 0;
		public var py:Number = 0;
		public var destroyed:Boolean = false;
		public var started:Boolean = false;
		public var enabled:Boolean = true;
		public var name:String = "";
		
		public var renderComponent:RenderFlashOrDisplay;
		//public var renderComponent2:RenderComponent;
		public var physicComponent:PhysicComponent;
		
		private var temp:Vector.<ActorComponent> = new Vector.<ActorComponent>();
		
		public function Actor() {
			started = false;
		}
		
		public function start():void {
			started = true;
			var iComponent:ActorComponent;
			for (var i : int = 0; i < components.length; i++) {
				iComponent = components[i];
				iComponent.start();
			}
		}
		
		public function update():void {
			var iComponent:ActorComponent;
			for (var i : int = 0; i < components.length; i++) {
				iComponent = components[i];
				if(enabled && iComponent.enabled) iComponent.update();
			}
		}
				
		public function refresh():void {
			var iComponent:ActorComponent;
			for (var i : int = 0; i < components.length; i++) {
				iComponent = components[i];
				iComponent.refresh();
			}
		}
		
		public function destroy():void {
			var iComponent:ActorComponent;
			for (var i : int = 0; i < components.length; i++) {
				iComponent = components[i];
				iComponent.destroy();
			}
			destroyed = true;
			//started = false;
			components = new Vector.<ActorComponent>();
		}
		
		public function addComponent(component:ActorComponent):ActorComponent {
			components.push(component);
			component.actor = this;
			return component;
		}
		
		public function getComponent(componentClass:Class):ActorComponent {
			var component:ActorComponent;
			
			for (var i : int = 0; i < components.length; i++) {
				component = components[i];
				if(Utils.myIsInstanceOfClass(component, componentClass)) {
					return component; 
				}
			}
			return null;
		}
		
		public function getComponentList(componentClass:Class, outputList:Vector.<ActorComponent>):Vector.<ActorComponent> {
			var component:ActorComponent;
			
			for (var i : int = 0; i < components.length; i++) {
				component = components[i];
				if(Utils.myIsInstanceOfClass(component, componentClass)) {
					outputList.push(component); 
				}
			}
			return outputList;
		}
		
		public function enableAll(componentClass:Class, b:Boolean):void {
			while(temp.length > 0) temp.pop();
			getComponentList(componentClass, temp);
			for (var i : int = 0; i < temp.length; i++) {
				var c:ActorComponent = temp[i];
				c.enabled = b;
			}
		}
		
		public function removeComponent(component:ActorComponent):void {
			if(component == null) return ;
			var iComponent:ActorComponent;
			
			for (var i : int = 0; i < components.length; i++) {
				iComponent = components[i];
				if(iComponent == component) {
					components.splice(i, 1);
					iComponent.destroy();
					return; 
				}
			}
		}
		
		public function setPos(x:int, y:int):void {
			px = x;
			py = y;
		}
		
		public function setPosWithPoint(p:Point):void {
			px = p.x;
			py = p.y;
		}

	}
}
