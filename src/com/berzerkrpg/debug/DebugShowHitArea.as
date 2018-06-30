package com.berzerkrpg.debug {
	import com.berzerkrpg.MainGame;
	import com.berzerkstudio.flash.display.DisplayObject;
	import com.berzerkstudio.flash.display.MovieClip;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.components.ActorComponent;

	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	/**
	 * @author LachhhSSD
	 */
	public class DebugShowHitArea extends ActorComponent {
		private var sprite : Sprite;
		static private var tempPoint:Point = new Point();
		static private var tempRect:Rectangle = new Rectangle();  

		public function DebugShowHitArea() {
			super();
		}

		override public function start() : void {
			super.start();
			sprite = new Sprite();
			MainGame.instance.stage.addChild(sprite);
			
			
		}

		override public function update() : void {
			super.update();
			sprite.graphics.clear();
			
			if(KeyManager.IsKeyDown(Keyboard.BACKSPACE)) {
				recurShow(ExternalAPIManager.berzerkAnimationManager.getStage());
			}
			
			//sprite.graphics.lineTo(x, y)
		}
		
		private function recurShow(d:DisplayObject):void {
			if(d == null) return;
			
			if(d.hasMouseEvent) {
				tempPoint = d.getPosOnScreen(tempPoint);
				
				tempRect.x = d.hitArea.x + tempPoint.x;
				tempRect.y = d.hitArea.y + tempPoint.y;
				tempRect.width = d.hitArea.width;
				tempRect.height = d.hitArea.height;
				if(d.hitArea.x == 0) tempRect.x += -d.regX;
				if(d.hitArea.y == 0) tempRect.y += -d.regY;
				drawRectangle(tempRect);
			}
			
			var mc:MovieClip = d as MovieClip;
			if(mc == null) return;
			for (var i : int = 0; i < mc.numChildren; i++) {
				var child:DisplayObject = mc.getChildAt(i) as DisplayObject;
				if(!child.visible) continue;
				if(!child.mouseChildren) continue;
				recurShow(mc);
			}
		}
		
		private function drawRectangle(rect:Rectangle):void {
			sprite.graphics.beginFill(0x00ff00,0.5);
			sprite.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			sprite.graphics.endFill();
		}
	}
}
