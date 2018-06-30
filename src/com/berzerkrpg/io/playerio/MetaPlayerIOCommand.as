package com.berzerkrpg.io.playerio {
	import com.lachhh.io.CallbackGroup;
	import com.lachhh.io.Callback;
	import playerio.Message;
	/**
	 * @author Eel
	 */
	public class MetaPlayerIOCommand {
		
		public var command:String = "";
		
		public var arg1:String = "";
		
		public var responses:Array;
		
		public var pIOresponse:Message;
		
		public var callbackOnResponse:CallbackGroup = new CallbackGroup();
		
		public function MetaPlayerIOCommand(pCommand:String, pArg1:String, pResponses:Array, pCallbackOnResponse:Callback){
			command = pCommand;
			arg1 = pArg1;
			responses = pResponses;
			addResponseCallback(pCallbackOnResponse);
		}
		
		public function addResponseCallback(c:Callback):void{
			callbackOnResponse.addCallback(c);
		}
		
		public function onResponse(m:Message):void{
			pIOresponse = m;
			callbackOnResponse.callWithParams([m]);
		}
		
		public function hasResponded():Boolean{
			return (pIOresponse != null);
		}
	}
}