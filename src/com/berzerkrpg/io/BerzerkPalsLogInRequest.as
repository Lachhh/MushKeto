package com.berzerkrpg.io {
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.events.Event;
	import com.lachhh.io.Callback;
	import com.lachhh.io.CallbackGroup;
	/**
	 * @author Eel
	 */
	public class BerzerkPalsLogInRequest {
		
		private var _success:CallbackGroup = new CallbackGroup();
		private var _error:CallbackGroup = new CallbackGroup();
		
		private var _isComplete:Boolean = true;
		
		private var _errorMsg:String = "";
		
		private var _username:String = "";
		private var _token:String = "";
		
		public function BerzerkPalsLogInRequest(){
			
		}
		
		public function addSuccessCallback(c:Callback):void{
			_success.addCallback(c);
		}
		
		public function addErrorCallback(c:Callback):void{
			_error.addCallback(c);
		}
		
		public function get errorMessage():String{
			return _errorMsg;
		}
		
		public function get isComplete():Boolean { return _isComplete; }
		
		public function get isSuccessful():Boolean { return (_username != "" && _token != ""); }
		public function get hasError():Boolean { return _errorMsg != ""; }
		
		public function get username():String{ return _username; }
		public function get token():String { return _token; }
		
		public function sendRequest(pUsername:String, pPassword:String):void{
			_isComplete = false;
			
			var url:String = "https://berzerkpals.com/api/1/login";
			var loader:URLLoader = new URLLoader();
			var request : URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			var vars:URLVariables = new URLVariables();
			vars["login"] = pUsername;
			vars["password"] = pPassword;
			request.data = vars;
			loader.addEventListener(Event.COMPLETE, onResponse);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.load(request);
		}
		
		public function validateToken(pUsername:String, pToken:String):void{
			_token = pToken;
			
			var url:String = "https://berzerkpals.com/api/1/login";
			var loader:URLLoader = new URLLoader();
			var request : URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			var vars:URLVariables = new URLVariables();
			vars["login"] = pUsername;
			vars["token"] = pToken;
			request.data = vars;
			loader.addEventListener(Event.COMPLETE, onValidTokenResponse);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			loader.load(request);
		}
		
		private function onValidTokenResponse(event:Event):void{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if(data["success"] == null){
				declareError("Something went wrong! Looks like there was a problem with the Berzerk Pals server");
				return;
			}
			
			if(data["success"] == false){
				var msg:String = "Something went wrong!";
				if(data["message"] != null) msg = data["message"];
				declareError(msg);
				return;
			}
			
			declareSuccess(data["username"], token);
		}
		
		private function onResponse(event:Event):void{
			var loader:URLLoader = URLLoader(event.target);
			var data:Object = JSON.parse(loader.data);
			
			if(data["success"] == null){
				declareError("Something went wrong! Looks like there was a problem with the Berzerk Pals server");
				return;
			}
			
			if(data["success"] == false){
				var msg:String = "Something went wrong!";
				if(data["message"] != null) msg = data["message"];
				declareError(msg);
				return;
			}
			
			declareSuccess(data["username"], data["token"]);
		}
		
		private function onError(e:Event):void{
			trace(e);
			declareError("The Berzerk Pals server is temporarily offline, it should be back up shortly!");
		}
		
		private function declareSuccess(pUsername:String, pToken:String):void{
			_isComplete = true;
			_token = pToken;
			_username = pUsername;
			_success.call();
		}
		
		private function declareError(msg:String):void{
			_isComplete = true;
			_username = "";
			_token = "";
			_errorMsg = msg;
			_error.call();
		}
		
		public static function createSendRequest(username:String, password:String, success:Callback, error:Callback):BerzerkPalsLogInRequest{
			var result:BerzerkPalsLogInRequest = new BerzerkPalsLogInRequest();
			result.addErrorCallback(error);
			result.addSuccessCallback(success);;
			result.sendRequest(username, password);
			return result;
		}
		
		public static function createValidTokenRequest(username:String, token:String, success:Callback, error:Callback):BerzerkPalsLogInRequest{
			var result:BerzerkPalsLogInRequest = new BerzerkPalsLogInRequest();
			result.addErrorCallback(error);
			result.addSuccessCallback(success);;
			result.validateToken(username, token);
			return result;
		}
	}
}