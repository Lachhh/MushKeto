package com.berzerkrpg.effect {
	import com.berzerkrpg.components.TweenNumberComponent;
	import com.lachhh.io.CallbackGroup;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	import flash.geom.Point;

	/**
	 * @author LachhhSSD
	 */
	public class EffectGoto extends ActorComponent {
		public var goto:Point = new Point();
		public var ease:Point = new Point();
		public var tweenX:TweenNumberComponent;
		public var tweenY:TweenNumberComponent;
		public var callbackOnReach:CallbackGroup = new CallbackGroup();

		public function EffectGoto() {
			super();
		}
		
		
		override public function start() : void {
			super.start();
			tweenX = TweenNumberComponent.addToActor(actor);
			tweenY = TweenNumberComponent.addToActor(actor);
			tweenX.value = actor.px;
			tweenY.value = actor.py;
			tweenX.gotoValue = goto.x;
			tweenY.gotoValue = goto.y;
			tweenX.ease = ease.x;
			tweenY.ease = ease.y;
		}

		override public function update() : void {
			super.update();
			tweenX.gotoValue = goto.x;
			tweenY.gotoValue = goto.y;
			actor.px = tweenX.value;
			actor.py = tweenY.value;
		}
		
		
		override public function destroy() : void {
			super.destroy();
			tweenX.destroyAndRemoveFromActor();
			tweenY.destroyAndRemoveFromActor();
		}
		
		
		static public function addToActor(actor:Actor, x:Number, y:Number):EffectGoto {
			var result:EffectGoto = new EffectGoto();
			result.goto.x = x;
			result.goto.y = y;
			actor.addComponent(result);
			return result;
		}


	}
}
