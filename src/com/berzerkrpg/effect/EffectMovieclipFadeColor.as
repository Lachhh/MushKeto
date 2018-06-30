package com.berzerkrpg.effect {
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.geom.Color;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.utils.Utils;

	/**
	 * @author Eel
	 */
	public class EffectMovieclipFadeColor extends ActorComponent {
		
		public var anim:DisplayObject;
		
		public var red:Number = 1;
		public var green:Number = 1;
		public var blue:Number = 1;
		
		public var fadingIn:Boolean = false;
		public var ease:Number = 0.3;
		public var threshold:Number = 0.1;
		public var prct:Number = 0;

		public function EffectMovieclipFadeColor() {
			super();
		}
		
		public override function destroy():void{
			super.destroy();
			if(fadingIn){
				Utils.SetColorAnimViewPrct(anim, red, green, blue, 1);
			} else {
				Utils.SetColorAnimViewPrct(anim, red, green, blue, 0);
			}
		}
		
		public override function refresh():void{
			super.refresh();
		}
		
		public override function update():void{
			super.update();
			
			prct += (1 - prct)*ease;
			
			if(fadingIn){
				Utils.SetColorAnimViewPrct(anim, red, green, blue, prct);
			} else {
				Utils.SetColorAnimViewPrct(anim, red, green, blue, 1-prct);
			}
			
			if(Math.abs(1-prct) <= 0.01 && Math.abs(1-prct) <= threshold) {
				destroyAndRemoveFromActor();
			} 
		}
		
		public static function addToActor(actor:Actor, anim:DisplayObject, color:uint, fadeIn:Boolean):EffectMovieclipFadeColor{
			var result:EffectMovieclipFadeColor = new EffectMovieclipFadeColor();
		
			result.anim = anim;
			result.fadingIn = fadeIn;
			
			result.red = Color.extractRed(color);
			result.green = Color.extractGreen(color);
			result.blue = Color.extractBlue(color);
		
			actor.addComponent(result);
		
			return result;
		}
	}
}