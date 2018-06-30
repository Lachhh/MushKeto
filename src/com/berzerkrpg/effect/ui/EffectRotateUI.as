package com.berzerkrpg.effect.ui {
	import com.berzerkstudio.IDisplayProxy;
	import com.lachhh.lachhhengine.GameSpeed;
	import com.lachhh.lachhhengine.MyMath;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	import flash.geom.Point;

	/**
	 * @author LachhhSSD
	 */
	public class EffectRotateUI extends ActorComponent {
		public var rotX:Number = 0;
		public var rotY:Number = 0;
		public var speedRotX:Number = 1;
		public var speedRotY:Number = 1;
		public var xDistance:Number = 30;
		public var yDistance:Number = 15;
		private var vxApplied:Number = 0;
		private var vyApplied:Number = 0;
		private var visual:IDisplayProxy = null;
		public var posWhenStarted:Point = new Point();
		public var lastPos:Point = new Point();
		
		public function EffectRotateUI() {
			super();
		}

		override public function start() : void {
			super.start();
			posWhenStarted.x = visual.x;
			posWhenStarted.y = visual.y;
			lastPos.x = visual.x;
			lastPos.y = visual.y;
			rotX = 90;
			applyChanges();
		}
		
		override public function update() : void {
			super.update();
			
			cancelPreviousChanges();
			applyChanges();
			calculateNextChanges();	
		}
		
		private function calculateNextChanges():void {
			rotX += speedRotX*GameSpeed.getSpeed();
			rotY += speedRotY*GameSpeed.getSpeed();
			if(rotX > 360) rotX -= 360;
			if(rotY > 360) rotY -= 360;
			if(rotX < 0) rotX += 360;
			if(rotY < 0) rotY += 360;
		}
		
		private function applyChanges():void {
			lastPos.x = visual.x;
			lastPos.y = visual.y;
			vxApplied = MyMath.myCos(rotX)*xDistance;
			vyApplied = MyMath.mySin(rotY)*yDistance;
			visual.x += vxApplied;
			visual.y += vyApplied;
				
		}
		
		private function cancelPreviousChanges():void {
			visual.x = lastPos.x ;
			visual.y = lastPos.y ;
		}
		
		public function setBackToStartPos():void {
			visual.x = posWhenStarted.x;
			visual.y = posWhenStarted.y;
			vxApplied = 0;
			vyApplied = 0;
			lastPos.x = visual.x;
			lastPos.y = visual.y;
			rotX = 90;
			rotY = 0;
		}
		
		override public function destroy() : void {
			super.destroy();
			cancelPreviousChanges();	
		}
		
		static public function addToActor(actor:Actor, visual:IDisplayProxy):EffectRotateUI {
			var result:EffectRotateUI = new EffectRotateUI();
			result.visual = visual;
			actor.addComponent(result);
			return result;
		}
		
		static public function addToActorAdvanced(actor:Actor, visual:IDisplayProxy,  distX:Number, distY:Number, speedRotX:Number, speedRotY:Number):EffectRotateUI {
			var result:EffectRotateUI = new EffectRotateUI();
			result.visual = visual;
			result.xDistance = distX;
			result.yDistance = distY;
			result.speedRotX = speedRotX;
			result.speedRotY = speedRotY;
			actor.addComponent(result);
			return result;
		}
	}
}
