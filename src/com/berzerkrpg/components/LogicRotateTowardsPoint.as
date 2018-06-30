package com.berzerkrpg.components {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.lachhh.io.Callback;
	import com.lachhh.io.CallbackGroup;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	import flash.geom.Point;

	/**
	 * @author Eel
	 */
	public class LogicRotateTowardsPoint extends ActorComponent {
		
		public var onReachedRotation:CallbackGroup = new CallbackGroup();
		
		public var destPoint:Point = new Point();
		
		public var rotationSpeed:Number = 1;
		
		private var targetRotationVec:Point = new Point();
		private var rotationDirection:int = 1;
		private var targetAngle:Number = 0;
		
		public function LogicRotateTowardsPoint() {
			super();
		}
		
		public override function start():void{
			super.start();
			
			rotationDirection = (actor.px > destPoint.x) ? -1 : 1;
			
			targetRotationVec.x = destPoint.x - actor.px;
			targetRotationVec.y = destPoint.y - actor.py;
			
			targetAngle = Math.atan2(targetRotationVec.y, targetRotationVec.x) * (180 / Math.PI);
			
			targetAngle += 90;
			
			if(targetAngle < 0){
				targetAngle = 360 + targetAngle;
			}
			if(targetAngle > 360){
				targetAngle = 360 - targetAngle;
			}
		}
		
		public override function update():void{
			super.update();
			
			var anim:DisplayObject = actor.renderComponent.animView.anim;
			
			anim.rotation += rotationSpeed * rotationDirection;
			
			if(anim.rotation > 360){
				anim.rotation = 0;
			}
			if(anim.rotation < 0){
				anim.rotation = 360;
			}
			
			if(Math.abs(targetAngle - anim.rotation) < rotationSpeed * 2){
				anim.rotation = targetAngle;
				onReachedRotation.call();
				destroyAndRemoveFromActor();
				return;
			}
		}
		
		public override function destroy():void{
			super.destroy();
		}
		
		public static function addToActor(actor:Actor, point:Point, onFinished:Callback):LogicRotateTowardsPoint{
			var result:LogicRotateTowardsPoint = new LogicRotateTowardsPoint();
		
			actor.addComponent(result);
			result.destPoint.copyFrom(point);
			result.onReachedRotation.addCallback(onFinished);
		
			return result;
		}
	}
}