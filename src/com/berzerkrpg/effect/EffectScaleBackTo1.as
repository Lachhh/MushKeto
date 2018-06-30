package com.berzerkrpg.effect {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class EffectScaleBackTo1 extends ActorComponent {
		
		public var scaleX:Number;
		public var scaleY:Number;
		public var ease:Number = 0.3;
		public var threshold:Number = 0.1;
		public var scaleGotoX:Number = 1;
		public var scaleGotoY : Number = 1;
		public var anim : DisplayObject;

		public function EffectScaleBackTo1() {
			
		}

		override public function start() : void {
			super.start();
			
			anim.scaleX = scaleX;
			anim.scaleY = scaleY;
		}
		
		override public function update() : void {
			super.update();
			anim.scaleX += (scaleGotoX-anim.scaleX)*ease;
			anim.scaleY += (scaleGotoY-anim.scaleY)*ease;
			
			if(Math.abs(anim.scaleX-scaleGotoX) <= 0.01 && Math.abs(anim.scaleY-scaleGotoY) <= threshold) {
				destroyAndRemoveFromActor();
			} 
		}
		
		override public function destroy() : void {
			super.destroy();
			anim.scaleX = scaleGotoX;
			anim.scaleY = scaleGotoY;
		}
		
		static public function addToActor(actor:Actor, scaleX:Number, scaleY:Number):EffectScaleBackTo1 {
			return addToActorWithSpecificMc(actor, actor.renderComponent.animView.anim, scaleX, scaleY);
		}
		
		static public function addToActorWithSpecificMc(actor:Actor, displayObject:DisplayObject, scaleX:Number, scaleY:Number):EffectScaleBackTo1 {
			var result:EffectScaleBackTo1 = new EffectScaleBackTo1();
			result.anim = displayObject;
			result.scaleX = scaleX;
			result.scaleY = scaleY;
			actor.addComponent(result);
			return result;
		}
		
		static public function addToActorWithSpecificMcUsingOriginalScale(actor:Actor, displayObject:DisplayObject, scaleX:Number, scaleY:Number):EffectScaleBackTo1 {
			var result:EffectScaleBackTo1 = new EffectScaleBackTo1();
			result.anim = displayObject;
			result.scaleX = scaleX;
			result.scaleY = scaleY;
			result.scaleGotoX = displayObject.scaleX;
			result.scaleGotoY = displayObject.scaleY;
			actor.addComponent(result);
			return result;
		}
	}
}
