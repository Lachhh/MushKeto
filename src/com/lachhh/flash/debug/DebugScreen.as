package com.lachhh.flash.debug {
	import com.berzerkrpg.MainGame;
	import com.lachhh.io.KeyManager;
	import com.lachhh.lachhhengine.ui.UIBaseFlashOnly;
	import com.lachhh.utils.Utils;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;

	/**
	 * @author Lachhh
	 */
	public class DebugScreen extends UIBaseFlashOnly {
		static private var _debugScreen:DebugScreen;
		private var _height:int = -1;
		private var _txtDebug:TextField ;
		private var _debugTreeContainer:MovieClip;
		

		//static private var _Instance:FPSCounter;
		//static private var m_FPS_txt:TextField;
		
		
		public function DebugScreen() {
			super(Sprite);
			_txtDebug = new TextField();
			_txtDebug.type = TextFieldType.INPUT;
			_txtDebug.multiline = false;
			_txtDebug.height = 20;
			_txtDebug.width = 350;
			_txtDebug.background = true;
			_txtDebug.backgroundColor = 0x666666;
			_txtDebug.textColor = 0xFFFFFF;
			
			_debugTreeContainer = new MovieClip();
			_debugTreeContainer.addChild(_txtDebug);
			
			MainGame.instance.stage.addChild(visualFlash);
			SetHeight();
			ShowTree();
			
			//renderComponentFlash.animView.addChildOnNewParent(MainGame.instance.stage);
			
		}
		
		override public function destroy():void {
			super.destroy();
			var debugTree:DebugTree = GameTree.GetTree();
			visualFlash.graphics.clear(); 
			/*if(flashAnim.contains(debugTree.visual)) {
				flashAnim.removeChild(debugTree.visual);
			}*/
			//flashAnim.removeChild(_txtDebug);
			Utils.LazyRemoveFromParent(_txtDebug);
			Utils.LazyRemoveFromParent(debugTree.visual);
		}
					 
		private function ShowTree():void {
			var debugTree:DebugTree = GameTree.GetTree(); 
			if(!visualFlash.contains(debugTree.visual)) {
				visualFlash.addChild(debugTree.visual);
			}	
		}

		override public function update() : void {
			super.update();
			GameTree.update();
			
			if(KeyManager.IsKeyPressed(Keyboard.ENTER)) {
				GameTree.DoCallback(_txtDebug.text);
				_txtDebug.text = "";
			}
			
			if(KeyManager.IsKeyPressed(Keyboard.ESCAPE)) {
				destroy();
			}
			
			if(KeyManager.IsKeyDown(Keyboard.UP)) {
				visual.y += 10;
			}
			
			if(KeyManager.IsKeyDown(Keyboard.DOWN)) {
				visual.y -= 10;
			}
			
			//checkScroll();
		}
		
		/*private function checkScroll():void {
			if(!KeyManager.IsMouseDown()) return ;
			if(KeyManager.GetMousePos().x > 200) return ;
			flashAnim.y += KeyManager.GetMouseMove().y;
		}*/
		
						
		private function SetHeight():void {
			var h:int = 1000;
			
			if(visual.stage != null) {
				h = visual.stage.stageHeight;
				_txtDebug.y = visual.stage.stageHeight - _txtDebug.height;
			}
				
			visualFlash.graphics.clear();
			visualFlash.graphics.beginFill(0, 0.5);
			visualFlash.graphics.drawRect(0, 0, 350, h);
			visualFlash.graphics.endFill();
			
			
		}
		
		static public function toggle():void {
			if(_debugScreen == null) {
				show();
			} else { 
				hide();
			}
		}
		
		static public function show():void {
			if(_debugScreen == null) {
				_debugScreen = new DebugScreen();
			}
		}
		
		static public function hide():void {
			if(_debugScreen != null) {
				_debugScreen.destroy();
				_debugScreen = null;
			}
		}
	}
}
