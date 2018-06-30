package com.berzerkrpg.meta {
	import com.lachhh.lachhhengine.DataManager;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhh.lachhhengine.sfx.Jukebox;

	import flash.utils.Dictionary;
	/**
	 * @author LachhhSSD
	 */
	public class MetaGameProgress {
		static public var instance : MetaGameProgress = MetaGameProgress.create();
		static public var LOCAL : String = "[LOCAL]";
		public var numPlay:int = 0;
		public var numSaves:int = 0;
		public var onlineAccountName:String = "";
		public var berzerkPalsToken:String = "";
		public var berzerkPalsUsername:String = "";
		
		public var creationDate:Date = new Date();
		public var metaRecipeGroup : MetaRecipeGroup = new MetaRecipeGroup();
		public var metaPendingRecipe : MetaRecipe ;
		public var metaSettings : MetaSettings = new MetaSettings();

		private var objData : Dictionary = new Dictionary();
		private var objDataLocal : Dictionary = new Dictionary();
		
		public function MetaGameProgress() {
			numPlay = 0;
			numSaves = 0;
			
			onlineAccountName = "";
			creationDate = new Date();
			
			//metaSteamOptions.applyOptions();
		}
				
		public function clear():void {
			numPlay = 0;
			numSaves = 0;
			
		}
		
		
		public function encode():Dictionary {
			objData["numPlay"] = numPlay;
			objData["numSaves"] = numSaves;
			objData["onlineAccountName"] = onlineAccountName;
			objData["creationDate"] = creationDate.toString();
			
			
			return objData; 
		}
		
		public function decode(obj:Dictionary):void {			
			numPlay = obj["numPlay"];
			numSaves = obj["numSaves"];
			onlineAccountName = obj["onlineAccountName"];
			
			creationDate = new Date(obj["creationDate"]);
			
			
		}
				
		
		
		public function isEmpty():Boolean {
			return (numPlay <= 0) ;
		}
		
		
		public function saveToLocal():void {
			if(VersionInfo.DEBUG_NOSave) return ;
			
			
			DataManager.lastLocalSaveFailed = false;
			DataManager.saveLocally(encode());
			DataManager.saveLocallyOptions(encodeLocal());
			
		}
		
		public function encodeLocal():Dictionary {
			return objDataLocal; 
		}
		
		public function decodeLocal(obj:Dictionary):void {
			if(obj == null) return ;
		}
		
	
		
		public function loadLocalValues():void {
			var dOptions:Dictionary = DataManager.loadLocalOptions() ;
			try {
				decodeLocal(dOptions);
			} catch(e:Error) {
				trace("Broken Local save file,  ignored");
				trace(e.toString());
				trace(e.getStackTrace());
			}
		}
		
		public function loadFromLocal():void {
			clear();
		
			var d:Dictionary ;
			var dOptions:Dictionary; 
			
			if(VersionInfo.isDebug) {
				try{
					d = DataManager.loadLocally();
					dOptions = DataManager.loadLocalOptions() ; 
					decode(d);
					decodeLocal(dOptions);
				} catch(e:Error){
					trace("BROKEN LOCAL SAVE");
					//trace(e.toString());
					trace(e.getStackTrace());
					// do nothing
				}
			} else {
				try {
					d = DataManager.loadLocally();
					decode(d);
				} catch(e:Error) {
					trace("Broken save file,  ignored");
					trace(e.toString());
					trace(e.getStackTrace());
				}
				
				try {
					dOptions = DataManager.loadLocalOptions() ;
					decodeLocal(dOptions);
				} catch(e:Error) {
					trace("Broken save file,  ignored");
					trace(e.toString());
					trace(e.getStackTrace());
				}
			}
			
			if(VersionInfo.DEBUG_NoSounds) {
				Jukebox.MUSIC_VOLUME = 0;
				Jukebox.SFX_VOLUME = 0;
			}
		}
		
		
		static public function create():MetaGameProgress {
			var result:MetaGameProgress = new MetaGameProgress();
			result.clear();
			return result;
		}

		static public function createFromDictionnary(d:Dictionary):MetaGameProgress {
			var result:MetaGameProgress = new MetaGameProgress();
			result.clear();
			result.decode(d);
			return result;
		}

		public function isNewer(otherGameProgress : MetaGameProgress) : Boolean {
			if(numSaves >= otherGameProgress.numSaves) return true;
			return false;
		}
	}
}
