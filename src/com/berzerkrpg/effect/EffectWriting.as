package com.berzerkrpg.effect {
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.components.ActorComponent;

	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author LachhhSSD
	 */
	public class EffectWriting extends ActorComponent {
		public var msg:String= "";
		public var waitBetweenChar:int= 3;
		public var txt:TextField;
		public var txtShadow:TextField;
		public var numCharToShow:int = 0;
		public var callbackOnEnd:Callback = null;
		private var wait:CallbackWaitEffect = null;
		
		public function EffectWriting() {
			super();
		}

		override public function refresh() : void {
			super.refresh();
			refreshMsg();
		}

		private function refreshMsg():void {
			
			txt.text = msg;
			txtShadow.text = msg;
			refresTextFormat(txt, 0xFFFFFF);
			refresTextFormat(txtShadow, 0x990000);
			
		}
		
		private function refresTextFormat(txt:TextField, color:uint):void {
			if(msg.length == 0) return ;
			
			var i0:int = Math.min(numCharToShow, msg.length);
			var i1:int = msg.length;
			
			if(numCharToShow > 0) {
				var tfVisible : TextFormat = txt.getTextFormat(0, i0);
				tfVisible.color = color;
				txt.setTextFormat(tfVisible, 0, i0);
			}
			
			if(!hasFinishedToWrite()) {
				var tfInvisible : TextFormat = txt.getTextFormat(i0, i1);
				tfInvisible.color = 0x000000;
				txt.setTextFormat(tfInvisible, i0, i1);
			}
		}
		
		public function stopWriting():void {
			if(wait) wait.destroyAndRemoveFromActor();
			refresh();
			
		}
		
		public function startWritingFromBeginning():void {
			numCharToShow = 0;
			stopWriting();
			waitNextChar(waitBetweenChar);
		}
		
		private function waitNextChar(frameToWait:int):void {
			wait = CallbackWaitEffect.addWaitCallFctToActor(actor, nextChar, frameToWait);
		}
		
		private function nextChar():void {			
			numCharToShow++;

			if(!hasFinishedToWrite()) {
				waitNextChar(waitBetweenChar);
			} else {
				if(callbackOnEnd) callbackOnEnd.call();
			}
			refresh();
		}
		
		public function hasFinishedToWrite():Boolean {
			return (numCharToShow >= msg.length);  
		}
		
		static public function addToActor(actor: Actor, txt:TextField, txtShadow:TextField): EffectWriting {
			var result: EffectWriting = new EffectWriting();
			result.txt = txt;
			result.txtShadow = txtShadow;
			actor.addComponent(result);
			result.startWritingFromBeginning();
			return result;
		}
	}
}
