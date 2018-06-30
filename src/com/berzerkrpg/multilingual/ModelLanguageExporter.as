package com.berzerkrpg.multilingual {
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.VersionInfo;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * @author LachhhSSD
	 */
	public class ModelLanguageExporter {
		static private var index : int = 0;
		private static var frFile : File;
		private static var modelLanguage:ModelLanguage;
		private static var callbackOnEnd:Callback;

		static public function exportAlLanguageToByteArray(pCallbackOnEnd:Callback) : void {
			ModelLanguage.registerClassForSerialization();
			callbackOnEnd = pCallbackOnEnd;
			index = -1;
			exportNextLanguage();
		}
		
		static public function exportNextLanguage():void {
			index++;
			if(index >= ModelLanguageEnum.getNum()) {
				trace("AllLAnguages Exported");
				if(callbackOnEnd) callbackOnEnd.call();
				return;
			}
			
			modelLanguage = ModelLanguageEnum.getFromIndex(index);
			if(hasToSkipLanguage(modelLanguage)) {
				exportNextLanguage();
				return;
			}
			
			var filePath:String = "app:/" + "starling/languages/" + modelLanguage.id + ".asset";
			var appDirFile:File = new File(filePath);
			frFile = new File(appDirFile.nativePath);
			
			if(frFile.exists){
				frFile.deleteFile();
			}
			
			saveByteArray(frFile, modelLanguage);
			exportNextLanguage();
			
		}
		
		static public function hasToSkipLanguage(modelLanguage:ModelLanguage):Boolean {
			if(modelLanguage.isEquals(ModelLanguageEnum.ENGLISH)) return true;
			if(modelLanguage.isEquals(ModelLanguageEnum.EXPORTED)) return true;
			if(modelLanguage.isEquals(ModelLanguageEnum.HODOR)) return true;
			return false;
		}
		
		static private function saveByteArray(file:File, fla:ModelLanguage):void{
			var data:ByteArray = fla.saveToByteArray();
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(data);
			stream.close();
		}
	}
}
