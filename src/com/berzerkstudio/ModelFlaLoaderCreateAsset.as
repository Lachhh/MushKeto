package com.berzerkstudio {
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhhStarling.ModelFlaEnum;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	/**
	 * @author LachhhSSD
	 */
	public class ModelFlaLoaderCreateAsset {
		static private var callbackOnEnd:Callback ;
		static private var frFile : File;
		static private var crntModel : ModelFla;

		static public function loadAllFlas(pCallbackOnEnd : Callback) : void {
			ModelFla.registerClassForSerialization();
			callbackOnEnd = pCallbackOnEnd;
			loadNextFla();
		}
		
		static private function loadNextFla():void {
			crntModel = ModelFlaEnum.getFirstNotInit();
			if(crntModel.isNull) {
				callbackOnEnd.call();
				return ;
			}
			
			var filePath:String = "app:/" + "starling/modelFla/" + crntModel.id + ".asset";
			var appDirFile:File = new File(filePath);
			frFile = new File(appDirFile.nativePath);
			
			if(frFile.exists){
				frFile.deleteFile();
			}
			
			frFile = File.applicationDirectory.resolvePath(VersionInfo.relativeFolderForStarling + "/flashExported/" + crntModel.id+".xml");
			
			frFile.addEventListener(Event.COMPLETE, onLoadJSComplete);
			frFile.addEventListener(IOErrorEvent.IO_ERROR, onError);
			frFile.load();
		}
		
		static private function onLoadJSComplete(event : Event) : void {
			frFile.removeEventListener(Event.COMPLETE, onLoadJSComplete);
		   	crntModel.initFromXmlString(frFile.data.toString());
			
			var filePath:String = "app:/" + "starling/modelFla/" + crntModel.id + ".asset";
			var appDirFile:File = new File(filePath);
			var xmlFile:File = new File(appDirFile.nativePath);

			saveByteArray(xmlFile, crntModel);
			loadNextFla();
		}
		
		static private function onError(event : IOErrorEvent) : void {
			throw new Error("Can not found : " + crntModel.id + ".xml");
		}
		
		static private function saveByteArray(file:File, fla:ModelFla):void{
			var data:ByteArray = fla.saveToByteArray();
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(data);
			stream.close();
		}
	}
}
