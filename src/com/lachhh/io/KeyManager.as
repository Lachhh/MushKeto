package com.lachhh.io {
	import flash.utils.Dictionary;
	import com.lachhh.lachhhengine.VersionInfo;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;

	/*
	Event.ENTER_FRAME event
	target parents' frame scripts
	target's sibling objects' frame scripts for objects arranged below target
	target frame script [where frame navigation presumably occurs]
	Instantiation of each target's child objects in new frame
	Event.ADDED event for each target's child objects in new frame
	assignment of target's instance name properties for children in new frame
	target's sibling objects' frame scripts for objects arranged above target
	Event.RENDER event (requires call to stage.invalidate())
	Flash draws screen
	*/
	public class KeyManager {
		static private var tabOldState:Dictionary = new Dictionary();
		static private var tabState:Dictionary = new Dictionary();
		
		static private var _isInit:Boolean = false;
		static private var _mouseMove:Point = new Point();
		static private var _mousePos:Point = new Point();
		static private var _stage:Stage;
		static private var _main:DisplayObjectContainer;
		static private var _mouseDown:Boolean = false;
		static private var _oldMouseDown:Boolean = false;
		
		static public var lastKeyCodePressed:int = -1;
		
		static public var UP_AND_W:Array = [Keyboard.UP, Keyboard.W];
		static public var LEFT_AND_A:Array = [Keyboard.LEFT, Keyboard.A];
		static public var DOWN_AND_S:Array = [Keyboard.DOWN, Keyboard.S];
		static public var RIGHT_AND_D:Array = [Keyboard.RIGHT, Keyboard.D];
		
		static public var NUM_0:Array = [Keyboard.NUMBER_0, Keyboard.NUMPAD_0];
		static public var NUM_1:Array = [Keyboard.NUMBER_1, Keyboard.NUMPAD_1];
		static public var NUM_2:Array = [Keyboard.NUMBER_2, Keyboard.NUMPAD_2];
		static public var NUM_3:Array = [Keyboard.NUMBER_3, Keyboard.NUMPAD_3];
		static public var NUM_4:Array = [Keyboard.NUMBER_4, Keyboard.NUMPAD_4];
		static public var NUM_5:Array = [Keyboard.NUMBER_5, Keyboard.NUMPAD_5];
		static public var NUM_6:Array = [Keyboard.NUMBER_6, Keyboard.NUMPAD_6];
		static public var NUM_7:Array = [Keyboard.NUMBER_7, Keyboard.NUMPAD_7];
		static public var NUM_8:Array = [Keyboard.NUMBER_8, Keyboard.NUMPAD_8];
		static public var NUM_9:Array = [Keyboard.NUMBER_9, Keyboard.NUMPAD_9];
		
		
		static public var numPressedAKeyThisFrame:int = 0;
		

		public function KeyManager() {
			
		}
		
		
		
		static public function init(main:DisplayObjectContainer):void {
			if (_isInit) return ;
			_isInit = true;
			_stage = main.stage;
			_main = main;
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyManager.keyDownHandler);
			_stage.addEventListener(KeyboardEvent.KEY_UP, KeyManager.keyUpHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP, KeyManager.MouseUpHandler,false, 0);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, KeyManager.MouseDownHandler,false, 0);
			_stage.addEventListener(Event.DEACTIVATE, KeyManager.Deactivate);
			_stage.addEventListener(FocusEvent.FOCUS_OUT, KeyManager.Deactivate);
			
			
		}
		
		static public function Destroy():void {
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyManager.keyDownHandler);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, KeyManager.keyUpHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, KeyManager.MouseUpHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, KeyManager.MouseDownHandler);
			_stage.removeEventListener(Event.DEACTIVATE, KeyManager.Deactivate);
			_stage.removeEventListener(FocusEvent.FOCUS_OUT, KeyManager.Deactivate);
		} 
		
		static private function Deactivate(e:Event):void {
			for (var index : String in tabState) {
				tabState[index] = false;
			}
				
			_mouseDown = false;
		}
		
		static private function MouseUpHandler(evt:MouseEvent):void {
			_mouseDown = false;
			//trace("MOUSE UP");
		}

		static private function MouseDownHandler(evt:MouseEvent):void {
			//trace("MOUSE DOWN");
			_mouseDown = true;
		}
		
		static private function handleAndroidButtons(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.BACK){
				// don't let the OS handle this button
				event.preventDefault();
				event.stopImmediatePropagation();
			}
		}
		
		static public function keyDownHandler(event:KeyboardEvent):void {
			var key:uint = event.keyCode;
			
			tabState[key] = true;
			lastKeyCodePressed = key;
			numPressedAKeyThisFrame++;
			if(VersionInfo.modelPlatform.isAndroid()){
				handleAndroidButtons(event);
			}
			
		}

		static public function keyUpHandler(event:KeyboardEvent):void {
			tabState[event.keyCode] = false;
			
			if(VersionInfo.modelPlatform.isAndroid()){
				handleAndroidButtons(event);
				return;
			}
		}	
		
		static public function IsKeyDownAtLeast(a:Array):Boolean {
			var b:Boolean = false;
			for (var i:int= 0 ; i < a.length ; i++) b = b || IsKeyDown(a[i]); 
			return b;
		}
		
		static public function IsKeyPressedAtLeast(a:Array):Boolean {
			var b:Boolean = false;
			for (var i:int= 0 ; i < a.length ; i++) b = b || IsKeyPressed(a[i]); 
			return b;
		}
		
		static public function IsAnyKeyDown():Boolean {
			for (var i : String in tabState) 
				if(IsKeyDown(uint(i))) return true;
			return false;
		}
		
		static public function IsAnyKeyPressed():Boolean {
			for (var i : String in tabState)  
				if(IsKeyPressed(uint(i))) return true;
			return false;
		}
		
		static public function IsAnyKeyReleased():Boolean {
			for (var i : String in tabState) 
				if(IsKeyReleased(uint(i))) return true;
			return false;
		}
		
		
		
		static public function ByPassKeyDown(i:int, b:Boolean):Boolean {
			return (tabState[i] = b) ;
		}
		
		static public function IsKeyDown(i:int):Boolean {
			return (tabState[i]) ;
		}
		static public function IsKeyPressed(i:int):Boolean {
			return (!tabOldState[i] && tabState[i]) ;
		}
		static public function IsKeyReleased(i:int):Boolean {
			return (tabOldState[i] && !tabState[i]) ;
		}
		
		static public function IsKeyReleasedAtLeast(a:Array):Boolean {
			var b:Boolean = false;
			for (var i:int= 0 ; i < a.length ; i++) b = b || IsKeyReleased(a[i]); 
			return b;
		}
		
		
		static public function IsMouseDown():Boolean {
			return (_mouseDown);	
		}
		
		static public function IsMousePressed():Boolean {
			return (!_oldMouseDown && _mouseDown);	
		}
		
		static public function fakeMousePress():void {
			_oldMouseDown = false;
			_mouseDown = true;
		}
		
		static public function fakeMousePos(x:int, y:int):void {
			_mousePos.x = x;
			_mousePos.y = y;
		}
		
		static public function IsMouseReleased():Boolean {
			return (_oldMouseDown && !_mouseDown);	
		}
		
		static public function setMouseDown(b:Boolean):void {
			_mouseDown = b;	
		}
		
		static public function setMousePos(p:Point):void {
			_mousePos.x = p.x;
			_mousePos.y = p.y;
		}
		
		static public function setMouseMove(p:Point):void {
			_mouseMove.x = p.x;
			_mouseMove.y = p.y;
		}
		
		
		static public function GetMousePos():Point {
			return _mousePos;
		}
		
		static public function GetMouseMove():Point {
			return _mouseMove;
		}
		
		static public function update():void {			
			copyToOld();
			_mouseMove.x = (_main.mouseX - _mousePos.x);
			_mouseMove.y = (_main.mouseY - _mousePos.y);
			_mousePos.x = _main.mouseX;
			_mousePos.y = _main.mouseY;
			_oldMouseDown = _mouseDown ;
			numPressedAKeyThisFrame = 0;
		}
		
		static public function hasPressedAnyKey():Boolean {
			return numPressedAKeyThisFrame > 0;
		}

		static private function copyToOld():void {
			for (var i : String in tabState) {
				tabOldState[i] = tabState[i];
			}
		}
		
		static public function get isInit() : Boolean {
			return _isInit;
		}
	}
}