package com.berzerkrpg.io.playerio {
	import playerio.Client;
	import playerio.Connection;
	import playerio.Message;
	import playerio.PlayerIO;

	import com.berzerkrpg.io.MetaExternalRequest;
	import com.lachhh.io.Callback;

	import flash.display.DisplayObject;

	/**
	 * @author Lachhh
	 */
	public class PlayerIOConnectionPublic extends PlayerIOConnection {
		private var _connection : Connection;
		public var serverDate:Date;
		public var dateLoaded:Boolean = false;
		private var callbackOnDateLoaded:Callback;
		
		public function PlayerIOConnectionPublic(gameId : String, root : DisplayObject, debugMode : Boolean, debugName : String) {
			super(gameId, root, debugMode, debugName);
		}
		
		public function PublicConnect(success : Callback, error : Callback):void {
			SetCallbacks(success, error);
			PlayerIO.connect(root.stage, gameId, "public","testuser", "", "", onConnectPublic, onConnectError);
		}
		
		private function onConnectPublic(client:Client):void {			
			DeclareSuccess(client);
			TraceMsg("Connected on 'public' connection.");
		}

		private function onRoomConnected(con:Connection):void {
			_connection = con;
			
			con.addMessageHandler("getDate", onAuthaurizationMsg);
			con.send("getDate");
			
			TraceMsg("AuthRoom Joined.");
			TraceMsg("Sending Auth...");
		}
		
		private function onAuthaurizationMsg(m:Message):void{
			var dateStr:String = m.getString(0);
			serverDate = new Date(dateStr + " GMT-0000");
			dateLoaded = true;
			
			if(callbackOnDateLoaded) callbackOnDateLoaded.call();
			disconnect();
		}
		
		public function getServerDateWithRequest(mRequest:MetaExternalRequest):void {
			mRequest.startTimer();
			getServerDate(mRequest.createTriggerSuccessCallback(), mRequest.createTriggerErrorCallback());
		}
		public function getServerDate(success:Callback, error:Callback):void {
			callbackOnDateLoaded = success;
			dateLoaded = false;
			serverDate = null;
			if(_connection && !_connection.connected) {
				_connected = false;
			}
			if(!connected) {
				PublicConnect(new Callback(getServerDate, this, [success, error]), error);
				return ;
			}
			
			if(_connection == null) {
				if(debugMode) {
					client.multiplayer.developmentServer = "localhost:8184";
				}
				SetCallbacks(null, error);
				client.multiplayer.createJoinRoom("$service-room$", "AuthRoom", false, {}, {}, onRoomConnected, onConnectError);
				return ;	
			} else {
				_connection.send("getDate");
			}
		}

		override public function disconnect() : void {
			super.disconnect();
			disconnectFromRoom();
		}
		
		public function disconnectFromRoom() : void {
			if(_connection) {
				_connection.disconnect();
				_connection = null;
				serverDate = null;
				dateLoaded = false;
				callbackOnDateLoaded = null;
			}
		}
	}
}
