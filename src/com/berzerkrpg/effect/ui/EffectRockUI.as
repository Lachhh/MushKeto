package com.berzerkrpg.effect.ui {
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.MyMath;
	import com.berzerkstudio.IDisplayProxy;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author Eel
	 */
	public class EffectRockUI extends ActorComponent {
		
		public var speed:Number = 1;
		public var maxAngle:Number = 45;
		
		private var angleWhenStarted:Number = 0;
		
		private var currentRotation:Number = 0;
		
		private var angleApplied:Number = 0;
		private var lastAngle:Number = 0;
		private var visual:IDisplayProxy = null;
		
		public function EffectRockUI() {
			super();
		}
		
		public override function start():void{
			super.start();
			angleWhenStarted = visual.rotation;
			lastAngle = visual.rotation;
			currentRotation = 90;
			applyChanges();
		}
		
		public override function update():void{
			super.update();
			cancelPreviousChanges();
			applyChanges();
			calculateNextChanges();	
		}
		
		private function calculateNextChanges():void {
			currentRotation += speed*GameSpeed.getSpeed();
			if(currentRotation > 360) currentRotation -= 360;
			if(currentRotation < 0) currentRotation += 360;
		}
		
		private function applyChanges():void {
			lastAngle = visual.rotation;
			angleApplied = MyMath.myCos(currentRotation)*maxAngle;
			visual.rotation += angleApplied;
		}
		
		private function cancelPreviousChanges():void {
			visual.rotation = lastAngle;
		}
		
		public override function destroy():void{
			super.destroy();
			cancelPreviousChanges();
		}
		
		public static function addToActor(actor:Actor, visual:IDisplayProxy, speed:Number, maxAngle:Number):EffectRockUI{
			var result:EffectRockUI = new EffectRockUI();
			result.visual = visual;
			result.speed = speed;
			result.maxAngle = maxAngle;
			actor.addComponent(result);
			return result;
		}
	}
}