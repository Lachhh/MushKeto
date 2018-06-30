package com.berzerkrpg.components {
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.components.ActorComponent;

	/**
	 * @author LachhhSSD
	 */
	public class LogicMoveWithKeyBoard extends ActorComponent {
		public var speed:Number = 5;
		public function LogicMoveWithKeyBoard() {
			super();
		}
		
		
		override public function update() : void {
			super.update();
			if(KeyManager.IsKeyDownAtLeast(KeyManager.RIGHT_AND_D)) actor.px += speed;
			if(KeyManager.IsKeyDownAtLeast(KeyManager.LEFT_AND_A)) actor.px -= speed;
			if(KeyManager.IsKeyDownAtLeast(KeyManager.DOWN_AND_S)) actor.py += speed;
			if(KeyManager.IsKeyDownAtLeast(KeyManager.UP_AND_W)) actor.py -= speed;
		}

	}
}
