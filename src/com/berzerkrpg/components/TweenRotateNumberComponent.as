package com.berzerkrpg.components {
	import com.lachhh.lachhhengine.MyMath;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class TweenRotateNumberComponent extends ActorComponent {
		public var value:Number = 0;
		public var rotation:Number = 0;
		public var speed:Number = 1;
		public var distance:Number = 30;
		public var callbackOnRevoluton : Callback;

		public function TweenRotateNumberComponent() {
			super();
			value = 0;
		}

		override public function update() : void {
			super.update();
			
			rotation += speed;
			while(rotation >= 360) {
				rotation -= 360;
				if(callbackOnRevoluton) callbackOnRevoluton.call();
			}
			
			value = MyMath.mySin(rotation)*distance;
		}
		
		static public function addToActor(actor: Actor):TweenRotateNumberComponent {
			var result:TweenRotateNumberComponent = new TweenRotateNumberComponent();
			actor.addComponent(result);
			return result;
		}
	}
}
