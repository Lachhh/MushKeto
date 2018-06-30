package com.lachhh.lachhhengine.animation {
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.io.Callback;
	import com.lachhh.io.CallbackGroup;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.lachhhengine.sfx.Jukebox;
	/**
	 * @author LachhhSSD
	 */
	public class LogicCallbackOnFrameEnd extends ActorComponent {
		
		public var callback:CallbackGroup = new CallbackGroup();
		public var anim:MovieClip;		
		
		public function LogicCallbackOnFrameEnd(pCallback : Callback, pAnim : MovieClip) {
			callback.addCallback(pCallback);
			
			anim = pAnim;
		}

		override public function update() : void {
			super.update();
			if(hasArrivedOnFrame()) {
				callback.call();
				destroyAndRemoveFromActor();
			}
		}

		override public function destroy() : void {
			super.destroy();
			/*if(triggerIfDestroy) {
				triggerIfDestroy = false;
				callback.call();
			}*/
		}

		private function hasArrivedOnFrame() : Boolean {			
			if(anim.currentFrame >= anim.totalFrames) return true;
						
			return false;
		}
		
		static public function addEndCallback(actor:Actor, callback : Callback, anim:MovieClip) : LogicCallbackOnFrameEnd {
			var result:LogicCallbackOnFrameEnd = actor.getComponent(LogicCallbackOnFrameEnd) as LogicCallbackOnFrameEnd;
			if(result == null) {
				result = actor.addComponent(new LogicCallbackOnFrameEnd(callback, anim)) as LogicCallbackOnFrameEnd;
			} else {
				result.callback.addCallback(callback);
			}
			
			return result; 
		}
		
		/*static public function addStopAtEnd(actor:Actor, anim:IAnimationView) : LogicCallbackOnFrame {
			return addEndCallback(actor, new Callback(anim.gotoAndStop, anim, [anim.getTotalFrames()]), anim); 
		}*/

		static public function addCallbackOnFrameRepeat(actor:Actor, callback : Callback, frame : int, repeat : Boolean, anim:MovieClip) : LogicCallbackOnFrame {
			var result:LogicCallbackOnFrame = new LogicCallbackOnFrame(callback, frame, repeat, anim);
			actor.addComponent(result);
			return result;
		}
		
		static public function addCallbackOnFrame(actor : Actor, callback : Callback, frame : int, anim:MovieClip) : LogicCallbackOnFrame {
			return addCallbackOnFrameRepeat(actor, callback, frame, false, anim);
		}
		
		static public function registerSound(actor : Actor, sfxId: int, frame:int, repeat : Boolean, anim:MovieClip) : LogicCallbackOnFrame {
			var callback:Callback = new Callback(Jukebox.playSound, Jukebox, [sfxId]);
			return addCallbackOnFrameRepeat(actor, callback, frame, repeat, anim);
		}
	}
}
