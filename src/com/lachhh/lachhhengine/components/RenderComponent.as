package com.lachhh.lachhhengine.components {
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.actor.Actor;
	import com.lachhh.lachhhengine.animation.FlashAnimationView;
	import com.lachhh.lachhhengine.camera.CameraFlash;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author LachhhSSD
	 */
	public class RenderComponent extends ActorComponent {
		public var animView:FlashAnimationView;
		public var xVisualOffset:Number = 0;
		public var yVisualOffset:Number = 0;	
		
		public function RenderComponent(parentVisual:DisplayObjectContainer) {
			super();
			animView = new FlashAnimationView(parentVisual);
		}
		
		override public function start() : void {
			super.start();
			
		}
		
		public function setAnim(animId:int):void {
			animView.setAnim(animId);
			
			debugInfo = animView.debugAnimName;
		}
		
		public function setAnimFollowedBy(animId:int, followedBy:int):void {
			setAnim(animId);
			animView.addEndCallback(new Callback(setAnim, this, [followedBy]));
		}

		override public function refresh() : void {
			super.refresh();
			animView.x = actor.px + xVisualOffset;
			animView.y = actor.py + yVisualOffset;
			animView.refresh();
		}
		
		override public function update() : void {
			super.update();
			
			animView.x = actor.px + xVisualOffset;
			animView.y = actor.py + yVisualOffset;
			animView.update();
		}

		override public function destroy() : void {
			super.destroy();
			animView.destroy();
		}
		
		public function getXRelativeToScreen():Number {
			return (actor.px + xVisualOffset)-CameraFlash.mainCamera.boundsFOV.x;
		}
		
		public function getYRelativeToScreen():Number {
			return (actor.py + yVisualOffset)-CameraFlash.mainCamera.boundsFOV.y ;
		}
		
		static public function addToActor(actor : Actor, parentVisual:DisplayObjectContainer, animId:int):RenderComponent {
			var result:RenderComponent = new RenderComponent(parentVisual);
			result.setAnim(animId);
			actor.addComponent(result);
			return result;
		}
		
		static public function addToActorAndRemoveOnEnd(actor : Actor, parentVisual:DisplayObjectContainer, animId:int):RenderComponent {
			var result:RenderComponent = new RenderComponent(parentVisual);
			result.setAnim(animId);
			result.animView.addEndCallback(new Callback(result.destroyAndRemoveFromActor, result, null));
			actor.addComponent(result);
			return result;
		}
	}
}
