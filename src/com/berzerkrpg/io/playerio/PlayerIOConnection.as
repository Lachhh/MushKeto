package com.berzerkrpg.io.playerio {
	import playerio.Client;
	import playerio.DatabaseObject;
	import playerio.PlayerIOError;

	import com.berzerkrpg.meta.MetaGameProgress;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.DataManager;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;

	/**
	 * @author Lachhh
	 */
	public class PlayerIOConnection {
		
		private var _debugName:String;
		private var _debugMode:Boolean = false;
		
		private var _client:Client;
		private var _gameId:String;
		public var partner:String;
		
		private var _success:Callback;
		private var _error:Callback;
		
		private var _root : DisplayObject;
		protected var _connected : Boolean;
		protected var _lastError:String;
		 
		private var _connectPending:Boolean;
		
		private var _myPlayerObject:DatabaseObject;
		private var _myPlayerObjectLoaded:Boolean;

		private var _dataLoadedCallback:Callback;
		public var errorMsg:Object;
		public var errorCount:int = 0;
		
		public function PlayerIOConnection(gameId:String, root:DisplayObject, debugMode:Boolean, debugName:String) {
			_debugName = debugName;
			_myPlayerObjectLoaded = false;
			_gameId = gameId;
			_root = root;
			_connected = false;
			_debugMode = debugMode;
			
			_lastError = "";
			
			_connectPending = false;
		}
				
		protected function SetCallbacks(success:Callback, error:Callback):void {
			_success = success;
			_error = error;
		}

		protected function DeclarePending():void {
			_connected = false;
			_connectPending = true;
		}
		
		protected function DeclareSuccess(client:Client):void {
			_client = client;
			_connected = true;
			_connectPending = false;
			
			if(_success) _success.call();
		}
		
		protected function DeclareError():void {
			_connected = false;
			_connectPending = false; 
			TraceMsg(_lastError);
			if(_error) _error.call();
		}
		
		protected function onConnectError(e:Error):void {	
			_lastError = e.message;
			DeclareError();
		}
		
		protected function onBigDBLoaded(ob:DatabaseObject) : void {
			_myPlayerObject = ob;
			_myPlayerObjectLoaded = true;
			if(_dataLoadedCallback) _dataLoadedCallback.call();
			TraceMsg("Data Loaded SUCCESS!");
		}
		
		protected function onBigDBLoadedError() : void {
			
		}
		
		public function get client() : Client {return _client;}	
		public function get connectPending() : Boolean {return _connectPending;}		
		public function get connected() : Boolean {return _connected;}		
		public function get loggedIn() : Boolean {return connected;}
		public function get myPlayerObject() : DatabaseObject {return _myPlayerObject;	}		
		public function get myPlayerObjectLoaded() : Boolean {return _myPlayerObjectLoaded;}		
		public function TraceMsg(str:String):void {
			trace("PlayerIOConnection (" + _debugName + ") : " + str);
		}
		
		public function get debugMode() : Boolean {
			return _debugMode;
		}
		
		public function get root() : DisplayObject {
			return _root;
		}
		
		public function get gameId() : String {
			return _gameId;
		}
		
		
		public function ClearData() : void {
			//SaveData(), null);
		}
		
		public function SaveData(m : MetaGameProgress, onDone : Callback, onErrorSave : Callback) : void {
			if(!loggedIn) {
				if(onErrorSave) onErrorSave.call();
				trace("not logged in");
				return ;
			}
			
			if(myPlayerObject != null) {
				DataManager.dictToObjectOuput(m.encode(), myPlayerObject);
				
				myPlayerObject.save(false, false, function():void {if(onDone) onDone.call();}, function(error:PlayerIOError):void {
					errorMsg = error;
					errorCount++;
					_lastError = error.message;
					trace(error);
					if(onErrorSave) onErrorSave.call();
					}
				);
			} else {
				_lastError = "SaveData : myPlayerObject == null";
				if(onErrorSave) onErrorSave.call();
			}
		}
		
			
		public function get isEmpty() : Boolean {
			return myPlayerObject.numPlay == null || myPlayerObject.numPlay == "";
		}
		
		public function get dataLoaded() : Boolean {
			return myPlayerObjectLoaded;
		}
		
		public function set onDataLoadedCallback(c : Callback) : void {
			_dataLoadedCallback = c;
		}
		
		public function disconnect():void {
			_connected = false;
			_client = null;
		}
		
		public function Connect(root : MovieClip, success : Callback = null, error : Callback = null) : void {}
		
		public function get nameOfSystem() : String {
			return "playerio";
		}
		
		

		public function get lastError() : String {
			return _lastError;
		}
	}
}
