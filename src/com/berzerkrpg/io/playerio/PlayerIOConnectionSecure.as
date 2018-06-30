package com.berzerkrpg.io.playerio {
	import playerio.Client;
	import playerio.Connection;
	import playerio.DatabaseObject;
	import playerio.Message;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;

	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkrpg.meta.ModelPlatform;
	import com.lachhh.flash.FlashUtils;
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.DataManager;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.utils.Utils;

	import flash.display.DisplayObject;
	import flash.utils.ByteArray;

	/**
	 * @author Lachhh
	 */
	public class PlayerIOConnectionSecure extends PlayerIOConnection  {
		private var CONNECTION_TABLE:String = "Connections";
		private var REWARD_TABLE:String = "CloudRewards";
		private var NOTIFICATIONS_TABLE:String = "ServerNotifications";
		private var ALIAS_INDEX:String = "alias";
		private var ADMIN_SALE_SETTINGS:String = "AdminStoreSaleSettings";
		private var CROSS_PLATFORM_SHARE_SETTINGS:String = "CrossPlatformShare";
		private var DIAMOND_SHOP_SETTINGS_ENTRY:String = "DiamondShopSettings";
		private var FLASH_SALE_SETTINGS_ENTRY:String = "AdminFlashSaleSettings";
		private var NOTIFICATION_LIST_OBJECT:String = "DynamicBigNewsNotifications";
		private var PLAYEROBJECT_TABLE:String = "PlayerObjects";
		
		public var connectionId:int = -1;
		public var myAccountName:String = "";
		public var myAccountNameWithoutPrefix:String = "";
		public var userId:String;
		public var authToken:String;
		public var msgAuthType:String;
		public var myDate:Date;
		public var secureConnectionNameOnPIO:String = "secure";
		
		private var _connection:Connection;
		public var connectionGameRoom:PlayerIOGameRoomConnection;
		
		private var playerIOCommandQueue : Array = new Array();
		private var _isHandlingCommands : Boolean = false;
		private var authTokenAsByte : ByteArray;

		public function PlayerIOConnectionSecure(gameId : String, root : DisplayObject, debugMode : Boolean, debugName : String) {
			super(gameId, root, debugMode, debugName);
			partner = "";
			msgAuthType = "";
		}
				
		public function SecureConnectBerzerk(pUserId:String, pAuthToken:String, success : Callback = null, error : Callback = null):void {
			partner = "berzerk";
			msgAuthType = "authBerzerk";
			userId = pUserId;
			authToken = pAuthToken;
			
			if(VersionInfo.isAdminConnectionOnPIO) {
				secureConnectionNameOnPIO = "admin";
				msgAuthType = "authBerzerkAdmin";
			}
			
			SecureConnect(success, error);
		}
		
		public function SecureConnectAmazon(pUserId:String, pAuthToken:String, success : Callback = null, error : Callback = null):void {
			partner = "amazon";
			msgAuthType = "authAmazon";
			userId = pUserId;
			authToken = pAuthToken;
			
			SecureConnect(success, error);
		}
		
		public function SecureConnectGooglePlay(pUserId:String, pAuthToken:String, success : Callback = null, error : Callback = null):void {
			partner = "google play";
			msgAuthType = "authGooglePlay";
			userId = pUserId;
			authToken = pAuthToken;
			
			SecureConnect(success, error);
		}
		
		public function SecureConnectIOSGameCenter(pUserId:String, pAuthToken:String, success : Callback = null, error : Callback = null):void {
			partner = "ios game center";
			msgAuthType = "authIOSGameCenter";
			userId = pUserId;
			authToken = pAuthToken;
			
			SecureConnect(success, error);
		}
		
		public function SecureConnectSteam(pUserId:String, pAuthToken:String, success : Callback = null, error : Callback = null):void {
			partner = "Steam";
			msgAuthType = "authSteam";
			userId = pUserId;
			authToken = pAuthToken;
			
			SecureConnect(success, error);
		}
		
		public function SecureConnectFacebook(pUserId:String, pAuthToken:String, success : Callback = null, error : Callback = null):void {
			partner = "facebook";
			msgAuthType = "authFacebook";
			userId = pUserId;
			authToken = pAuthToken;
			
			SecureConnect(success, error);
		}
		
		public function SecureConnectNewgrounds(pUserId:String, pAuthToken:String, success : Callback = null, error : Callback = null):void {
			partner = "newgrounds";
			msgAuthType = "authNewgrounds";
			userId = pUserId;
			authToken = pAuthToken;
			
			SecureConnect(success, error);
		}
		
		public function SecureConnectArmorGames(pUserId:String, pAuthToken:String, success : Callback = null, error : Callback = null):void {			
			partner = "armorgames";
			msgAuthType = "authArmorGames";
			userId = pUserId;//armorGamesController.userId;
			authToken = pAuthToken;//armorGamesController.authToken;
			
			SecureConnect(success, error);		
			TraceMsg("Attempting Connect With ArmorGames");
		}
		
		public function SecureConnectGamerSafe(pUserId:String, pAuthToken:String, success : Callback, error : Callback):void {
			partner = "gamersafe";
			msgAuthType = "authGamerSafe";
			userId = pUserId;//GamerSafe.api.account.id ;
			authToken = pAuthToken;//GamerSafe.api.userAuthKey;
			
			
			if(VersionInfo.isAdminConnectionOnPIO) {
				secureConnectionNameOnPIO = "admin";
				msgAuthType = "authGamerSafeAdmin";
			}
			 
			SecureConnect(success, error);
		}
		
		public function SecureConnectKongregateManually(pUserId:String, pAuthToken:String, success : Callback, error : Callback):void {
			partner = "kongregate";
			msgAuthType = "authKongregate";
			userId = pUserId;//GamerSafe.api.account.id ; //kongregate.services.getUserId();
			authToken = pAuthToken;//GamerSafe.api.userAuthKey;  kongregate.services.getGameAuthToken();
			
			SecureConnect(success, error);
		}
		
		public function SecureConnectTwitch(pAuthToken:String, success : Callback, error : Callback):void {
			partner = "twitch";
			msgAuthType = "authTwitch";
			userId = "twitchUser";
			authToken = pAuthToken;
			
			SecureConnect(success, error);
			
			//TraceMsg("Attempting Connect With " + partner + "/" + authToken);
		}
		
		public function SecureConnectKizi(pUserId:String, pAuthToken:String, success : Callback, error : Callback):void {
			partner = "kizi";
			msgAuthType = "authKizi";
			userId = pUserId;
			authToken = pAuthToken;
			
			SecureConnect(success, error);
			
			//TraceMsg("Attempting Connect With " + partner + "/" + authToken);
		}
		
		public function SecureConnectYahooGamesManually(b64json:String, signature:String, success : Callback, error : Callback):void {
			partner = "yahoo";
			msgAuthType = "authYahoo";
			userId = b64json;
			authToken = signature;//GamerSafe.api.userAuthKey;  kongregate.services.getGameAuthToken();
			
			SecureConnect(success, error);
		}
		
		public function SecureConnectPioNetworkManually(b64json:String, signature:String, success : Callback, error : Callback):void {
			partner = "publishingnetwork";
			msgAuthType = "authPioNetwork";
			userId = b64json;
			authToken = signature;// GamerSafe.api.userAuthKey;  kongregate.services.getGameAuthToken();

			SecureConnect(success, error);
		}
		
		public function SecureConnect(success : Callback, error : Callback):void {
			if(connectPending) return;

			DeclarePending();
			SetCallbacks(success, error);
			var authArg:Object = new Object() ;
			authArg.userId = "testUser";
			
			PlayerIO.authenticate(root.stage, gameId, "public", authArg, null, onConnectTemp, onConnectError);
			
			TraceMsg("Attempting Connect With " + partner);
		}
		
		private function onConnectTemp(client:Client):void {
			if(debugMode) {
				client.multiplayer.developmentServer = "localhost:8184";
			}
			client.multiplayer.createJoinRoom("$service-room$", "AuthRoom", false, {}, {}, onRoomConnected, onConnectError);
			TraceMsg("Connected on 'public' connection.");
			TraceMsg("Joining AuthRoom...");
		}

		private function onRoomConnected(con : Connection) : void {
			_connection = con;
			
			con.addMessageHandler("auth", onAuthaurizationMsg);
			con.addMessageHandler("authError", onAuthaurizationMsgError);
			con.send(msgAuthType, userId, authToken);
			TraceMsg("AuthRoom Joined.");
			TraceMsg("Sending Auth...");
		}
		
		private function onAuthaurizationMsg(m:Message):void{
					
			if(m.length == 0){
				onConnectError(new PlayerIOError("Secured authorization failed", 27667));
				_connection.disconnect();
				_connection = null;
			}else{
				TraceMsg("Received Auth Info From Server.");
				myAccountName = m.getString(0);
				
				var auAuth:String = m.getString(1);
				var dateInString:String = m.getString(2);
				var dateInStringArray:Array  = dateInString.split(".");
				
				var day:int = FlashUtils.myParseFloat(dateInStringArray[0]);
				var month:int = FlashUtils.myParseFloat(dateInStringArray[1]);
				var year:int = FlashUtils.myParseFloat(dateInStringArray[2]);
				
				myDate = new Date(year, month-1, day);
				//myDate.setDate()
				//myDate.setTime(ticks);
				TraceMsg("My Date : " + day + "/" + month + "/" + year + "/" + myDate.toString());
				TraceMsg("Connectiong securely with aut infos...");
				var authArg:Object = new Object() ;
				authArg.userId = myAccountName;
				authArg.auth = auAuth;
				myAccountNameWithoutPrefix = ModelExternalPremiumAPIEnum.RemovePlatFormPrefixFromString(myAccountName);
			    //    { "userId", "MyUserName" },
			     
				if(VersionInfo.modelExternalAPI.id == ModelExternalPremiumAPIEnum.PIO_NETWORK.id) {
					var userToken:String = userId  + "." + authToken; 
					PlayerIO.authenticate(root.stage, gameId, "publishingnetwork", {userToken:userToken}, null, onSecuredConnectSuccess, function(e:PlayerIOError):void{
						
						onConnectError(e);
						_connection.disconnect();
						_connection = null;
					});
				} else {
					PlayerIO.authenticate(root.stage, gameId, secureConnectionNameOnPIO, authArg, null, onSecuredConnectSuccess, function(e:PlayerIOError):void{
						
						onConnectError(e);
						_connection.disconnect();
						_connection = null;
					});
				}
				
				/*PlayerIO.connect(root.stage, gameId, "secure", myAccountName, auAuth, partner, onSecuredConnectSuccess, function(e:PlayerIOError):void{
					
					onConnectError(e);
					_connection.disconnect();
					_connection = null;
				});*/
			}
		}
		
		
		
		private function onAuthaurizationMsgError(m:Message):void{
			var msg:String = "";
			if(m.length > 0) {
				msg = m.getString(0); 
			} else {
				msg = "Secured authorization failed";
			}
			
			onConnectError(new PlayerIOError(msg, 27667));
			_connection.disconnect();
			_connection = null;
		}
		
		private function onSecuredConnectSuccess(client : Client) : void {
			closeConnection();
			
			DeclareSuccess(client);
			
			TraceMsg("Secure Connect SUCCESS!");
		}
		
		public function connectToGameRoom(success:Callback):void {
			connectionGameRoom = new PlayerIOGameRoomConnection(client, debugMode);
			connectionGameRoom.onSuccess = success;
			connectionGameRoom.connectToRoom("GameRoom");

		}
		
		public function pushNewPlayerIOCommand(command:MetaPlayerIOCommand):void{
			playerIOCommandQueue.push(command);
			if(!_isHandlingCommands) handleNextCommand();
		}
		
		private function onConnectForCommand(con:Connection):void{
			_connection = con;
			handleNextCommand();
		}
		
		private function handleNextCommand():void{
			_isHandlingCommands = true;
			
			if(playerIOCommandQueue.length <= 0){
				closeConnection();
				_isHandlingCommands = false;
				return;
			}
			
			if(_connection == null){
				if(debugMode) {
					client.multiplayer.developmentServer = "localhost:8184";
				}
				client.multiplayer.createJoinRoom("$service-room$", "AuthRoom", false, {}, {}, onConnectForCommand, onConnectError);
				TraceMsg("Connected on 'public' connection.");
				TraceMsg("Joining AuthRoom...");
				return;
			}
			
			var firstCommand:MetaPlayerIOCommand = playerIOCommandQueue[0];
			
			for (var i : int = 0; i < firstCommand.responses.length; i++) {
				_connection.addMessageHandler(firstCommand.responses[i], onCommandResponse);
			}
			
			TraceMsg("Sending command: " + firstCommand.command + " : " + firstCommand.arg1);
			_connection.send(firstCommand.command, firstCommand.arg1);
		}
		
		private function onCommandResponse(m:Message):void{
			var firstCommand:MetaPlayerIOCommand = playerIOCommandQueue[0];
			firstCommand.onResponse(m);
			for (var i : int = 0; i < firstCommand.responses.length; i++) {
				_connection.removeMessageHandler(firstCommand.responses[i], onCommandResponse);
			}
			playerIOCommandQueue.shift();
			handleNextCommand();
		}
		
		private function closeConnection():void{
			if(_connection != null){
				if(_connection.connected) _connection.disconnect();
				_connection = null;
				TraceMsg("Connection closed");
			}
		}
		
		public function getListOfTwitchNotificationsWithPlatform(platform:String, success:Callback, onError:Callback):void{
			if(!loggedIn){
				if(onError) onError.call();
				return;
			}
			
			client.bigDB.loadRange(NOTIFICATIONS_TABLE, "ByPlatform", [platform], null, null, 100,
				function(list:Array):void{
					success.callWithParams([list]);
				},
				function(error:Object):void{
					trace(error);
					if(onError) onError.call();
				});
		}
		
		public function getListOfDynamicBigNewsNotifications(success:Callback, onError:Callback):void{
			if(!loggedIn){
				if(onError) onError.call();
				return;
			}
			
			client.bigDB.load(NOTIFICATIONS_TABLE, NOTIFICATION_LIST_OBJECT,
				function(ob:DatabaseObject):void {
						
						if(ob == null){
							if(onError) onError.call();
							return;
						}
						
						if(success) success.callWithParams([ob]);
						//onBigDBLoaded(ob);
						//if(success) success.call();	
					}, 
					function(error:Object):void {
						//onBigDBLoadedError();
						trace(error);
						if(onError) onError.call();
					}
				);
		}
		
		public function getListOfRewardsWithAliasKeys(aliasKeys:Array, success:Callback, onError:Callback):void{
			if(!loggedIn){
				if(onError) onError.call();
				return;
			}
			
			client.bigDB.loadKeys(REWARD_TABLE, aliasKeys,
				function(list:Array):void{
					success.callWithParams([list]);
				},
				function(error:Object):void{
					trace(error);
					if(onError) onError.call();
				});
		}
		
		public function deleteLegacyRewardsEntry(success:Callback, onError:Callback):void{
			if(!loggedIn) {
				if(onError) onError.call();
				return ;
			}
			
			client.bigDB.deleteKeys(REWARD_TABLE, [myAccountName],
				function():void{
					if(success) success.call();
				},
				function(error:Object):void{
					if(onError) onError.call();
				}
			);
		}
		
	

		public function loadAdminSaleSettingsObject(success:Callback, onErrorLoad:Callback):void{
			if(!loggedIn) {
				trace("admin sale data error: not logged in");
				if(onErrorLoad) onErrorLoad.call();
				return ;
			}
			
			client.bigDB.load(ADMIN_SALE_SETTINGS, DIAMOND_SHOP_SETTINGS_ENTRY,
				function(ob:DatabaseObject):void {
						
						if(ob == null){
							if(onErrorLoad) onErrorLoad.call();
							return;
						}
						
						if(success) success.callWithParams([ob]);
						//onBigDBLoaded(ob);
						//if(success) success.call();	
					}, 
					function(error:Object):void {
						//onBigDBLoadedError();
						trace(error);
						if(onErrorLoad) onErrorLoad.call();
					}
				);
		}
		
		public function loadAdminFlashSaleSettingsObject(success:Callback, onErrorLoad:Callback):void{
			if(!loggedIn) {
				trace("admin sale data error: not logged in");
				if(onErrorLoad) onErrorLoad.call();
				return ;
			}
			
			client.bigDB.load(ADMIN_SALE_SETTINGS, FLASH_SALE_SETTINGS_ENTRY,
				function(ob:DatabaseObject):void {
						
						if(ob == null){
							if(onErrorLoad) onErrorLoad.call();
							return;
						}
						
						if(success) success.callWithParams([ob]);
						//onBigDBLoaded(ob);
						//if(success) success.call();	
					}, 
					function(error:Object):void {
						//onBigDBLoadedError();
						trace(error);
						if(onErrorLoad) onErrorLoad.call();
					}
				);
		}
		
		public function loadPartnerShare(modelPlatform:ModelPlatform, success:Callback, onErrorLoad:Callback):void{
			if(!loggedIn) {
				trace("admin sale data error: not logged in");
				if(onErrorLoad) onErrorLoad.call();
				return ;
			}
			
			var startObj:Object = modelPlatform.id;
			if(modelPlatform.isNull) startObj = null;
			 
			client.bigDB.loadRange(CROSS_PLATFORM_SHARE_SETTINGS, "ByPartner", null, startObj, startObj, 1000, 
				function(ob:Array):void {
						
						if(ob == null){
							if(onErrorLoad) onErrorLoad.call();
							return;
						}
						if(ob.length >= 1000) {
							
						}
						
						if(success) success.callWithParams([ob]);
						//onBigDBLoaded(ob);
						//if(success) success.call();	
					}, 
					function(error:Object):void {
						//onBigDBLoadedError();
						trace(error);
						if(onErrorLoad) onErrorLoad.call();
					}
				);
		}
		
		public function loadPartnerShareDate(modelPlatform:ModelPlatform, month:int, year:int,  success:Callback, onErrorLoad:Callback):void{
			if(!loggedIn) {
				trace("admin sale data error: not logged in");
				if(onErrorLoad) onErrorLoad.call();
				return ;
			}
			
			var startObj:Object = modelPlatform.id;
			if(modelPlatform.isNull) startObj = null;
			var dateStart:Date = new Date(year, month, 1);
			var dateEnd:Date = new Date(year, ++month, 0);
			 
			client.bigDB.loadRange(CROSS_PLATFORM_SHARE_SETTINGS, "ByDate", [modelPlatform.id], dateStart, dateEnd, 1000, 
				function(ob:Array):void {
						if(ob == null){
							if(onErrorLoad) onErrorLoad.call();
							return;
						}
						
						if(ob.length >= 1000) {
							
						}
							
						if(success) success.callWithParams([ob]);
					}, 
					function(error:Object):void {
						trace(error);
						if(onErrorLoad) onErrorLoad.call();
					}
				);
		}
		
		
		
		

		public function getListOfLegacyAdminRewardsFromServer(success:Callback, onErrorLoad:Callback):void{
			if(!loggedIn) {
				if(onErrorLoad) onErrorLoad.call();
				return ;
			}
			
			client.bigDB.load(REWARD_TABLE, myAccountName,
				function(ob:DatabaseObject):void {
						
						if(ob == null){
							if(onErrorLoad) onErrorLoad.call();
							return;
						}
						
						if(success) success.callWithParams([ob]);
						//onBigDBLoaded(ob);
						//if(success) success.call();	
					}, 
					function(error:Object):void {
						//onBigDBLoadedError();
						if(onErrorLoad) onErrorLoad.call();
					}
				);
		}
		
		public function checkIfSameConnection(onSameConnection : Callback, onErrorMultipleConnection : Callback, onErrorLoad : Callback):void {
			if(!loggedIn) {
				if(onErrorLoad) onErrorLoad.call();
				return ;
			}
			
			client.bigDB.load(CONNECTION_TABLE, myAccountName, 
				function(ob:DatabaseObject):void {
					
					if(isSameConnection(ob)) {
						if(onSameConnection) onSameConnection.call();
					} else {
						if(onErrorMultipleConnection) onErrorMultipleConnection.call();	
					}
					//onBigDBLoaded(ob);
					//if(success) success.call();	
				}, 
				function(error:Object):void {
					//onBigDBLoadedError();
					if(onErrorLoad) onErrorLoad.call();
				}
			);
		}
		
		private function isSameConnection(dbObject:DatabaseObject):Boolean {
			var dbConnectionId:int = dbObject.connectionId;
			if(dbConnectionId == connectionId) return true;
			return false;
		}
		
		private function saveNewConnectionId(successCallback:Callback, errorCallback:Callback):void {
			saveNewConnectionIdOnAccount(successCallback, errorCallback, myAccountName);
		}
		
		private function saveNewConnectionIdOnAccount(successCallback:Callback, errorCallback:Callback, account:String):void {
			client.bigDB.loadOrCreate(CONNECTION_TABLE, account, function(ob:DatabaseObject):void {
					if(ob == null) {
						trace("error saving connection, db object null!");
						_lastError = "saveNewConnectionIdOnAccount : error saving connection, db object null!";
						if(errorCallback) errorCallback.call();
						return ;
					}
					connectionId = Utils.pickIntBetween(0, 99999999);
					ob.connectionId = connectionId;
					ob.save(false, false, 
						function():void {
							if(successCallback) successCallback.call();
						}, 
						function(error:PlayerIOError):void {
							trace(error);
							_lastError = error.message;
							if(errorCallback) errorCallback.call();
						}
					);
					
				}, 
				function(error:PlayerIOError):void {
					trace(error);
					_lastError = error.message;
					if(errorCallback) errorCallback.call();	
				} 
			);
		}
		
		public function doesGameExistWithName(name:String, successCallback:Callback, errorCallback:Callback):void{
			if(!loggedIn) {
				if(errorCallback) errorCallback.call();
				return ;
			}
			
			client.bigDB.load(PLAYEROBJECT_TABLE, name, function(ob:DatabaseObject):void {
					if(ob == null) {
						if(successCallback) successCallback.callWithParams([false]);
						return ;
					} else {
						if(successCallback) successCallback.callWithParams([true]);
						return ;
					}				
				}, 
				function(error:Object):void {
					if(errorCallback) errorCallback.call();	
					return;
				} 
			);
		}
		
		public function saveProgressOnOtherSaveFile(m:MetaGameProgress, successCallback:Callback, errorCallback:Callback):void {
			if(!loggedIn) {
				trace("[error] not logged in!");
				if(errorCallback) errorCallback.call();
				return ;
			}
			
			var connectionChangeSuccessCallback:Callback = new Callback(saveOtherGame, this, [m, successCallback, errorCallback]);
			saveNewConnectionIdOnAccount(connectionChangeSuccessCallback, errorCallback, m.onlineAccountName);
		}
		
		public function createNewGame(m:MetaGameProgress, successCallback:Callback, errorCallback:Callback):void{
			var ob:Object = new Object();
			DataManager.dictToObjectOuput(m.encode(), ob);
			client.bigDB.createObject(PLAYEROBJECT_TABLE, m.onlineAccountName, ob, 
			function():void{
				if(successCallback) successCallback.call();
			},
			function(error:Object):void{
				trace(error);
				if(errorCallback) errorCallback.call();	
			});
		}
		
		private function saveOtherGame(m:MetaGameProgress, successCallback:Callback, errorCallback:Callback):void {
			client.bigDB.load(PLAYEROBJECT_TABLE, m.onlineAccountName, function(ob:DatabaseObject):void {
					if(ob == null) {
						trace("[error] dbobject is null!");
						if(errorCallback) errorCallback.call();
						return ;
					}
					DataManager.dictToObjectOuput(m.encode(), ob);
			
					ob.save(false, false, function():void {
							if(successCallback) successCallback.call();
						}, 
						function(error:PlayerIOError):void {
							errorMsg = error;
							trace("[error] " + errorMsg);
							_lastError = error.message;
							errorCount++;
						
							if(errorCallback) errorCallback.call();
						}
					);					
				}, 
				function(error:PlayerIOError):void {
					trace(error);
					_lastError = error.message;
					if(errorCallback) errorCallback.call();	
				} 
			);
		}
		
		public function LoadMyData(success:Callback, errorCallback:Callback):void {
			if(!connected) return; 
			saveNewConnectionId(new Callback(onSaveConnectionSuccess, this, [success, errorCallback]), errorCallback);
			TraceMsg("Setting up New connection...");
		}
		
		private function onSaveConnectionSuccess(success:Callback, errorCallback:Callback):void {
			client.bigDB.loadMyPlayerObject(
				function(ob:DatabaseObject):void {
					onBigDBLoaded(ob);
					if(success) success.call();
				}, 
				function(error:PlayerIOError):void {
					trace(error);
					_lastError = error.message;
					onBigDBLoadedError();
					if(errorCallback) errorCallback.call();	
				}
			);
			TraceMsg("Loading Data...");
		}

		public function fixDateString(success : Callback, errorCall : Callback) : void {
			if(client == null) {
				if(errorCall) errorCall.call();
				return ;
			}
			
			var fctError:Function = (errorCall != null ? errorCall.call : null); 
			client.multiplayer.createJoinRoom("$service-room$", "AuthRoom", false, {}, {}, function(con:Connection):void {
				con.addMessageHandler("fixDateCrossPlatformShareSuccess", function(m:Message):void {
					con.disconnect();
					if(success) success.call();
					
					trace("Fixed date entry : " + m.getInt(0) + "/" + m.getInt(1));
				});
				con.addMessageHandler("fixDateCrossPlatformShareError", function(m:Message):void {
					con.disconnect();
					if(errorCall) errorCall.call();
				});
				con.send("fixDateCrossPlatformShare");	
				
			}, fctError);
		}
		
		public function loadOrCreateFriendKey(success : Callback, errorCall : Callback) : void {
			if(client == null) {
				if(errorCall) errorCall.call();
				return ;
			}
			
			var fctError:Function = (errorCall != null ? errorCall.call : null);
			 
			client.multiplayer.createJoinRoom("$service-room$", "AuthRoom", false, {}, {}, function(con:Connection):void {
				con.addMessageHandler("loadOrCreateFriendKeySuccess", function(m:Message):void {
					
					var key:String = m.getString(0);
					trace("My Friend Key: " + key);
					con.disconnect();
					if(success) success.callWithParams([key]);
					
				});
				con.addMessageHandler("loadOrCreateFriendKeyError", function(m:Message):void {
					con.disconnect();
					if(errorCall) errorCall.call();
				});
				con.send("loadOrCreateFriendKey", myAccountName);	
				
			}, fctError);
		}

		

		
		public function getFsURL(name:String, success:Callback, error:Callback):void{
			if(VersionInfo.isDebug){
				success.callWithParams([PlayerIO.gameFS("zombidle-2lmqaaqinuenmzlekqv33g").getUrl(name)]);
				return;
			}
			if(client == null) {
				if(error) error.call();
				return ;
			}
			success.callWithParams([client.gameFS.getUrl(name)]);
			return;
		}

	}
}
