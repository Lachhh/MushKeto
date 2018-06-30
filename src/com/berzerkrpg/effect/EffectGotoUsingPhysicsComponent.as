package com.berzerkrpg.effect {
	import com.lachhh.lachhhengine.components.PhysicComponent;
	import flash.geom.Point;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author Eel
	 */
	public class EffectGotoUsingPhysicsComponent extends ActorComponent {
		public var gotoPos:Point = new Point();
		public var ease : Number = 0.03;
		public var maxVelocity:Number = 1;
		private var physicsComponent:PhysicComponent;
		private var delta:Point = new Point();

		public function EffectGotoUsingPhysicsComponent() {
			super();
			maxVelocity = 100;
			ease = 0.03;
		}

		override public function start() : void {
			super.start();
			physicsComponent = actor.physicComponent;
		}

		override public function update() : void {
			super.update();
			//actor.px += (goto.x-actor.px)*ease.x;
			//actor.py += (goto.y-actor.py)*ease.y;
			//actor.physicComponent.vx = Math.max(maxVelocity.x, (goto.x-actor.px)*ease.x) * -1;
			//actor.physicComponent.vy = Math.max(maxVelocity.y, (goto.y-actor.py)*ease.y) * -1;
			delta.x = (gotoPos.x - actor.px) * ease;
			delta.y = (gotoPos.y - actor.py) * ease;
			if(delta.length > maxVelocity) {
				delta.normalize(maxVelocity);
				
			}
			physicsComponent.vx = delta.x;
			physicsComponent.vy = delta.y;
			
			//physicsComponent.vx *= 0.1;
			//physicsComponent.vy *= 0.1;
		}
		
		
		static public function addToActor(actor:Actor, x:Number, y:Number):EffectGotoUsingPhysicsComponent {
			var result:EffectGotoUsingPhysicsComponent = new EffectGotoUsingPhysicsComponent();
			result.gotoPos.x = x;
			result.gotoPos.y = y;
			actor.addComponent(result);
			return result;
		}
		
		static public function addToActorWithMaxVelocity(actor:Actor, x:Number, y:Number, maxVelocity:Number):EffectGotoUsingPhysicsComponent {
			var result:EffectGotoUsingPhysicsComponent = new EffectGotoUsingPhysicsComponent();
			result.gotoPos.x = x;
			result.gotoPos.y = y;
			result.maxVelocity = maxVelocity;
			actor.addComponent(result);
			return result;
		}
	}
}