package com.berzerkrpg.multilingual {
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.VersionInfo;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;

	/**
	 * @author LachhhSSD
	 */
	public class ModelLanguageImporter {
		static private var callbackOnEnd:Callback ;
		
		static private var frFile : File;
		static private var index : int = 0;
		static private var modelLanguage : ModelLanguage;

		public function ModelLanguageImporter() {
			
		}

		static public function loadAllLanguages(pCallbackOnEnd : Callback) : void {
			ModelLanguage.registerClassForSerialization();
			callbackOnEnd = pCallbackOnEnd;
			index = -1;
			loadNextLanguage();
		}
				
		static private function loadNextLanguage():void {
			index++;
			if(index >= ModelLanguageEnum.getNum()) {
				trace("AllLAnguages Imported");
				if(callbackOnEnd) callbackOnEnd.call();
				return;
			}
			
			modelLanguage = ModelLanguageEnum.getFromIndex(index);
			if(ModelLanguageExporter.hasToSkipLanguage(modelLanguage)) {
				loadNextLanguage();
				return;
			}
			
			frFile = File.applicationDirectory.resolvePath(VersionInfo.relativeFolderForStarling + "starling/languages/" + modelLanguage.id + ".asset");
			
			if(frFile.exists){
				frFile.addEventListener(Event.COMPLETE, onByteDataLoaded);
				frFile.addEventListener(IOErrorEvent.IO_ERROR, onByteDataFailure);
				frFile.load();
			} else {
				trace("[ERROR] ModelLanguageImporter : Language asset not found : " + modelLanguage.id + ".asset");
				loadNextLanguage();
			}
		}
		
		static private function onByteDataLoaded(event:Event):void{
			frFile.removeEventListener(Event.COMPLETE, onByteDataLoaded);
			modelLanguage.loadFromByteArray(frFile.data);
			loadNextLanguage();
		}
		
		static private function onByteDataFailure(event:Event):void{
			trace("[ERROR] ModelLanguageImporter : Failed loading byte data for: " + modelLanguage.id + ".asset");
			loadNextLanguage();
		}
	}
}
