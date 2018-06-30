package com.berzerkrpg.io {
	import com.berzerkrpg.io.playerio.ModelExternalPremiumAPI;
	import com.berzerkrpg.io.playerio.ModelExternalPremiumAPIEnum;
	import com.berzerkrpg.io.playerio.PlayerIOConnectionPublic;
	import com.berzerkrpg.io.playerio.PlayerIOConnectionSecure;
	import com.berzerkrpg.io.playerio.PlayerIOFriendsController;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.ui.UI_PopUp;
	import com.lachhh.io.Callback;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.io.pioAccount.IPIOAccount;
	import com.lachhh.lachhhengine.VersionInfoDONOTSTREAM;

	import flash.display.DisplayObject;

	/**
	 * @author Lachhh
	 */
	public class PlayerIOZombIdleController {
		
		static private var _instance:PlayerIOZombIdleController;
		static private var _modelExternsalAPI:ModelExternalPremiumAPI;
		
		private var _myPublicConnection:PlayerIOConnectionPublic;
		private var _mySecuredConnection:PlayerIOConnectionSecure;
		private var _myFriendsController:PlayerIOFriendsController;
		private var connectPIODebugMode:Boolean;		
		
		public function PlayerIOZombIdleController(root:DisplayObject, modelExternsalAPI:ModelExternalPremiumAPI, debugMode:Boolean) {
			connectPIODebugMode = debugMode;
			_modelExternsalAPI = modelExternsalAPI;
			
			_mySecuredConnection = new PlayerIOConnectionSecure(VersionInfoDONOTSTREAM.PIO_ID, root, debugMode, "SECURED");
			_myPublicConnection	= new PlayerIOConnectionPublic(VersionInfoDONOTSTREAM.PIO_ID, root, debugMode, "PUBLIC");
			_myFriendsController = new PlayerIOFriendsController(_mySecuredConnection, modelExternsalAPI);
			
			//Security.allowDomain("*") ;
			//Security.allowDomain("playerio.com") ;
		}
		
		public function setNewAPI(model:ModelExternalPremiumAPI):void{
			_modelExternsalAPI = model;
		}
			
		public function get nameOfSystem() : String {
			return "PlayerIO";
		}
		
		public function get accountNameWithoutPrefix() : String {
			return ModelExternalPremiumAPIEnum.RemovePrefixFromModel(mySecuredConnection.myAccountName, _modelExternsalAPI);
		}
		
		static public function getInstance():PlayerIOZombIdleController {
			return _instance;
		}
		
		
		public function SecureConnectWithPIO(iPioAccount:IPIOAccount, success:Callback, error:Callback):void {
			
			switch(_modelExternsalAPI.id) {
				case ModelExternalPremiumAPIEnum.ARMORGAMES.id : 
					mySecuredConnection.SecureConnectArmorGames(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					break;
				case ModelExternalPremiumAPIEnum.KONGREGATE.id : 
					if(connectPIODebugMode) {
						mySecuredConnection.SecureConnectKongregateManually("XXXXXXX", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", success, error);
					} else {
						mySecuredConnection.SecureConnectKongregateManually(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					} 
					break;
				case ModelExternalPremiumAPIEnum.GAMERSAFE.id :
				 	mySecuredConnection.SecureConnectGamerSafe(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					break;
				case ModelExternalPremiumAPIEnum.YAHOO.id :
					mySecuredConnection.SecureConnectYahooGamesManually(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					break; 
				case ModelExternalPremiumAPIEnum.PIO_NETWORK.id :
					mySecuredConnection.SecureConnectPioNetworkManually(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					break; 
				
				case ModelExternalPremiumAPIEnum.NEWGROUNDS.id :
					mySecuredConnection.SecureConnectNewgrounds(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					break;
				case ModelExternalPremiumAPIEnum.GOOGLEPLAYGAMES.id :
					mySecuredConnection.SecureConnectGooglePlay(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					break;
				case ModelExternalPremiumAPIEnum.IOSGAMECENTER.id :
					mySecuredConnection.SecureConnectIOSGameCenter(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					break;
				case ModelExternalPremiumAPIEnum.AMAZON.id:
					mySecuredConnection.SecureConnectAmazon(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					break;
				case ModelExternalPremiumAPIEnum.STEAM.id :
					mySecuredConnection.SecureConnectSteam(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					break;
				case ModelExternalPremiumAPIEnum.FACEBOOK.id :
					mySecuredConnection.SecureConnectFacebook(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					break;
				case ModelExternalPremiumAPIEnum.BERZERK.id :
				case ModelExternalPremiumAPIEnum.BERZERK_FAKE.id :
					mySecuredConnection.SecureConnectBerzerk(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					break;
				case ModelExternalPremiumAPIEnum.TWITCH.id :
					mySecuredConnection.SecureConnectTwitch(iPioAccount.getAuthToken(), success, error);
					break;
				case ModelExternalPremiumAPIEnum.KIZI.id :
					mySecuredConnection.SecureConnectKizi(iPioAccount.getPioId(), iPioAccount.getAuthToken(), success, error);
					break;
			}	
		} 
	
		public function ShowLogin():void {
			switch(_modelExternsalAPI.id) {
				case ModelExternalPremiumAPIEnum.ARMORGAMES.id : 
					UI_PopUp.createOkOnly(TextFactory.ARMORGAMES_REFRESH_BROWSER.getText(), null);
					break;
				case ModelExternalPremiumAPIEnum.YAHOO.id : 
					UI_PopUp.createOkOnly(TextFactory.YAHOO_REFRESH_BROWSER.getText(), null);
					break;
				case ModelExternalPremiumAPIEnum.NEWGROUNDS.id : 
					UI_PopUp.createOkOnly(TextFactory.NEWGROUNDS_REFRESH_BROWSER.getText(), null);
					//ExternalAPIManager.premiumAPI.ShowLogin();
					break;	
				case ModelExternalPremiumAPIEnum.KONGREGATE.id : 
				case ModelExternalPremiumAPIEnum.GAMERSAFE.id :
				case ModelExternalPremiumAPIEnum.GOOGLEPLAYGAMES.id :
				case ModelExternalPremiumAPIEnum.IOSGAMECENTER.id : 
				case ModelExternalPremiumAPIEnum.AMAZON.id:
				case ModelExternalPremiumAPIEnum.FACEBOOK.id : 
				case ModelExternalPremiumAPIEnum.BERZERK.id :
				case ModelExternalPremiumAPIEnum.BERZERK_FAKE.id :
				
				case ModelExternalPremiumAPIEnum.STEAM.id :  
				 	ExternalAPIManager.premiumAPI.ShowLogin();
					break;
				default :
					ExternalAPIManager.premiumAPI.ShowLogin(); 
					break;
			}	
		} 
		
		static public function getPlatformString():String {
			var result:String = "[" + _modelExternsalAPI.id.toUpperCase() + "]";
			return result; 
		}
		
		static public function writeError(e:Error):void {
			if(getInstance() == null) return ;
			if(getInstance().mySecuredConnection == null) return ;
			if(getInstance().mySecuredConnection.client == null) return ;
			if(getInstance().mySecuredConnection.client.errorLog == null) return ;
			getInstance().mySecuredConnection.client.errorLog.writeError(getPlatformString() + ":" + e.toString(), e.message, e.getStackTrace(), null);
		}
		
		static public function writeErrorMsg(msg:String):void {
			if(getInstance() == null) return ;
			if(getInstance().mySecuredConnection == null) return ;
			if(getInstance().mySecuredConnection.client == null) return ;
			if(getInstance().mySecuredConnection.client.errorLog == null) return ;
			getInstance().mySecuredConnection.client.errorLog.writeError(getPlatformString() + ":" + msg, "", "", null);
		}

		static public function InitInstance(root:DisplayObject, modelExternal:ModelExternalPremiumAPI, debugMode:Boolean):void {
			if(_instance == null) {
				_instance = new PlayerIOZombIdleController(root, modelExternal, debugMode); 
			}	
		}
		
		public function get mySecuredConnection() : PlayerIOConnectionSecure {return _mySecuredConnection;}		
		public function get myPublicConnection() : PlayerIOConnectionPublic {return _myPublicConnection;}		
		public function get myFriendsController() : PlayerIOFriendsController {	return _myFriendsController;}		
	}
}
