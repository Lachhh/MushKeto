package com.berzerkrpg.io {
	import com.berzerkrpg.MainGame;
	import com.berzerkrpg.io.playerio.ModelExternalPremiumAPIEnum;
	import com.berzerkrpg.meta.MetaGameProgress;
	import com.berzerkrpg.multilingual.TextFactory;
	import com.berzerkrpg.ui.UI_LoadingVecto;
	import com.berzerkrpg.ui.UI_PopUp;
	import com.lachhh.io.Callback;
	import com.lachhh.io.ExternalAPIManager;
	import com.lachhh.lachhhengine.VersionInfo;

	import flash.utils.Dictionary;
	/**
	 * @author Eel
	 */
	public class CrossPlatformUtils {
		
		private static var pendingData:MetaGameProgress;
		private static var _shouldOverwriteExistingBerzerkCloudSave:Boolean = false;
		
		private static var ui_crossplatform:UI_CrossplatformSelector;
		private static var crossplatformUsername:String = "";
		
		public static function get hasUploadPending():Boolean{
			return pendingData != null;
		}
		
		public static function get shouldOverwriteExistingBerzerkCloudSave():Boolean{
			return _shouldOverwriteExistingBerzerkCloudSave;
		}
		
		public static function getThenClearPendingData():MetaGameProgress{
			_shouldOverwriteExistingBerzerkCloudSave = false;
			var result:MetaGameProgress = pendingData;
			pendingData = null;
			return result; 
		}
		
		public static function saveCurrentDataForOverwriteOnBerzerk(data:MetaGameProgress):void{
			pendingData = data;
			_shouldOverwriteExistingBerzerkCloudSave = true;
		}
		
		public static function saveCurrentDataForUpload(data:MetaGameProgress):void{
			pendingData = data;
		}
		
		public static function resetToDefaultAPI():void{
			VersionInfo.modelExternalAPI = VersionInfo.platformExternalAPI;
			ExternalAPIManager.pioAccount = ExternalAPIManager.platformPioAccount;
			ExternalAPIManager.premiumAPI = ExternalAPIManager.platformPremiumAPI;
			PlayerIOZombIdleController.getInstance().setNewAPI(VersionInfo.modelExternalAPI);
		}
		
		public static function disconnectAndReplaceWithBerzerkPalsAPI():void{
			toCheckToReplaceForPaypal();
			
			PlayerIOZombIdleController.getInstance().myPublicConnection.disconnect();
			PlayerIOZombIdleController.getInstance().mySecuredConnection.disconnect();
			
			VersionInfo.modelExternalAPI = ModelExternalPremiumAPIEnum.BERZERK;
			PlayerIOZombIdleController.getInstance().setNewAPI(VersionInfo.modelExternalAPI);
			
			ExternalAPIManager.pioAccount = BerzerkUserAPI.instance;
		}
		
		private static function toCheckToReplaceForPaypal():void {
			if(VersionInfo.modelPlatform.isMobile()) return ;
			if(VersionInfo.modelExternalAPI.id == ModelExternalPremiumAPIEnum.KONGREGATE.id) return ;
			if(VersionInfo.modelExternalAPI.id == ModelExternalPremiumAPIEnum.ARMORGAMES.id) return ;
			if(VersionInfo.modelExternalAPI.id == ModelExternalPremiumAPIEnum.STEAM.id) return ;
			
			var paypalPremiumAPI:PlayerIOPaypalPremiumAPI = new PlayerIOPaypalPremiumAPI(BerzerkUserAPI.instance);
			paypalPremiumAPI.Connect(null);
			ExternalAPIManager.premiumAPI = paypalPremiumAPI;
		}
		
		public static function clearUploadData():void{
			pendingData = null;
		}
		
		public static function tryToConnectCrossplatform():void{
			if(!isAllowedToCrossPlatofrm(true)) return ;
			
			if(!BerzerkUserAPI.instance.loggedIn){
				BerzerkUserAPI.instance.addLoginCallback(new Callback(onLoginSuccess, CrossPlatformUtils, null));
				BerzerkUserAPI.instance.addCallbackOnLoginClose(new Callback(onLoginPromptClose, CrossPlatformUtils, null));
				BerzerkUserAPI.instance.ShowLogin();
			}
			else {
				onLoginSuccess();
			}
		}
		
		public static function isAllowedToCrossPlatofrm(showWarningPopup:Boolean = false):Boolean {
			if(VersionInfo.DEBUG_AISafemode) return false;
			
			if(!(VersionInfo.isDebug && VersionInfo.DEBUG_LOCAL_SAVE_TRANSFER_TO_BP_POSSIBLE)) {
				if(!ExternalAPIManager.pioAccount.loggedIn){
					if(showWarningPopup) UI_PopUp.createOkOnly(TextFactory.NEED_TO_BE_LOGGED_IN.getText(), null);
					return false;
				}
			}
			if(!VersionInfo.modelExternalAPI.isAllowedToConnectSavesToBerzerkpals){
				if(showWarningPopup) UI_PopUp.createOkOnly("If you see this, you should really tell Kojak!", null);
				return false;
			}
			if(ExternalAPIManager.pioAccount.loggedIn && VersionInfo.modelExternalAPI.isBerzerk){
				if(showWarningPopup) UI_PopUp.createOkOnly(TextFactory.ALREADY_PLAYING_WITH_BERZERK_ACCOUNT.getText(), null);
				return false;
			}
			return true;
		}
		
		private static function onLoginPromptClose():void{
			
		}
		
		private static function onLoginSuccess():void{
			//var text:String = TextFactory.CONFIRM_LINK_WITH_BERZERK.getText();
			//text = FlashUtils.myReplace(text, "[x]", BerzerkUserAPI.instance.getUserId());
			//UI_PopUp.createYesNo(text, new Callback(onConfirmTransferSave, CrossPlatformUtils, null), null);
			onConfirmTransferSave();
		}
		
		private static function onConfirmTransferSave():void{
			UI_LoadingVecto.show(MainGame.instance.stage, "Checking if game exists...");
			crossplatformUsername = ModelExternalPremiumAPIEnum.BERZERK.prefixId + BerzerkUserAPI.instance.getPioId();
			PlayerIOZombIdleController.getInstance().mySecuredConnection.doesGameExistWithName(crossplatformUsername, new Callback(onGameExistsResult, CrossPlatformUtils, null), new Callback(onGameExistsError, CrossPlatformUtils, null));
		}
		
		private static function onGameExistsResult(gameExists:Boolean):void{
			UI_LoadingVecto.hide();
			if(gameExists){
				//UI_PopUp.createYesNo("A save with that account already exists, do you want to link these saves?", new Callback(onConfirmUseExistingBerzerkSave, this, null), null);
				ui_crossplatform = UI_CrossplatformSelector.showForOverwriteExistingSave(crossplatformUsername);
				ui_crossplatform.callbackOnError.addCallback(new Callback(onErrorWithCrossplatformPanel, CrossPlatformUtils, null));
				ui_crossplatform.callbackOnBerzerkSaveSelected.addCallback(new Callback(onConfirmUseExistingBerzerkSave, CrossPlatformUtils, null));
				ui_crossplatform.callbackOnPlatformSaveSelected.addCallback(new Callback(onSelectPlatformSaveForOverwrite, CrossPlatformUtils, null));
				return;
			} else {
				UI_LoadingVecto.show(MainGame.instance.stage,"Copying save file...");
				copyGameForUploadToNewFile();
			}
		}
		
		private static function onSelectPlatformSaveForOverwrite():void{
			UI_PopupQuickProgressView.create(new Callback(popupConfirmOverwrite, CrossPlatformUtils, null), null, MetaGameProgress.instance);
		}
		
		private static function popupConfirmOverwrite():void{
			UI_PopUp.createYesNo(TextFactory.TRANSFER_SAVE_IRREVERSIBLE.getText(), new Callback(onConfirmOverwriteBerzerkWithPlatformSave, CrossPlatformUtils, null), null);
		}
		
		private static function onConfirmOverwriteBerzerkWithPlatformSave():void{
			ui_crossplatform.close();
			copyGameForOverwriteOnBerzerkPals();
		}
		
		private static function onErrorWithCrossplatformPanel():void{
			ui_crossplatform.close();
			onGameExistsError();
		}
		
		private static function onConfirmUseExistingBerzerkSave():void{
			ui_crossplatform.close();
			UI_LoadingVecto.show(MainGame.instance.stage, "Linking save files...");
			var newName:String = ModelExternalPremiumAPIEnum.BERZERK.prefixId + BerzerkUserAPI.instance.getPioId();
			linkCurrentSaveToNewSave(newName);
		}
		
		private static function copyGameForUploadToNewFile():void{
			try{
				MetaGameProgress.instance.metaPlayerInfo.checkToUpdateInfo();
				var saveData:Dictionary = MetaGameProgress.instance.encode();
				var newSave:MetaGameProgress = MetaGameProgress.createFromDictionnary(saveData);
			}
			catch(e:Error){
				UI_PopUp.createOkOnly("Something went wrong copying your game, aborted so it wouldn't cause problems!", null);
				return;
			}
			if(newSave == null){
				UI_PopUp.createOkOnly("Something went wrong copying your game, aborted so it wouldn't cause problems!", null);
				return;
			}
			if(newSave.isEmpty()){
				UI_PopUp.createOkOnly("Something went wrong copying your game, aborted so it wouldn't cause problems!", null);
				return;
			}
			newSave.onlineAccountName = ModelExternalPremiumAPIEnum.BERZERK.prefixId + BerzerkUserAPI.instance.getPioId();
			newSave.accountNameToAutoLoad = "";
			trace(newSave.onlineAccountName);
			CrossPlatformUtils.saveCurrentDataForUpload(newSave);
			linkCurrentSaveToNewSave(newSave.onlineAccountName);
		}
		
		private static function copyGameForOverwriteOnBerzerkPals():void{
			try{
				MetaGameProgress.instance.metaPlayerInfo.checkToUpdateInfo();
				var saveData:Dictionary = MetaGameProgress.instance.encode();
				var newSave:MetaGameProgress = MetaGameProgress.createFromDictionnary(saveData);
			}
			catch(e:Error){
				UI_PopUp.createOkOnly("Something went wrong copying your game, aborted so it wouldn't cause problems!", null);
				return;
			}
			if(newSave == null){
				UI_PopUp.createOkOnly("Something went wrong copying your game, aborted so it wouldn't cause problems!", null);
				return;
			}
			if(newSave.isEmpty()){
				UI_PopUp.createOkOnly("Something went wrong copying your game, aborted so it wouldn't cause problems!", null);
				return;
			}
			newSave.onlineAccountName = ModelExternalPremiumAPIEnum.BERZERK.prefixId + BerzerkUserAPI.instance.getPioId();
			newSave.accountNameToAutoLoad = "";
			trace(newSave.onlineAccountName);
			CrossPlatformUtils.saveCurrentDataForOverwriteOnBerzerk(newSave);
			linkCurrentSaveToNewSave(newSave.onlineAccountName);
		}
		
		private static function linkCurrentSaveToNewSave(newSaveID:String):void{
			MetaGameProgress.instance.accountNameToAutoLoad = newSaveID;
			MetaGameProgress.instance.berzerkPalsUsername = BerzerkUserAPI.instance.getPioId();
			MetaGameProgress.instance.berzerkPalsToken = BerzerkUserAPI.instance.getAuthToken();
			LogicAutoSave.saveGameOnServerAndLocal();
			UI_LoadingVecto.hide();
			restart();
		}
		
		private static function restart():void{
			UI_Transition.transitionToTitleScreen();
		}
		
		private static function onGameExistsError():void{
			UI_LoadingVecto.hide();
			UI_PopUp.createOkOnly(TextFactory.LOADING_MSG_ERROR.getText(), null);
		}
		
	}
}