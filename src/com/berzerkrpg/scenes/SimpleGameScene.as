package com.berzerkrpg.scenes {
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.meta.MetaGameProgress;

	/**
	 * @author LachhhSSD
	 */
	public class SimpleGameScene extends GameScene {
		static public var instance:SimpleGameScene;
		
		public var actorGameLogic : ActorGameLogic;
		
		public function SimpleGameScene() {
			super();
			instance = this;
		}

		override public function start() : void {
			super.start();
			
			actorGameLogic = new ActorGameLogic(MetaGameProgress.instance);
			actorGameLogic.start();
			
			
		}
				
	}
}
