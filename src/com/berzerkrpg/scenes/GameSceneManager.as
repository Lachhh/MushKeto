package com.berzerkrpg.scenes {
	import com.lachhh.io.ExternalAPIManager;
	/**
	 * @author LachhhSSD
	 */
	public class GameSceneManager {
		public var gameScene : GameScene;
		public var hasAScene:Boolean ;
		public function GameSceneManager() {
			hasAScene = false;
		}
		
		public function loadScene(pGameScene:GameScene):void {
			destroyScene();
			gameScene = pGameScene;
			gameScene.start();
			gameScene.update();
			hasAScene = true;
		}
		
		public function destroyScene():void {
			if(hasAScene) {
				gameScene.destroy();
				hasAScene = false;
			}
			ExternalAPIManager.berzerkAnimationManager.clearCache();
		}
		
		public function update():void {
			if(hasAScene) {
				if(gameScene.enabled) gameScene.update();
				if(gameScene.enabled) gameScene.startNewChildren();
			}
		}
	}
}
