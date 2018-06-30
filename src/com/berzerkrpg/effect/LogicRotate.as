package com.berzerkrpg.effect {
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class LogicRotate extends ActorComponent {
		public var rotateSpeed:Number = 15;
		public function LogicRotate() {
			super();
		}
		
		
		override public function update() : void {
			super.update();
			actor.renderComponent.animView.anim.rotation += rotateSpeed*GameSpeed.getSpeed();
		}
		
		static public function addToActor(actor: Actor):LogicRotate {
			var result:LogicRotate = new LogicRotate();
			actor.addComponent(result);
			return result;
		}
	}
}
