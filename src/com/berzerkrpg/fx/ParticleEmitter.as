package com.berzerkrpg.fx {
	import com.berzerkrpg.components.TweenNumberComponent;
	import com.berzerkrpg.effect.LogicDestroyOutsideOfBounds;
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.animation.LogicCallbackOnFrameEnd;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;
	import com.lachhh.lachhhengine.camera.CameraFlashContainers;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.lachhhengine.components.PhysicComponent;

	import flash.geom.Point;

	/**
	 * @author LachhhSSD
	 */
	public class ParticleEmitter extends ActorComponent {
		public var physicComponentToClone:PhysicComponent;
		public var offSetVRandom:Point = new Point(0,0);
		public var offSetPRandom:Point = new Point();
		public var offSet:Point = new Point();
		public var numParticleToEmit:int = 0;
		public var waitBetweenParticle:Number = 3;
		public var tweenWait:TweenNumberComponent ;
		public var parentVisual:DisplayObjectContainer = CameraFlashContainers.instance.foreFxVisual;
		public var modelAnims:Array = new Array();
		public var endCallback:Callback;
		public var onEmitCallback:Callback;
		public var particleAnimLooping:Boolean = false;
		public var destroyOutsideOfBounds:Boolean = true;
		public var lastEmitted:Actor = null;
		
		public function ParticleEmitter() {
			super();
			
		}

		override public function start() : void {
			super.start();
			tweenWait = TweenNumberComponent.addToActor(actor);
			tweenWait.gotoValue = waitBetweenParticle;
			tweenWait.value = 0;
			
		}
		
		
		override public function update() : void {
			super.update();
			tweenWait.gotoValue = waitBetweenParticle;
			if(tweenWait.hasReachedGoto()) {
				tweenWait.value = 0;
				emit();
				if(numParticleToEmit == -1) return ;
				numParticleToEmit--;
				if(numParticleToEmit <= 0) {
					if(endCallback) endCallback.call();
					destroyAndRemoveFromActor();	
				}
			}
		}
		
		public function emit():void {
			var x:int = actor.px+offSet.x+getRandomInRange(offSetPRandom.x);
			var y:int = actor.py+offSet.y+getRandomInRange(offSetPRandom.y);
			
			if(modelAnims.length > 0) {
				var fx:GameEffect = GameEffect.createFx(parentVisual, pickRandomAnim(), x, y) ;
				if(physicComponentToClone) {
					fx.physicComponent = PhysicComponent.addToActor(fx);
					fx.physicComponent.vx = physicComponentToClone.vx+(getRandomInRange(offSetVRandom.x));
					fx.physicComponent.vy = physicComponentToClone.vy+(getRandomInRange(offSetVRandom.y));
					fx.physicComponent.gravX = physicComponentToClone.gravX;
					fx.physicComponent.gravY = physicComponentToClone.gravY;
				}
				
				if(!particleAnimLooping) {
					LogicCallbackOnFrameEnd.addEndCallback(fx, new Callback(fx.destroy, fx, null), fx.renderComponent.animView.anim);
				}
				
				if(destroyOutsideOfBounds) LogicDestroyOutsideOfBounds.addToActor(fx);
				lastEmitted = fx;
			}
			if(onEmitCallback) onEmitCallback.call();
		}
		
		private function pickRandomAnim():ModelFlashAnimation {
			return modelAnims[Math.floor(Math.random()*modelAnims.length)] as ModelFlashAnimation;
		}
		
		private function getRandomInRange(n:Number):Number {
			return (Math.random()*n);
		}

		override public function destroy() : void {
			super.destroy();
			if(tweenWait) tweenWait.destroyAndRemoveFromActor();
		}
		
		static public function addToActor(actor: Actor): ParticleEmitter {
			var result: ParticleEmitter = new ParticleEmitter ();
			actor.addComponent(result);
			return result;
		}


	}
}
