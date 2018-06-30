package com.berzerkstudio {
	import com.lachhh.io.Callback;
	import com.lachhh.lachhhengine.VersionInfo;
	import com.lachhhStarling.ModelFlaEnum;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	/**
	 * @author LachhhSSD
	 */
	public class ModelFlaLoaderCreateAssetDirtyOnly {
		static private var callbackOnEnd:Callback ;
		static private var frFile : File;
		static private var crntModel : ModelFla;
		
		static private var _sharedObject : SharedObject = SharedObject.getLocal("ModelFlaLoaderCreateAssetDirtyOnly");
		// static public var loadAll : Boolean = true;
		private static var modelFlaBunch : Vector.<ModelFla>;
		private static var frFileAsset : File;

		static public function loadAllFlas(pCallbackOnEnd : Callback) : void {
			loadBunch(ModelFlaEnum.ALL.slice(), pCallbackOnEnd);
		}
		
		static private function loadNextFla():void {
			
			if(modelFlaBunch.length <= 0) {
				callbackOnEnd.call();
				return ;
			}
			crntModel = modelFlaBunch.shift();
			frFile = File.applicationDirectory.resolvePath(VersionInfo.relativeFolderForStarling + "/flashExported/" + crntModel.id+".xml");
			frFileAsset = File.applicationDirectory.resolvePath(VersionInfo.relativeFolderForStarling + "starling/modelFla/" + crntModel.id + ".asset");
			 
			if(!frFileAsset.exists || isNeedToRecreate(crntModel, frFile)) {
				createAssetFromXML();
			} else {
				/*if(loadAll) {
					loadFromAsset();
				} else {*/
					loadNextFla();
				//}
				
			}
			
		}

		private static function loadFromAsset() : void {
			frFile = File.applicationDirectory.resolvePath(VersionInfo.relativeFolderForStarling + "starling/modelFla/" + crntModel.id + ".asset");
			
			if(frFile.exists){
				frFile.addEventListener(Event.COMPLETE, onByteDataLoaded);
				frFile.addEventListener(IOErrorEvent.IO_ERROR, onByteDataFailure);
				frFile.load();
			} else {
				createAssetFromXML();
			}
		}
		
		static private function onByteDataLoaded(event:Event):void{
			frFile.removeEventListener(Event.COMPLETE, onByteDataLoaded);
			crntModel.loadFromByteArray(frFile.data);
			loadNextFla();
		}
		
		static private function onByteDataFailure(event:Event):void{
			throw new Error("Failed loading byte data for: " + crntModel.id + ".asset");
		}
		
		static private function createAssetFromXML():void {
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
		
		static private function isNeedToRecreate(crntModel:ModelFla, f:File):Boolean {
			if(f == null) return true;
			var fileDate:String = _sharedObject.data[crntModel.id];
			if(fileDate == f.modificationDate.toString()) return false;
			return true;
		}
		
		static private function saveNewDate(f:File):void {
			_sharedObject.data[crntModel.id] = f.modificationDate.toString();
		}
		
		static private function onLoadJSComplete(event : Event) : void {
			saveNewDate(frFile);
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
		
		static private function getFirstNotInit() : ModelFla {
			return ModelFlaEnum.getFirstNotInitIn(modelFlaBunch) ;
		}

		static public function loadModelFlaAsset(m : ModelFla, onEndCallback : Callback) : void {
			var array:Vector.<ModelFla> = new Vector.<ModelFla>();
			array.push(m);
			loadBunch(array, onEndCallback);
		}

		static public function loadBunch(m : Vector.<ModelFla>, onEndCallback : Callback) : void {
			ModelFla.registerClassForSerialization();
			callbackOnEnd = onEndCallback;
			modelFlaBunch = m;
			loadNextFla();
		}

		static public function isModelFlaAssetLoaded(model : ModelFla) : Boolean {
			return model.isLoaded;
		}
	}
}
