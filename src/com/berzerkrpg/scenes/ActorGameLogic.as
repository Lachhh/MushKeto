package com.berzerkrpg.scenes {
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.lachhh.lachhhengine.actor.Actor;

	/**
	 * @author LachhhSSD
	 */
	public class ActorGameLogic extends Actor {
		static public var instance : ActorGameLogic;
		private var metaGameProgress : MetaGameProgress;

		public function ActorGameLogic(pMetaGameProgress : MetaGameProgress) {
			super();
			MainGame.instance.gameSceneManager.gameScene.heroManager.add(this);
			
			metaGameProgress = pMetaGameProgress;
			
			instance = this;
			refresh();
		}

		
	}
}
