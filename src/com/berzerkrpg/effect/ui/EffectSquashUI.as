package com.berzerkrpg.effect.ui {
	import com.berzerkstudio.IAnimationProxy;
	import flash.display.DisplayObject;
	import com.lachhh.lachhhengine.MyMath;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class EffectSquashUI extends ActorComponent {
		public var rot:Number = 0;
		public var speedRot:Number = 30;

		public var xScaleMax:Number = 0.2;
		public var yScaleMax:Number = -0.2;
		public var numRevolution:int = -1;
		public var animView:IAnimationProxy ;
		private var scaleXApplied : Number = 0;
		private var scaleYApplied : Number = 0;

		public function EffectSquashUI() {
			
		}

		override public function start() : void {
			super.start();
			applyChanges();
		}
		
		override public function update() : void {
			super.update();
			
			cancelPreviousChanges();
			applyChanges();
			calculateNextChanges();
		}
		
		private function calculateNextChanges():void {
			rot += speedRot;
			if(rot > 360) {
				rot -= 360;
				checkToDestroyAfterRevolution();
			}
			if(rot < 0) rot += 360;
		}
		
		private function checkToDestroyAfterRevolution():void {
			if(numRevolution == -1) return ;
			numRevolution--;
			if(numRevolution <= 0) {
				destroyAndRemoveFromActor();
			}
		}
		
		private function applyChanges():void {
			scaleXApplied = MyMath.mySin(rot)*xScaleMax;
			scaleYApplied = MyMath.mySin(rot)*yScaleMax;
			
			animView.scaleX += scaleXApplied;
			animView.scaleY += scaleYApplied;
		}
		
		private function cancelPreviousChanges():void {
			animView.scaleX -= scaleXApplied;
			animView.scaleY -= scaleYApplied;
		}
		
		override public function destroy() : void {
			super.destroy();
			cancelPreviousChanges();	
		}
		
		static public function addToActor(actor:Actor):EffectSquashUI {
			return addToActorWithSpecificDisplayObj(actor, actor.renderComponent.animView.anim);
		}
		
		static public function addToActorWithSpecificDisplayObj(actor:Actor, d:IAnimationProxy):EffectSquashUI {
			return addToActorWithSpecificDisplayObjAndRevolution(actor, d, -1);
		}
		
		static public function addToActorWithSpecificDisplayObjAndRevolution(actor:Actor, d:IAnimationProxy, numRevolution:int):EffectSquashUI {
			var result:EffectSquashUI = new EffectSquashUI();
			actor.addComponent(result);
			result.animView = d;
			result.numRevolution = numRevolution;
			return result;
		}
	}
}
