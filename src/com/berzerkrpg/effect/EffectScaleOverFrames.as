package com.berzerkrpg.effect {
	import com.berzerkrpg.components.TweenNumberComponent;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.utils.Utils;

	/**
	 * @author Eel
	 */
	public class EffectScaleOverFrames extends ActorComponent {
		
		public var overFrames:Number = 60;
		public var elapsedFrames:Number = 0;
		
		public var scaleXMod:Number = 0.1;
		public var scaleYMod:Number = 0.1;
		
		public var scaleXStart:Number = 1;
		public var scaleYStart:Number = 1;
		
		public function EffectScaleOverFrames() {
			super();
		}
		
		public override function start():void{
			super.start();
			elapsedFrames = 0;
			scaleXStart = actor.renderComponent.animView.anim.scaleX;
			scaleYStart = actor.renderComponent.animView.anim.scaleY;
		}
		
		public override function update():void{
			super.update();
			elapsedFrames++;
			if(elapsedFrames > overFrames) return;
			actor.renderComponent.animView.anim.scaleX *= scaleXMod;
			actor.renderComponent.animView.anim.scaleY *= scaleYMod;
		}
		
		public override function destroy():void{
			super.destroy();
			actor.renderComponent.animView.anim.scaleX = scaleXStart;
			actor.renderComponent.animView.anim.scaleY = scaleYStart;
		}
		
		public static function addToActor(actor:Actor, overFrames:Number, scaleXMod:Number, scaleYMod:Number):EffectScaleOverFrames{
			var result:EffectScaleOverFrames = new EffectScaleOverFrames();
			result.overFrames = overFrames;
			result.scaleXMod = scaleXMod;
			result.scaleYMod = scaleYMod;
			actor.addComponent(result);
			return result;
		}
	}
}