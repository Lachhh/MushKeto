package com.lachhh.lachhhengine.ui {
	import com.berzerkrpg.effect.EffectFadeOut;
	import com.berzerkrpg.effect.ui.EffectShakeRotateUI;
	import com.berzerkrpg.ui.UI_BerzerkLogin;
	import com.berzerkrpg.ui.UI_Loading;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.DisplayObjectContainer;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.berzerkstudio.flash.display.TextField;
	import com.lachhh.ResolutionManager;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.ActorObjectManager;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.animation.ModelFlashAnimation;
	import com.lachhhStarling.berzerk.RenderFlashOrDisplay;

	import flash.events.MouseEvent;
	/**
	 * @author LachhhSSD
	 */
	public class UIBase extends Actor {
		static public var manager:ActorObjectManager = new ActorObjectManager();
		static public var defaultUIContainer:DisplayObjectContainer ;
		
		public var visual:MovieClip; 
		
		private var metaCallbacks : Vector.<MetaCallbackOnClickUI> = new Vector.<MetaCallbackOnClickUI>();
		
		public var isListeningToInput:Boolean;
		private var hasToCenterOnWindow:Boolean = false;
		
		
		public function UIBase(visualId:ModelFlashAnimation) {
			super();
			manager.debugName = "Screens";
			manager.add(this);
			
			renderComponent = RenderFlashOrDisplay.addToActor(this,  defaultUIContainer, visualId);

			visual = renderComponent.animView.anim;
			isListeningToInput = true;
			
			align();
		}
		
		protected function align():void {
			centerOnWindow();
			renderComponent.refresh();
		}
		
		public function centerOnOriginalScreen():void {
			px = ResolutionManager.originalRatioSize.width*0.5;
			py = ResolutionManager.originalRatioSize.height*0.5;
		}
		
		public function centerOnWindow():void {
			centerOnOriginalScreen();
			hasToCenterOnWindow = true;
			refreshCenterOnWindow();
		}
		
		private function refreshCenterOnWindow():void {
			visual.resolutionX = ResolutionManager.offsetPoint.x*0.5;
			visual.resolutionY = ResolutionManager.offsetPoint.y*0.5;
		}

		override public function refresh() : void {
			super.refresh();
			if(hasToCenterOnWindow) refreshCenterOnWindow();
		}

		static public function doNothing() : void {
			
		}
		
		static public function setNameOfDynamicBtn(btn:MovieClip, str:String):void {
			var txt:TextField = btn.getChildByName("txt") as TextField;
			if(txt == null) return;
			txt.text = str;
		}
		
		public function endTextFieldBatchForStarling():void {
			endTextFieldBatchForStarlingMc(renderComponent.animView.anim);
		}
		
		static public function endTextFieldBatchForStarlingMc(mc:DisplayObject):void {
			if(VersionInfo.starlingReady) {
				mc.endTextFieldBatchBeforeRendering = true;
			}
		}
		
		
		static public function blockInput(mc:DisplayObject):void {
			if(VersionInfo.starlingReady) {
				mc.blockInputOnTouch = true;
			}
		}
		
		override public function destroy() : void {
			enableInput(false);
			super.destroy();
		}
		
		public function doBtnPressAnim(btn:DisplayObject):void {
			doBtnPressAnimOnActor(this, btn);
		}
		
		static public function doBtnPressAnimOnActor(actor:Actor, btn:DisplayObject):void {
			EffectFadeOut.addToActorWithSpecificMc(actor, btn, 5, 0xFFFFFF);
			EffectShakeRotateUI.addToActor(actor, btn, 15);
		}
		
		public function registerClick(pVisual:DisplayObject, fctOnClick:Function):MetaCallbackOnClickUI {
			return registerClickWithCallback(pVisual, new Callback(fctOnClick, null, null));
		}	
		
		public function registerClickWithCallback(pVisual:DisplayObject, fctOnClick:Callback):MetaCallbackOnClickUI {
			var metaClick:MetaCallbackOnClickUI = new MetaCallbackOnClickUI(pVisual, MouseEvent.MOUSE_UP, fctOnClick);
			metaCallbacks.push(metaClick);
			return metaClick;
		}
		
		public function registerEventWithCallback(pVisual:DisplayObject, eventType:String, fctOnEvent:Callback):MetaCallbackOnClickUI {
			var metaClick:MetaCallbackOnClickUI = new MetaCallbackOnClickUI(pVisual, eventType, fctOnEvent);
			metaCallbacks.push(metaClick);
			return metaClick;
		}
		
		public function registerEvent(pVisual:DisplayObject, eventType:String, fctOnEvent:Function):MetaCallbackOnClickUI {
			return registerEventWithCallback(pVisual, eventType, new Callback(fctOnEvent, null, null));
		}
		
		public function removeEventFromVisual(visual:DisplayObject):void {
			for (var i : int = 0; i < metaCallbacks.length; i++) {
				var metaClick:MetaCallbackOnClickUI = metaCallbacks[i];
				if(metaClick.visual == visual) {
					metaCallbacks.splice(i, 1);
					metaClick.enable(false);
					i--;
				}
			}
		}
		
		public function buttonHasClickRegistered(btn:DisplayObject):Boolean{
			for (var i : int = 0; i < metaCallbacks.length; i++) {
				var metaClick:MetaCallbackOnClickUI = metaCallbacks[i];
				if(metaClick.visual == btn) {
					return true;
				}
			}
			return false;
		}
		
		public function enableInputOfButton(btn:DisplayObject, b:Boolean):void {
			for (var i : int = 0; i < metaCallbacks.length; i++) {
				var metaClick:MetaCallbackOnClickUI = metaCallbacks[i];
				if(metaClick.visual == btn) {
					metaClick.enable(b);
				}
			}
		}
		
		
		public function enableInput(b:Boolean):void {
			isListeningToInput = b;
			
			for (var i : int = 0; i < metaCallbacks.length; i++) {
				var metaClick:MetaCallbackOnClickUI = metaCallbacks[i];
				metaClick.enable(b);
			}
		}
		
		public function doEventFromVisual(eventType:String, visual:DisplayObject):void {
			for (var i : int = 0; i < metaCallbacks.length; i++) {
				var metaClick:MetaCallbackOnClickUI = metaCallbacks[i];
				if(!metaClick.isEnabled) continue;
				if(metaClick.visual != visual) continue;
				if(metaClick.eventType != eventType) continue;
				metaClick.call();
			}
		}
		
		public function changeTextOfBtnRecur(dc:DisplayObject, msg:String):Boolean {
			var txt:TextField = dc as TextField;
			var result:Boolean = false;
			if(txt) {
				txt.text = msg;
				return true;
			}
			
			var mc:MovieClip = dc as MovieClip;
			if(mc == null) return false;
			for (var i : int = 0; i < mc.numChildren; i++) {
				var child:DisplayObject = mc.getChildAt(i);
				result = changeTextOfBtnRecur(child, msg);
				if(result) return true;
			}
			return false;
		}
		
		static public function hasAPopupPending():Boolean {
			if(UIBase.manager.hasInstanceOf(UI_Loading)) return true;
			return false;
		}
		
		static public function canDoKeyboardShortcut():Boolean {
			if(UIBase.manager.hasInstanceOf(UI_BerzerkLogin)) return false;
			return true;
		}
		
	}
}
