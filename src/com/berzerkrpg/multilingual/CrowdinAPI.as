package com.berzerkrpg.multilingual {
	import flash.events.HTTPStatusEvent;
	import flash.net.URLRequestHeader;
	import com.lachhh.io.HttpPostData;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import com.lachhh.io.Callback;
	import flash.utils.Dictionary;
	import com.lachhh.lachhhengine.DataManager;
	import deng.fzip.FZipFile;
	import flash.net.URLLoaderDataFormat;
	import flash.utils.ByteArray;
	import deng.fzip.FZip;
	import flash.events.Event;
	import com.lachhh.flash.FlashUtils;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.lachhh.lachhhengine.VersionInfoDONOTSTREAM;
	import flash.system.Security;
	import com.lachhh.lachhhengine.VersionInfo;
	/**
	 * @author Eel
	 */
	public class CrowdinAPI {
		
		private static var GET_TRANSLATION_STATUS:String = "https://api.crowdin.com/api/project/[project-identifier]/status?key=[project-key]&json";
		
		private static var DOWNLOAD_TRANSLATIONS:String = "https://api.crowdin.com/api/project/[project-identifier]/download/[package].zip?key=[project-key]";
		
		private static var REQUEST_BUILD:String = "https://api.crowdin.com/api/project/[project-identifier]/export?key=[project-key]&json";
		
		private static var UPDATE_FILE:String = "https://api.crowdin.com/api/project/[project-identifier]/update-file?key=[project-key]&json";
		
		private static var callbackOnAllLoaded:Callback;
		private static var callbackOnBuildResponse:Callback;
		private static var callbackOnUploadResponse:Callback;
		
		private static var META_LANGUAGES:Array = new Array();
		
		private static var _zip:FZip;
		
		public static function uploadEnglishCSVData(languageData:String, callbackOnComplete:Callback):void{
			callbackOnUploadResponse = callbackOnComplete;
			
			var langByteArray:ByteArray = new ByteArray();
			langByteArray.writeUTFBytes(languageData);
			
			var loader:URLLoader = new URLLoader();
			var request : URLRequest = new URLRequest(uploadLanguageUrl());
			//request.method = URLRequestMethod.POST;
			//request.contentType = 'multipart/form-data; boundary=' + HttpPostData.getBoundary();
			//request.requestHeaders.push( new URLRequestHeader( 'Cache-Control', 'no-cache' ) );
			var data:HttpPostData = new HttpPostData();
			data.addFile("files[lang_en.csv]", langByteArray, "lang_en.csv");
			data.close();
			data.bind(request);
			
			//loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, onUploadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onUploadError);
			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHttpStatus);
			loader.load(request);
		}
		
		private static function onHttpStatus(event:Event):void{
			//trace(event);
		}
		
		private static function onUploadComplete(event:Event):void{
			trace("[CROWDIN: TEXT FACTORY UPLOAD RESPONSE]");
			//trace(event);
			var loader:URLLoader = URLLoader(event.target);
			trace(loader.data);
			if(callbackOnUploadResponse) callbackOnUploadResponse.callWithParams(["response! - success"]);
		}
		
		private static function onUploadError(event:Event):void{
			trace(event.toString());
			if(callbackOnUploadResponse) callbackOnUploadResponse.callWithParams(["error!"]);
		}
		
		public static function requestBuild(callbackOnComplete:Callback):void{
			callbackOnBuildResponse = callbackOnComplete;
			var request:URLRequest = new URLRequest(requestBuildUrl());
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onBuildComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorBuild);
			loader.load(request);
		}
		
		private static function onBuildComplete(event:Event):void{
			var loader:URLLoader = URLLoader(event.target);
			var obj:Object = FlashUtils.myJSONParse(loader.data);
			var status:String = obj["success"]["status"];
			if(callbackOnBuildResponse) callbackOnBuildResponse.callWithParams(["response! - " + status]);
		}
		
		private static function onErrorBuild(event:Event):void{
			if(callbackOnBuildResponse) callbackOnBuildResponse.callWithParams(["error!"]);
		}
		
		public static function downloadSupportedLanguages(callbackOnComplete:Callback):void{
			callbackOnAllLoaded = callbackOnComplete;
			
			if(!VersionInfo.modelPlatform.isDesktop()) {
				Security.allowDomain("*");
				Security.allowInsecureDomain("*");
			}
			
			trace("[CROWDIN: GETTING STATUS...]");
			
			var request:URLRequest = new URLRequest(getTranslationStatus());
			var loader:URLLoader = new URLLoader();
			
			loader.addEventListener(Event.COMPLETE, onTranslationStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			loader.load(request);
		}
		
		private static function onTranslationStatus(event:Event):void{
			trace("[CROWDIN: GETTING TRANSLATION DATA...]");
			
			var loader:URLLoader = URLLoader(event.target);
			
			var obj:Object = FlashUtils.myJSONParse(loader.data);
			var list:Array = obj as Array;
			
			for(var i:int = 0; i < list.length; i++){
				META_LANGUAGES.push(MetaCrowdinLanguage.createFromJson(list[i]));
			}
			
			var request:URLRequest = new URLRequest(downloadTranslationZip());
			var newLoader:URLLoader = new URLLoader();
			
			newLoader.addEventListener(Event.COMPLETE, onTranslationsDownloaded);
			newLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			newLoader.dataFormat = URLLoaderDataFormat.BINARY;
			newLoader.load(request);
		}
		
		private static function onTranslationsDownloaded(event:Event):void{
			var loader:URLLoader = URLLoader(event.target);
			
			_zip = new FZip();
			_zip.loadBytes(loader.data);
			var files:int = _zip.getFileCount();
			trace("[CROWDIN TRANSLATIONS DOWNLOADED: " + files + " FILES]");
			
			for(var i:int = 0; i < META_LANGUAGES.length; i++){
				var meta:MetaCrowdinLanguage = META_LANGUAGES[i];
				if(meta.isAvailable) addLanguageFromZip(meta);
			}
			
			if(callbackOnAllLoaded) callbackOnAllLoaded.call();
		}
		
		private static function addLanguageFromZip(metaLanguage:MetaCrowdinLanguage):void{
			var result:ModelLanguage = ModelLanguageEnum.getFromCrowdInId(metaLanguage.id);
			
			//var needsToPushToEnum:Boolean = false;
			
			if(result.isNull){
				return ;
				//result = new ModelLanguage(metaLanguage.id, metaLanguage.name);
				//needsToPushToEnum = true;
			}
			
			var data:ByteArray = getTranslationByteArray(metaLanguage.id);
			var csv:String = data.readUTFBytes(data.length);
			result.copyFrom(ModelLanguageEnum.ENGLISH);
			var isValid:Boolean = result.tryToDecodeFromCSV(csv);
			if(isValid) {
				//if(needsToPushToEnum) ModelLanguageEnum.ALL.push(result);
				//trace("[CROWDIN LANGUAGE ADDED: " + metaLanguage.name + " ]");
			}
		}
		
		private static function getTranslationByteArray(code:String):ByteArray{
			if(_zip == null) throw new Error("NO TRANSLATION DATA DOWNLOADED!");
			
			var asset:FZipFile = _zip.getFileByName(code + "/lang_en.csv");
			
			if(asset == null) throw new Error("NO TRANSLATION WITH THAT CODE!");
			
			return asset.content;
		}
		
		static private function onError(event : Event) : void {
			// do nothing
			if(callbackOnAllLoaded) callbackOnAllLoaded.call();
		}
		
		private static function uploadLanguageUrl():String{
			var result:String = UPDATE_FILE;
			result = result.replace("[project-identifier]", "zombidle");
			result = result.replace("[project-key]", VersionInfoDONOTSTREAM.CROWDIN_API_KEY);
			return result;
		}
		
		private static function requestBuildUrl():String{
			var result:String = REQUEST_BUILD;
			result = result.replace("[project-identifier]", "zombidle");
			result = result.replace("[project-key]", VersionInfoDONOTSTREAM.CROWDIN_API_KEY);
			return result;
		}
		
		private static function getTranslationStatus():String{
			var result:String = GET_TRANSLATION_STATUS;
			
			result = result.replace("[project-identifier]", "zombidle");
			result = result.replace("[project-key]", VersionInfoDONOTSTREAM.CROWDIN_API_KEY);
			
			return result;
		}
		
		private static function downloadTranslationZip():String{
			var result:String = DOWNLOAD_TRANSLATIONS;
			
			result = result.replace("[project-identifier]", "zombidle");
			result = result.replace("[project-key]", VersionInfoDONOTSTREAM.CROWDIN_API_KEY);
			result = result.replace("[package]", "all");
			
			return result;
		}
	}
}