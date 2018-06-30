package com.lachhh.lachhhengine.camera {
	import com.lachhh.ResolutionManager;
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.actor.Actor;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * @author LachhhSSD
	 */
	public class CameraBase extends Actor {
		public var boundsFOV:Rectangle = new Rectangle();
		public var boundsMax:Rectangle = new Rectangle();
		
		public var zoomScale:Number = 1;
		
		private var mouseInWorld:Point = new Point();
		
		static public var tempRect : Rectangle = new Rectangle();

		public function CameraBase() {
			refreshFOV();
		}
		
		public function refreshFOV():void {
			boundsFOV.width = ResolutionManager.getGameWidth()/zoomScale;
			boundsFOV.height = ResolutionManager.getGameHeight()/zoomScale;
		}
		

		public function zoom(scale:Number):void {
			zoomScale = scale;
			refreshFOV();
		}
		
		public function getPointInWorld(p:Point, output:Point):Point {
			var mouseXFromCenter:Number = p.x - (ResolutionManager.getGameWidth()*0.5);
			var mouseYFromCenter:Number = p.y - (ResolutionManager.getGameHeight()*0.5);
			var dx:Number = (mouseXFromCenter) / (ResolutionManager.getGameWidth() / (boundsFOV.width+0.0));
			var dy:Number = (mouseYFromCenter) / (ResolutionManager.getGameHeight() / (boundsFOV.height+0.0));
			
			//Debug.Log(dx+"/"+ dy);
			output.x = px + dx ;
			output.y = py + dy ;
			return output;
		}
		
		public function getMouseInWorld():Point {
			return getPointInWorld(KeyManager.GetMousePos(), mouseInWorld);
		}
		
		public function worldToScreenX(x:Number):Number {
			var dx:Number = (x-px);
			return dx+(ResolutionManager.getGameWidth()*0.5);
		}
		
		public function worldToScreenY(y:Number):Number {
			var dy:Number = (y-py);
			return dy+(ResolutionManager.getGameHeight()*0.5);
		}
		
		public function worldToScreen(output:Point):Point {
			var dx:Number = (output.x-px)*zoomScale;
			var dy:Number = (output.y-py)*zoomScale;
			
			output.x = dx-(ResolutionManager.getGameWidth()*0.5);
			output.y = dy-(ResolutionManager.getGameHeight()*0.5);
			return output;
		}
				
		public function updateBounds():void {
			if(boundsMax.width > 0) { 
				px = Math.max(boundsMax.x+boundsFOV.width*.5, px);
				px = Math.min(boundsMax.right-boundsFOV.width*.5, px);
			} 
			
			if(boundsMax.height > 0) { 
				py = Math.max(boundsMax.y+boundsFOV.height*.5, py);
				py = Math.min(boundsMax.bottom-boundsFOV.height*.5, py);
			}
			
			boundsFOV.x = px - ResolutionManager.getGameWidth()*0.5;
			boundsFOV.y = py - ResolutionManager.getGameHeight()*0.5;
		}
		
		public function isInFieldOfVIew(actor:Actor, offsetX:int, offsetY:int):Boolean {
			var isInFOVHorizontally:Boolean = Math.abs(actor.px-px) < (boundsFOV.width*0.5)+offsetX;
			var isInFOVVertically:Boolean = Math.abs(actor.py-py) < boundsFOV.height*0.5+offsetY;
			return (isInFOVHorizontally && isInFOVVertically);
		}
		
		public function getRandomXInBounds():int {
			return Math.random()*boundsFOV.width+boundsFOV.x;
		}
		
		public function getRandomYInBounds():int {
			return Math.random()*boundsFOV.height+boundsFOV.y;
		}
	}
}
