package com.lachhh.lachhhengine.animation {
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;
	import com.lachhh.lachhhengine.sfx.Jukebox;
	import com.lachhh.utils.Utils;
	/**
	 * @author LachhhSSD
	 */
	public class LogicCallbackOnFrame extends ActorComponent{
		public var frame:int ;
		public var callback:Callback ;
		public var repeat:Boolean;
		public var hasToTriggerWhenEqual:Boolean = true;
		public var hasToTriggerWhenGreater:Boolean = false;
		public var anim:MovieClip;
		public var destroyIfNotOnStageAnymore:Boolean = false;		
		
		public function LogicCallbackOnFrame(pCallback:Callback, pFrame:int, pRepeat:Boolean, pAnim:MovieClip) {
			callback = pCallback;
			frame = pFrame;
			repeat = pRepeat;
			anim = pAnim;
			if(callback == null) {
				callback = pCallback;
			}
		}

		override public function update() : void {
			super.update();
			
			if(destroyIfNotOnStageAnymore) {
				if(anim.parent == null) {
					destroyAndRemoveFromActor();
				}
				return ;	
			}
			if(hasArrivedOnFrame()) {
				if(callback) callback.call();
				
				if(!repeat) {
					destroyAndRemoveFromActor();
				}
			}
		}

		private function hasArrivedOnFrame() : Boolean {
			if(hasToTriggerWhenEqual) {
				if(anim.currentFrame == frame) return true;  
			}
			
			if(hasToTriggerWhenGreater) {
				if(anim.currentFrame >= frame) {
					 return true;
				}
			}
			return false;
		}
		
		/*static public function addEndCallback(actor:Actor, callback : Callback, anim:IAnimationView) : LogicCallbackOnFrame {
			var result:LogicCallbackOnFrame = addCallbackOnFrameRepeat(actor, callback, anim.getTotalFrames(), false, anim);
			result.hasToTriggerWhenGreater = true;
			return result; 
		}*/
		
		static public function addStopAtEnd(actor:Actor, anim:MovieClip) : LogicCallbackOnFrame {
			return addCallbackOnFrame(actor, new Callback(anim.gotoAndStop, anim, [anim.totalFrames]), anim.totalFrames, anim); 
		}
		
		static public function addRecurStopAtEnd(actor:Actor, anim:MovieClip) : LogicCallbackOnFrame {
			return addCallbackOnFrame(actor, new Callback(Utils.recurStop, Utils, [anim]), anim.totalFrames, anim);
		}

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
