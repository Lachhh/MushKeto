package com.lachhh.lachhhengine {
	import com.adobe.serialization.json.JSON;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.prng.Random;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.lachhh.flash.FlashUtils;
	import com.lachhh.io.Callback;

	import flash.media.Sound;
	import flash.net.FileReference;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * @author LachhhSSD
	 */
	public class DataManager {
		static public var soundLoaded:Sound;
		static public var soundLoadedCallback:Callback;
		static private var GAME_NAME:String = "GAME";
		static private var DATANAME_ENCRYPTED:String = "GAMEDATA_FGL";
		static private var DATANAME_NOT_ENCRYPTED:String = "GAMEDATA_FGL_UNSECURED";
		static private var DATANAME_OPTIONS:String = "GAMEDATA_OPTIONS";
		
		static private var _sharedObject:SharedObject = SharedObject.getLocal(GAME_NAME);
		
		
		static public var isEmpty:Boolean = checkIsEmpty();
		static public var isEmptyNotEncrypted:Boolean = (_sharedObject.data[DATANAME_NOT_ENCRYPTED] == "" || _sharedObject.data[DATANAME_NOT_ENCRYPTED] == null);
		static public var lastLocalSaveFailed:Boolean = false;
		
		static public function checkIsEmpty():Boolean {
			if(_sharedObject.data[DATANAME_ENCRYPTED] != "") return false;
			if(_sharedObject.data[DATANAME_ENCRYPTED] != null) return false;
			if(_sharedObject.data[DATANAME_NOT_ENCRYPTED] != "") return false;
			if(_sharedObject.data[DATANAME_NOT_ENCRYPTED] != null) return false;
			return true;
		}
		static public function save(ba:ByteArray):void {
			_sharedObject.data[DATANAME_ENCRYPTED] = ba;
			try {
		 		_sharedObject.flush();				
			} catch(e:Error) {
				lastLocalSaveFailed = true;	
			}
		}
		
		static public function saveNotEncrypted(ba:String):void {
			_sharedObject.data[DATANAME_NOT_ENCRYPTED] = ba;
			try {
		 		_sharedObject.flush();				
			} catch(e:Error) {
				lastLocalSaveFailed = true;	
			}
		}
		
		static public function saveOptions(string:String):void {
			_sharedObject.data[DATANAME_OPTIONS] = string;
			try {
		 		_sharedObject.flush();
			} catch(e:Error) {
				lastLocalSaveFailed = true;	
			}
		}
		
		static private function loadSharedObject():ByteArray {
			return _sharedObject.data[DATANAME_ENCRYPTED] as ByteArray;
		}
		
		static private function loadSharedObjectNotEncrypted():String {
			return _sharedObject.data[DATANAME_NOT_ENCRYPTED] ;
		}
		
		static private function loadSharedObjectOptions():String {
			return _sharedObject.data[DATANAME_OPTIONS];
		}
		
		static public function loadLocally():Dictionary {
			if(!VersionInfo.modelPlatform.isMobile()) return loadLocallyEncrypted();
			if(isEmptyNotEncrypted) return loadLocallyEncrypted();
			return loadLocallyNotEncrypted();
		}
		
		static private function shouldEncryptFile():Boolean {
			return !VersionInfo.modelPlatform.isMobile();
		}
		
		private static function loadLocallyEncrypted() : Dictionary {
			var encryptedBA:ByteArray = DataManager.loadSharedObject();
			if(encryptedBA == null) return null;
			var decryptedStr:String = GetStringFromByteArray(encryptedBA);
			var result:Dictionary = stringToDictionnary(decryptedStr);
			if(result == null){
				var legacyDecrypted:String = GetStringFromByteArrayLEGACY(encryptedBA);
				var newResult:Dictionary = stringToDictionnary(legacyDecrypted);
				return newResult;
			}
			return result;
		}

		private static function loadLocallyNotEncrypted() : Dictionary {
			if(!VersionInfo.modelPlatform.isMobile()) return null;
			var decryptedStr:String = loadSharedObjectNotEncrypted();
			return stringToDictionnary(decryptedStr);
		}
		
		static public function loadLocalOptions():Dictionary {
			if(_sharedObject.data[DATANAME_OPTIONS] == "" || _sharedObject.data[DATANAME_OPTIONS] == null) return null;
			return stringToDictionnary(DataManager.loadSharedObjectOptions());
		}
		
		static public function saveLocally(d:Dictionary):void {
			if(shouldEncryptFile()) {
				saveLocallyEncrypted(d);
				return ;
			}
			saveLocallyNotEncrypted(d);
		}
		
		static public function saveLocallyEncrypted(d:Dictionary):void {
			var obj:Object = dictToObject(d);
			var sveString:String = FlashUtils.myJSONStringify(obj);
			var saveBA:ByteArray = GetEncryptedByteArray(sveString);
			save(saveBA);
		}
		
		static public function saveLocallyNotEncrypted(d:Dictionary):void {
			var obj:Object = dictToObject(d);
			var sveString:String = FlashUtils.myJSONStringify(obj);
			saveNotEncrypted(sveString);
		}
		
		static public function saveLocallyOptions(d:Dictionary):void {
			var obj:Object = dictToObject(d);
			var sveString:String = FlashUtils.myJSONStringify(obj);
			saveOptions(sveString);
		}
				
		static public function stringToDictionnary(string:String):Dictionary {
			try{
				var obj:Object = (com.adobe.serialization.json.JSON.decode(string));
			}
			catch(e:Error){
				trace("ERROR TRYING TO PARSE JSON STRING!");
				trace(e.toString());
				trace(e.getStackTrace());
				return null;
			}
			return objToDictionary(obj);
		}
		
		static public function objToDictionary(obj:Object):Dictionary {
			var result:Dictionary = new Dictionary();
			for (var index : String in obj) {
				var child:Object = obj[index];
				switch(true) {
					case child is Number :
					case child is int :  
					case child is String : 
					case child is Boolean : 
					case child is Date : result[index] = child; break;
					case child is Object : result[index] = objToDictionary(child); break;  
				}
			}
			return result;
		}
		
		static public function dictToObject(obj:Dictionary):Object{
			return dictToObjectOuput(obj, new Object());
		}
		
		static public function dictToObjectOuput(obj:Dictionary, output:Object):Object{
			if(output == null) return null;
			for (var index : String in obj) {
				var child:Object = obj[index];
				switch(true) {
					case child is Number :
					case child is int :  
					case child is String :
					case child is Date :  
					case child is Boolean : output[index] = child; break;
					case child is Dictionary : output[index] = dictToObject(child as Dictionary); break;  
				}
			}
			return output;
		}
		
		
		static public function saveToFile(d:Dictionary):void {
			var obj:Object = dictToObject(d); 
			var result:String = FlashUtils.myJSONStringify(obj);
			var fr:FileReference = new FileReference();
			fr.save(result, "JSB_Level.txt");
		}
		
		static public function cloneDict(original:Dictionary):Dictionary {
		    var cloned:Dictionary = new Dictionary();
		    for(var key:Object in original) {
		      if( original[key]  is Dictionary)
		         cloned[key] = cloneDict(original[key]);
		      else
		         cloned[key] = original[key];
		    }
		    return cloned;
		}
		
		
		static public function GetEncryptedByteArray(code:String):ByteArray {
			var key:ByteArray = new ByteArray();
		 	var random:Random = new Random();
		 	random.nextBytes(key, 16);
			
		 	//store our data to encrypt into a ByteArray
		 	var cleartextBytes:ByteArray = new ByteArray();
		 	cleartextBytes.writeUTFBytes(code);
		 				
		 	//encrypt using 128b AES encryption using a random key
		 	var aes:ICipher = Crypto.getCipher("aes-ecb", key, Crypto.getPad("pkcs5"));
		 	aes.encrypt(cleartextBytes);
		 				
		 	//store key along with the data to decrypt
		 	//Note: normally you'd never do this for security reasons,
		 	//      but I'll leave it to the reader to handle additional
		 	//      security and/or obvuscation.
		 	var dataToStore:ByteArray = new ByteArray();
		 	dataToStore.writeBytes(key);
		 	dataToStore.writeBytes(cleartextBytes);
		 	return dataToStore;
		}
		
		static public function GetStringFromByteArrayLEGACY(dataToLoad:ByteArray):String{
			//read in our key
		 	var key:ByteArray = new ByteArray();
		 	dataToLoad.position = 0;
		 	dataToLoad.readBytes(key, 0, 16);
		 				
		 	//read in our encryptedText
		 	var encryptedBytes:ByteArray = new ByteArray();
		 	dataToLoad.readBytes(encryptedBytes);
		 				
		 	//decrypt using 128b AES encryption
		 	var aes:ICipher = Crypto.getCipher("aes-ecb", key, Crypto.getPad("pkcs5"));
		 	aes.decrypt(encryptedBytes);
		 	encryptedBytes.position = 0;
		 	return encryptedBytes.readUTF();
		}
		
		static public function GetStringFromByteArray(dataToLoad:ByteArray):String {		 
			//read in our key
		 	var key:ByteArray = new ByteArray();
		 	dataToLoad.position = 0;
		 	dataToLoad.readBytes(key, 0, 16);
		 				
		 	//read in our encryptedText
		 	var encryptedBytes:ByteArray = new ByteArray();
		 	dataToLoad.readBytes(encryptedBytes);
		 				
		 	//decrypt using 128b AES encryption
		 	var aes:ICipher = Crypto.getCipher("aes-ecb", key, Crypto.getPad("pkcs5"));
		 	aes.decrypt(encryptedBytes);
		 				
		 	encryptedBytes.position = 0;
		 	return encryptedBytes.readUTFBytes(encryptedBytes.bytesAvailable);
		}
	}
}
